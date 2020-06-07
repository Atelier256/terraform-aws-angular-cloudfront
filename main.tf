// S3 bucket
data "template_file" "bucket-policy" {
  template = "${path.module}/policies/bucket-policy.tpl"
  vars = {
    cloudfront_identity = aws_cloudfront_origin_access_identity.origin_access_identity.id
    bucket_id = var.s3-bucket-name
  }
}

resource "aws_s3_bucket" "cloudfront" {
  bucket = var.s3-bucket-name
  acl = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  policy = data.template_file.bucket-policy.rendered
  tags = var.s3-tags
}

resource "aws_s3_bucket_public_access_block" "cloudfront" {
  bucket = aws_s3_bucket.cloudfront.id
  block_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}

// CloudFront Distribution
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.access-identity-comment
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled = true
  comment = var.distribution-comment
  price_class = var.price_class
  is_ipv6_enabled = var.is_ipv6_enabled
  http_version = var.http_version
  default_root_object = var.default_root_object
  origin {
    domain_name = aws_s3_bucket.cloudfront.bucket_regional_domain_name
    origin_id = "S3-${aws_s3_bucket.cloudfront.arn}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]
    cached_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]
    target_origin_id = "S3-${aws_s3_bucket.cloudfront.arn}"
    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
    compress = var.enable_cloudfront_compress
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  custom_error_response {
    error_code = 403
    error_caching_min_ttl = var.error_caching_min_ttl
    response_code = 200
    response_page_path = "/${var.default_root_object}"
  }
  custom_error_response {
    error_code = 404
    error_caching_min_ttl = var.error_caching_min_ttl
    response_code = 200
    response_page_path = "/${var.default_root_object}"
  }
  viewer_certificate {
    cloudfront_default_certificate = var.use_cloudfront_default_certificate
    acm_certificate_arn = var.workspace_acm_certificate
    ssl_support_method = var.ssl_support_method
    minimum_protocol_version = var.minimum_protocol_version
  }
  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
    }
  }
  tags = var.cloudfront-tags
  aliases = var.domain-aliases
  wait_for_deployment = var.wait_for_deployment
}

// IAM for Deployments
data "aws_caller_identity" "deployment" {
  count = length(var.iam_user_name) > 0 ? 1 : 0
}

data "template_file" "iam-policy" {
  template = "${path.module}/policies/allow-deployment.tpl"
  vars = {
    bucket_name = var.s3-bucket-name
    account_id = data.aws_caller_identity.deployment[0].account_id
    distribution_id = aws_cloudfront_distribution.distribution.id
  }
}


resource "aws_iam_policy" "deployment" {
  count = length(var.iam_user_name) > 0 ? 1 : 0
  policy = data.template_file.iam-policy.rendered
}

resource "aws_iam_user" "deployment" {
  count = length(var.iam_user_name) > 0 ? 1 : 0
  name = var.iam_user_name
}

resource "aws_iam_policy_attachment" "deployment" {
  count = length(var.iam_user_name) > 0 ? 1 : 0
  users = [
    aws_iam_user.deployment[0].name
  ]
  name = var.aws_iam_policy_attachment_name
  policy_arn = aws_iam_policy.deployment[0].arn
}

resource "aws_iam_access_key" "deployment" {
  count = length(var.iam_user_name) > 0 ? 1 : 0
  user = aws_iam_user.deployment[0].name
}
