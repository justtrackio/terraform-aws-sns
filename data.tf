data "aws_sns_topic" "alarms" {
  name = "${module.this.environment}-alarms"
}
