output "cloudfront-distribution-id" {
  value = aws_cloudfront_distribution.front-end.id
}

output "cloudfront-distribution-arn" {
  value = aws_cloudfront_distribution.front-end.arn
}

output "cloudfront-distribution-domain-name" {
  value = aws_cloudfront_distribution.front-end.domain_name
}

output "aws_secret_access_key_deployment_user" {
  value = length(aws_iam_access_key.deployment) > 0 ? aws_iam_access_key.deployment[0].secret : ""
  sensitive = true
}

output "aws_access_key_id_deployment_user" {
  value = length(aws_iam_access_key.deployment) > 0 ? aws_iam_access_key.deployment[0].id : ""
  sensitive = true
}

