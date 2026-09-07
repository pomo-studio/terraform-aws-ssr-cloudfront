# terraform-aws-ssr-cloudfront

The CloudFront distribution for a server-rendered site. Two Lambda origins that fail over
to one another, an S3 origin for static files, and caching tuned for pages built on
request.

**You probably want [serverless-ssr](https://registry.terraform.io/modules/pomo-studio/serverless-ssr/aws) instead.**
It wires this together with the Lambda, storage and DNS pieces and gives you a working
site. Come here if you are assembling the parts yourself.

## What you get

One CloudFront distribution, set up so that:

- `/api/*` goes to the Lambda
- `/_nuxt/*` and any root files you nominate come from S3
- everything else is server-rendered by the Lambda
- if the primary region returns a 5xx, the same request is retried against the DR region

That last point is worth pausing on. Failover happens inside CloudFront, on the request
that failed. There are no health checks to configure and no DNS record to wait on.

## Using it

```hcl
module "cloudfront" {
  source  = "pomo-studio/ssr-cloudfront/aws"
  version = "~> 0.3"

  providers = { aws = aws.primary }

  app_name             = "my-app"
  enable_custom_domain = true
  full_domain          = "www.example.com"
  certificate_arn      = module.dns.certificate_arn

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

Four of those inputs come from
[ssr-cloudfront-support](https://registry.terraform.io/modules/pomo-studio/ssr-cloudfront-support/aws)
and two from [ssr-storage](https://registry.terraform.io/modules/pomo-studio/ssr-storage/aws).
Set `enable_custom_domain = false` to serve on the `cloudfront.net` domain, and you can
skip `full_domain` and `certificate_arn`.

## Worth knowing

**The certificate has to be in us-east-1.** CloudFront accepts no other region. If you
have a wildcard certificate elsewhere in your account, this is the one thing you cannot
reuse across regions.

**Name every root file you serve.** `static_root_path_patterns` decides what comes from
S3 rather than the Lambda, and it defaults to `["/favicon.ico"]`. A `robots.txt` you
forget to list will be uploaded to S3 and still return 404, because the request goes to
the Lambda instead.

**Applies are slow.** CloudFront takes a few minutes to deploy a change, and Terraform
returns when the change is accepted, not when every edge has it.

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
