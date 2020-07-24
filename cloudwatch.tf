resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm_ebs_free_space" {
  alarm_name          = "cloudwatch_metric_alarm_ebs_free_space"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeDiskPercentage"
  period              = "120"
  statistic           = "Average"
  namespace           = "Windows/Default"
  threshold           = "10"
  alarm_description   = "This metric monitors ebs percentage of free space"
  alarm_actions       = [aws_sns_topic.statemachine_trigger.arn]
  dimensions = {
    InstanceId = "i-0af41048342a925ff"
    #AutoScalingGroupName = "${aws_autoscaling_group.bar.name}"
  }
}
