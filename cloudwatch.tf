locals {
  alarm_description = var.alarm.description != null ? var.alarm.description : "SNS Topic Dashboard: https://${module.this.aws_region}.console.aws.amazon.com/sns/v3/home?region=${module.this.aws_region}#/topic/arn:aws:sns:${module.this.aws_region}:${module.this.aws_account_id}:${module.sns_label.id}"
  alarm_topic_arn   = var.alarm_topic_arn != null ? var.alarm_topic_arn : "arn:aws:sns:${module.this.aws_region}:${module.this.aws_account_id}:${module.this.environment}-alarms"
}

resource "aws_cloudwatch_metric_alarm" "success_rate" {
  count = var.alarm_enabled ? 1 : 0

  alarm_description = jsonencode(merge({
    Severity    = "warning"
    Description = local.alarm_description
  }, module.this.tags, module.this.additional_tag_map))
  alarm_name          = "${module.sns_label.id}-sns-success-rate"
  comparison_operator = "LessThanThreshold"
  datapoints_to_alarm = var.alarm.datapoints_to_alarm
  evaluation_periods  = var.alarm.evaluation_periods
  tags                = module.this.tags
  threshold           = var.alarm.threshold
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "published"
    return_data = false

    metric {
      dimensions = {
        TopicName = module.sns.topic_name
      }
      metric_name = "NumberOfMessagesPublished"
      namespace   = "AWS/SNS"
      period      = var.alarm.period
      stat        = "Sum"
    }
  }

  metric_query {
    id          = "failed"
    return_data = false

    metric {
      dimensions = {
        TopicName = module.sns.topic_name
      }
      metric_name = "NumberOfNotificationsFailed"
      namespace   = "AWS/SNS"
      period      = var.alarm.period
      stat        = "Sum"
    }
  }

  metric_query {
    expression  = "100-100*(failed/published)"
    id          = "e1"
    label       = "100-100*(failed/published)"
    return_data = true
  }

  alarm_actions = [local.alarm_topic_arn]
  ok_actions    = [local.alarm_topic_arn]
}
