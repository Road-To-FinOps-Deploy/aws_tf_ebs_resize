resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm_ebs_free_space" {
  alarm_name          = "cloudwatch_metric_alarm_ebs_free_space"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = var.metric_name
  period              = "120"
  statistic           = "Average"
  namespace           = var.namespace
  threshold           = var.threshold
  alarm_description   = "This metric monitors ebs percentage of free space"
  alarm_actions       = [aws_sns_topic.statemachine_trigger.arn]
  dimensions = {
    InstanceId = var.InstanceId
  }
}

