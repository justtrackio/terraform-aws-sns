variable "alarm" {
  type = object({
    datapoints_to_alarm = optional(number, 3)
    description         = optional(string, null)
    evaluation_periods  = optional(number, 3)
    period              = optional(number, 60)
    threshold           = optional(number, 99)
  })
  description = ""
  default     = {}
}

variable "alarm_enabled" {
  type        = bool
  default     = false
  description = "Defines if alarms should be created"
}
