data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-WebRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "s3_read" {
  statement {
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.image_bucket_name}",
      "arn:aws:s3:::${var.image_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_read" {
  name   = "${var.name_prefix}-WebS3Policy"
  policy = data.aws_iam_policy_document.s3_read.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3_read.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name_prefix}-WebInstanceProfile"
  role = aws_iam_role.this.name
}
