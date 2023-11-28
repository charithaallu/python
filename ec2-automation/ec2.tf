locals {
  lambda_zip_location_ca = "outputs/lambda-ca.zip"
}

data "archive_file" "lambda-ca" {
  type        = "zip"
  source_file = "lambda-ca.py"
  output_path = "${local.lambda_zip_location_ca}"
}

resource "aws_lambda_function" "ec2-stop-instances-ca" {
  filename      = "${local.lambda_zip_location_ca}" 
  function_name = "lambda-ca"
  role          = aws_iam_role.ec2-stop-instances.arn
  handler       = "lambda-ca.lambda_handler"

  source_code_hash = base64sha256("local.lambda_zip_location_ca")
  runtime = "python3.8"
  timeout= 63
}

resource "aws_cloudwatch_event_rule" "ec2-stop-instances-ca" {
  name        = "ec2-stop-instances-ca-region"
  description = "trigger ec2 stop instances every 5 min"
  schedule_expression = "cron(* 02 ? * MON-FRI *)"
}
`
resource "aws_cloudwatch_event_target" "lambda-target-ca" {
  rule      = aws_cloudwatch_event_rule.ec2-stop-instances-ca.name
  target_id = "lambda-ca"
  arn       = aws_lambda_function.ec2-stop-instances-ca.arn 
}

resource "aws_lambda_permission" "allow_cloudwatch_ca" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2-stop-instances-ca.function_name
  principal     = "events.amazonaws.com"
  source_arn   = aws_cloudwatch_event_rule.ec2-stop-instances-ca.arn  
}
###role###
resource "aws_iam_role" "ec2-stop-instances" {
  name = "ec2-stop-instances"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "ec2-stop-instances-policy" {
  name        = "ec2-stop-instances"
  path        = "/"
  
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeRegions",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "lambda:PublishLayerVersion"
      ],
      "Resource": "*"
    },
  ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-stop-policy-attach" {
  role = aws_iam_role.ec2-stop-instances.name
  policy_arn = aws_iam_policy.ec2-stop-instances-policy.arn
}
