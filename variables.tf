variable "distribution-comment" {
  type = string
  description = "The Comment what will be written for the Distribution"
  default = "Generated by Terraform Angular CloudFront Module"
}

variable "access-identity-comment" {
  type = string
  description = "The Comment what will be written inside the Access Identity Key"
  default = "Generated by Terraform Angular CloudFront Module"
}

variable "s3-bucket-name" {
  type = string
  description = "The unique name of the S3 bucket name where the code uploaded will be stored"
}

variable "is-ditribution-enabled" {
  type = bool
  description = "Whether or not the Distribution is enabled"
  default = true
}

variable "error_caching_min_ttl" {
  type = number
  description = "The time you want to cache error for 400, 403 and 404"
  default = 10
}

variable "default_root_object" {
  type = string
  description = "The Default root object where all the requests will arrive, by default index.html"
  default = "index.html"
}

variable "domain-aliases" {
  type = list(string)
  description = "The domain aliases if applicable"
  default = []
}

variable "wait_for_deployment" {
  type = bool
  description = "Whether or not the process should be blocked until deployment is completed on CloudFront side (Can take up to 15 minutes if enabled)"
  default = false
}

variable "s3-tags" {
  type = map(string)
  description = "The Tags you want to apply to the S3 bucket"
  default = {}
}

variable "cloudfront-tags" {
  type = map(string)
  description = "The Tags you want to apply to the CloudFront Distribution"
  default = {}
}

variable "price_class" {
  type = string
  description = "The CloudFront Price Class (see Terraform Documentation), by default PriceClass_200 (U.S., Canada, Europe, Asia, Middle East and Africa)"
  default = "PriceClass_200"
}

variable "is_ipv6_enabled" {
  type = bool
  description = "Whether or not the ipv6 is enabled, true by default"
  default = true
}

variable "workspace_acm_certificate" {
  type = string
  description = "The ACM certificate ARN (located in Region us-east-1)"
}

variable "restriction_type" {
  type = string
  description = "The type of restriction to apply to CloudFront Distribution"
  default = "none"
}

variable "http_version" {
  type = string
  description = "The http version to use"
  default = "http2"
}

variable "ssl_support_method" {
  type = string
  description = "The SSL Method to support, can be sni-only or vip"
  default = "sni-only"
}

variable "minimum_protocol_version" {
  type = string
  description = "A supported suite of Protocols and Ciphers by the CloudFront Distribution. Must be one of the listed in CloudFront Documentation."
  default = "TLSv1.2_2018"
}

variable "enable_cloudfront_compress" {
  type = bool
  description = "If yes or no the CloudFront Compression should be enabled"
  default = true
}

variable "use_cloudfront_default_certificate" {
  type = bool
  description = "If yes or no you want to use the default CloudFront Certificate and then use the Domain name provided by CloudFront"
  default = false
}

variable "viewer_protocol_policy" {
  type = string
  description = "By Default the module enable redirect Http to Https. If you want a different behaviour you can change the value"
  default = "redirect-to-https"
}

variable "iam_user_name" {
  type = string
  description = "The username for the user to be created with upload rights to CloudFront Distribution"
  default = ""
}

variable "aws_iam_policy_attachment_name" {
  type = string
  description = "The Policy Attachment name for the deployment user"
  default = ""
}