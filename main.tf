locals {
  topic_policy_statements = var.subscription_aws_account_id != null ? {
    subscription = {
      actions = ["sns:Subscribe"]

      principals = [
        {
          type        = "AWS"
          identifiers = [var.subscription_aws_account_id]
        }
      ]
    }
  } : {}
}

module "sns_label" {
  source  = "justtrackio/label/null"
  version = "0.26.0"

  label_value_case = "none"

  context = module.this.context
}

module "sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "6.1.2"

  name = module.sns_label.id
  tags = module.sns_label.tags

  topic_policy_statements = local.topic_policy_statements
}
