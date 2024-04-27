resource "aws_cloudwatch_metric_alarm" "trigger" {
  alarm_name      = "ec2-cpu-alarm"
  actions_enabled = true

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  dimensions = {
    "InstanceId" = aws_instance.ec2.id
  }

  statistic           = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 50
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  period              = 60
  treat_missing_data  = "notBreaching"

  # trigger the Boundary lambda function for all state changes
  ok_actions                = [aws_lambda_function.boundary.arn]
  alarm_actions             = [aws_lambda_function.boundary.arn]
  insufficient_data_actions = [aws_lambda_function.boundary.arn]
}
