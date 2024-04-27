data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "boundary" {
  name               = "lambda-on-call-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "cd src && GOOS=linux GOARCH=arm64 go build -tags lambda.norpc -o bootstrap main.go"
  }
}

data "archive_file" "boundary" {
  type        = "zip"
  source_file = "src/bootstrap"
  output_path = "lambda.zip"

  depends_on = [
    null_resource.build
  ]
}

resource "aws_lambda_function" "boundary" {
  function_name    = "on-call-role-administrator"
  role             = aws_iam_role.boundary.arn
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  filename         = data.archive_file.boundary.output_path
  source_code_hash = data.archive_file.boundary.output_base64sha256
  architectures    = ["arm64"]
  environment {
    variables = {
      BOUNDARY_ADDR             = var.boundary_cluster_url
      BOUNDARY_USERNAME         = boundary_account_password.lambda.login_name
      BOUNDARY_PASSWORD         = boundary_account_password.lambda.password
      BOUNDARY_AUTH_METHOD_ID   = data.boundary_auth_method.password.id
      BOUNDARY_ON_CALL_ROLE_ID  = boundary_role.alert.id
      BOUNDARY_ON_CALL_GROUP_ID = boundary_group.oncall.id
    }
  }
}

resource "aws_lambda_permission" "cloudwatch_trigger" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.boundary.function_name
  principal     = "lambda.alarms.cloudwatch.amazonaws.com"
}
