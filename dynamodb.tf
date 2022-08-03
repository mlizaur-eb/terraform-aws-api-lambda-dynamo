data "aws_iam_policy_document" "dynamodb_policy_document" {
  statement {
    actions = [
      "dynamodb:*",
    ]

    resources = [
      aws_dynamodb_table.event_creation_onboarding.arn,
    ]
  }
}

resource "aws_iam_policy" "dynamodb_full_access_policy" {
  name   = "dynamodb-${var.dynamo_table}-full-access-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.dynamodb_policy_document.json
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.dynamo_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.dynamo_hash_key

  attribute {
    name = "${var.dynamo_hash_key}"
    type = "S"
  }

  tags = {
    Name        = "dynamo-${var.dynamo_table}-table"
    Environment = "${var.dynamo_env}"
  }
}
