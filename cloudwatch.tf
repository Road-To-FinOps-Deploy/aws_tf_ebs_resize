resource "aws_cloudwatch_metric_alarm" "windows_cloudwatch_metric_alarm_ebs_free_space" {
  alarm_name          = "windows_cloudwatch_metric_alarm_ebs_free_space"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeDiskPercentage"
  period              = "120"
  statistic           = "Average"
  namespace           = "Windows/Default"
  threshold           = var.threshold
  alarm_description   = "This metric monitors ebs percentage of free space"
  alarm_actions       = [aws_sns_topic.statemachine_trigger.arn]
  dimensions = {
    InstanceId = var.WindowsInstanceId
  }
}

resource "aws_cloudwatch_metric_alarm" "linux_cloudwatch_metric_alarm_ebs_free_space" {
  alarm_name          = "linux_cloudwatch_metric_alarm_ebs_free_space"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUsed"
  period              = "120"
  statistic           = "Average"
  namespace           = "System/Linux"
  threshold           = var.threshold
  alarm_description   = "This metric monitors ebs percentage of free space"
  alarm_actions       = [aws_sns_topic.statemachine_trigger.arn]
  dimensions = {
    InstanceId = var.LinuxInstanceId
  }
}