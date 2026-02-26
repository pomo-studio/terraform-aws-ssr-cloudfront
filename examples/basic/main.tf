provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
}

module "cloudfront" {
  source = "../.."

  app_name                               = "example"
  enable_custom_domain                   = false
  full_domain                            = null
  enable_dr                              = false
  primary_lambda_function_url            = "https://example.lambda-url.us-east-1.on.aws/"
  dr_lambda_function_url                 = null
  lambda_oac_id                          = "dummy-oac-id"
  static_assets_regional_domain_name     = "example-static.s3.us-east-1.amazonaws.com"
  static_assets_dr_regional_domain_name  = null
  oai_cloudfront_access_identity_path    = "origin-access-identity/cloudfront/EXAMPLE"
  primary_region                         = "us-east-1"
  dr_region                              = "us-west-2"
  lambda_signed_origin_request_policy_id = "dummy-policy-id"
  ssr_swr_cache_policy_id                = "dummy-cache-policy-id"
  certificate_arn                        = null
}
