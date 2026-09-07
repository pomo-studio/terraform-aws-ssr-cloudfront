# terraform-aws-ssr-cloudfront

The CloudFront distribution for a serverless SSR stack: two Lambda origins with automatic
failover, an S3 origin for static assets, and cache behaviours tuned for server-rendered
pages.

This module is composed by [`serverless-ssr`](https://registry.terraform.io/modules/pomo-studio/serverless-ssr/aws)
and published separately for callers who want to assemble the pieces themselves. It
expects policy and origin-access IDs from
[`ssr-cloudfront-support`](https://registry.terraform.io/modules/pomo-studio/ssr-cloudfront-support/aws),
bucket domains from [`ssr-storage`](https://registry.terraform.io/modules/pomo-studio/ssr-storage/aws),
and a certificate from [`ssr-dns`](https://registry.terraform.io/modules/pomo-studio/ssr-dns/aws)
or anywhere else.

## What it creates

- A CloudFront distribution with an **origin group** across two regions
- Ordered cache behaviours for `/api/*` (Lambda), `/_nuxt/*` (S3) and configurable root paths
- A default behaviour sending everything else to the primary Lambda function URL

## Design decisions

**Failover without DNS.** The Lambda origins sit in an origin group, so a 5xx from the
primary is retried against the DR origin on the same request. No Route 53 health checks,
no TTL to wait out.

**Stale-while-revalidate for SSR.** The cache policy honours the origin's
`Cache-Control`, so the Lambda decides freshness and CloudFront serves the cached copy
while it refreshes.

**Static paths are configurable.** `static_root_path_patterns` controls which root-level
files come from S3 rather than the Lambda. It defaults to `["/favicon.ico"]`; add
`/robots.txt` or `/apple-touch-icon.png` if you serve them, or they will resolve against
the Lambda and 404.

## Usage

```hcl
module "cloudfront" {
  source  = "pomo-studio/ssr-cloudfront/aws"
  version = "~> 0.3"

  providers = { aws = aws.primary }

  app_name             = "my-app"
  enable_custom_domain = true
  full_domain          = "www.example.com"
  certificate_arn      = module.dns.certificate_arn # must be in us-east-1

  static_root_path_patterns = ["/favicon*", "/robots.txt"]

  enable_dr                   = true
  primary_region              = "us-east-1"
  dr_region                   = "us-west-2"
  primary_lambda_function_url = aws_lambda_function_url.primary.function_url
  dr_lambda_function_url      = aws_lambda_function_url.dr[0].function_url

  static_assets_regional_domain_name    = module.storage.static_assets_regional_domain_name
  static_assets_dr_regional_domain_name = module.storage.static_assets_dr_regional_domain_name

  lambda_oac_id                          = module.cloudfront_support.lambda_oac_id
  oai_cloudfront_access_identity_path    = module.cloudfront_support.oai_cloudfront_access_identity_path
  lambda_signed_origin_request_policy_id = module.cloudfront_support.lambda_signed_origin_request_policy_id
  ssr_swr_cache_policy_id                = module.cloudfront_support.ssr_swr_cache_policy_id

  common_tags = { Project = "my-app" }
}
```

Set `enable_custom_domain = false` to serve on the `cloudfront.net` domain only, in which
case `full_domain` and `certificate_arn` are not required.

## Notes

- `certificate_arn` **must** be in `us-east-1`. CloudFront accepts certificates from no
  other region.
- Distribution changes take several minutes to deploy. `terraform apply` returns once
  CloudFront accepts the change, not once it has propagated to every edge.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name prefix applied to CloudFront resources and their tags. | `string` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of an ACM certificate in us-east-1 covering full\_domain. Required when enable\_custom\_domain is true. | `string` | `null` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Tags applied to every resource this module creates. | `map(string)` | `{}` | no |
| <a name="input_dr_lambda_function_url"></a> [dr\_lambda\_function\_url](#input\_dr\_lambda\_function\_url) | Function URL of the DR-region SSR Lambda, used as the failover origin. Ignored when enable\_dr is false. | `string` | `null` | no |
| <a name="input_dr_region"></a> [dr\_region](#input\_dr\_region) | Region hosting the failover origins. | `string` | n/a | yes |
| <a name="input_enable_custom_domain"></a> [enable\_custom\_domain](#input\_enable\_custom\_domain) | Whether to attach an alias and ACM certificate. When false the distribution is reachable only on its cloudfront.net domain. | `bool` | n/a | yes |
| <a name="input_enable_dr"></a> [enable\_dr](#input\_enable\_dr) | Whether to add the DR region as a failover origin. When false only the primary origin is configured. | `bool` | n/a | yes |
| <a name="input_full_domain"></a> [full\_domain](#input\_full\_domain) | Fully qualified domain served by the distribution, for example www.example.com. | `string` | `null` | no |
| <a name="input_lambda_oac_id"></a> [lambda\_oac\_id](#input\_lambda\_oac\_id) | Origin access control ID used to sign requests to the Lambda function URLs. | `string` | n/a | yes |
| <a name="input_lambda_signed_origin_request_policy_id"></a> [lambda\_signed\_origin\_request\_policy\_id](#input\_lambda\_signed\_origin\_request\_policy\_id) | Origin request policy applied to Lambda origins, controlling which headers, cookies and query strings are forwarded. | `string` | n/a | yes |
| <a name="input_oai_cloudfront_access_identity_path"></a> [oai\_cloudfront\_access\_identity\_path](#input\_oai\_cloudfront\_access\_identity\_path) | Origin access identity path used to read from the static assets buckets. | `string` | n/a | yes |
| <a name="input_primary_lambda_function_url"></a> [primary\_lambda\_function\_url](#input\_primary\_lambda\_function\_url) | Function URL of the primary-region SSR Lambda, used as the origin for dynamic requests. | `string` | n/a | yes |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | Region hosting the primary origins. | `string` | n/a | yes |
| <a name="input_ssr_swr_cache_policy_id"></a> [ssr\_swr\_cache\_policy\_id](#input\_ssr\_swr\_cache\_policy\_id) | Cache policy applied to SSR responses, providing stale-while-revalidate behaviour. | `string` | n/a | yes |
| <a name="input_static_assets_dr_regional_domain_name"></a> [static\_assets\_dr\_regional\_domain\_name](#input\_static\_assets\_dr\_regional\_domain\_name) | Regional domain name of the DR static assets bucket. Ignored when enable\_dr is false. | `string` | `null` | no |
| <a name="input_static_assets_regional_domain_name"></a> [static\_assets\_regional\_domain\_name](#input\_static\_assets\_regional\_domain\_name) | Regional domain name of the primary static assets bucket. | `string` | n/a | yes |
| <a name="input_static_root_path_patterns"></a> [static\_root\_path\_patterns](#input\_static\_root\_path\_patterns) | Path patterns served from the static assets origin instead of the SSR Lambda. Root-level files such as /favicon.ico, /robots.txt or /apple-touch-icon.png ship with the static assets but would otherwise resolve against the Lambda and 404. Wildcards are allowed, e.g. /favicon*. | `list(string)` | <pre>[<br/>  "/favicon.ico"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the CloudFront distribution. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The distribution cloudfront.net domain name, used as the target for a DNS alias record. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | CloudFront hosted zone ID, required when creating a Route 53 alias record to the distribution. |
| <a name="output_id"></a> [id](#output\_id) | ID of the CloudFront distribution. |
<!-- END_TF_DOCS -->
