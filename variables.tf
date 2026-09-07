variable "app_name" {
  description = "Name prefix applied to CloudFront resources and their tags."
  type        = string
}

variable "enable_custom_domain" {
  description = "Whether to attach an alias and ACM certificate. When false the distribution is reachable only on its cloudfront.net domain."
  type        = bool
}

variable "full_domain" {
  description = "Fully qualified domain served by the distribution, for example www.example.com."
  type        = string
  default     = null
}

variable "enable_dr" {
  description = "Whether to add the DR region as a failover origin. When false only the primary origin is configured."
  type        = bool
}

variable "primary_lambda_function_url" {
  description = "Function URL of the primary-region SSR Lambda, used as the origin for dynamic requests."
  type        = string
}

variable "dr_lambda_function_url" {
  description = "Function URL of the DR-region SSR Lambda, used as the failover origin. Ignored when enable_dr is false."
  type        = string
  default     = null
}

variable "lambda_oac_id" {
  description = "Origin access control ID used to sign requests to the Lambda function URLs."
  type        = string
}

variable "static_assets_regional_domain_name" {
  description = "Regional domain name of the primary static assets bucket."
  type        = string
}

variable "static_assets_dr_regional_domain_name" {
  description = "Regional domain name of the DR static assets bucket. Ignored when enable_dr is false."
  type        = string
  default     = null
}

variable "oai_cloudfront_access_identity_path" {
  description = "Origin access identity path used to read from the static assets buckets."
  type        = string
}

variable "primary_region" {
  description = "Region hosting the primary origins."
  type        = string
}

variable "dr_region" {
  description = "Region hosting the failover origins."
  type        = string
}

variable "lambda_signed_origin_request_policy_id" {
  description = "Origin request policy applied to Lambda origins, controlling which headers, cookies and query strings are forwarded."
  type        = string
}

variable "ssr_swr_cache_policy_id" {
  description = "Cache policy applied to SSR responses, providing stale-while-revalidate behaviour."
  type        = string
}

variable "certificate_arn" {
  description = "ARN of an ACM certificate in us-east-1 covering full_domain. Required when enable_custom_domain is true."
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Tags applied to every resource this module creates."
  type        = map(string)
  default     = {}
}

variable "static_root_path_patterns" {
  description = "Path patterns served from the static assets origin instead of the SSR Lambda. Root-level files such as /favicon.ico, /robots.txt or /apple-touch-icon.png ship with the static assets but would otherwise resolve against the Lambda and 404. Wildcards are allowed, e.g. /favicon*."
  type        = list(string)
  default     = ["/favicon.ico"]
}
