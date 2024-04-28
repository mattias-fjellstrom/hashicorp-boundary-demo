data "http" "public_key" {
  method = "GET"
  url    = "${var.vault_cluster_url}/v1/ssh-client-signer/public_key"

  retry {
    attempts     = 10
    min_delay_ms = 1000
    max_delay_ms = 5000
  }

  request_headers = {
    "X-Vault-Namespace" = "admin"
  }

  depends_on = [
    vault_mount.ssh,
    vault_ssh_secret_backend_ca.boundary,
    vault_ssh_secret_backend_role.boundary_client,
  ]
}

data "cloudinit_config" "ec2" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      echo "${data.http.public_key.response_body}" >> /etc/ssh/trusted-user-ca-keys.pem
      echo 'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem' | sudo tee -a /etc/ssh/sshd_config
      sudo systemctl restart sshd.service
    EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      sudo apt update
      sudo apt install -y stress rand

      # random sleep between 0 and 300 seconds
      sleep $(rand -M 300)

      # stress all cpus for three minutes
      stress --cpu $(nproc) --timeout 180
    EOF
  }
}

resource "aws_security_group" "ec2" {
  name   = "ec2-targets"
  vpc_id = var.aws_vpc_id

  // allow inbound traffic from the internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // allow outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-targets"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical account ID
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = var.aws_subnet_id

  user_data_base64            = data.cloudinit_config.ec2.rendered
  associate_public_ip_address = true
  monitoring                  = true

  tags = {
    Name = "Boundary Target"
  }
}
