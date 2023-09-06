variable "alarm" {
  type = object({
    datapoints_to_alarm = optional(number, 3)
    description         = optional(string, null)
    evaluation_periods  = optional(number, 3)
    period              = optional(number, 60)
    threshold           = optional(number, 99)
  })
  description = "The details of the alarm such as datapoints to alarm, evaluation periods, backlog minutes, period, and threshold."
  default     = {}
}

variable "alarm_enabled" {
  type        = bool
  default     = false
  description = "Defines if alarms should be created"
}

variable "alarm_topic_arn" {
  type        = string
  description = "The ARN of the SNS Topic used for notifying about alarm/ok messages."
  default     = null
}

variable "subscription_aws_account_id" {
  type        = string
  description = "The AWS account ID for the subscription."
}
