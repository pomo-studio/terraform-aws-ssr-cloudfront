# terraform-aws-ssr-cloudfront

[![Terraform Validation](https://github.com/pomo-studio/terraform-aws-ssr-cloudfront/actions/workflows/terraform.yml/badge.svg)](https://github.com/pomo-studio/terraform-aws-ssr-cloudfront/actions/workflows/terraform.yml)
[![Terraform Registry](https://img.shields.io/badge/terraform-registry-844FBA?logo=terraform)](https://registry.terraform.io/modules/pomo-studio/ssr-cloudfront/aws)

- [Changelog](CHANGELOG.md)

Reusable CloudFront distribution module for SSR stacks.

This module provisions the multi-origin distribution used by serverless SSR, including Lambda origins, static asset origins, and cache/origin request policy wiring.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudfront_distribution.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | n/a | `string` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | n/a | `string` | `null` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_dr_lambda_function_url"></a> [dr\_lambda\_function\_url](#input\_dr\_lambda\_function\_url) | n/a | `string` | `null` | no |
| <a name="input_dr_region"></a> [dr\_region](#input\_dr\_region) | n/a | `string` | n/a | yes |
| <a name="input_enable_custom_domain"></a> [enable\_custom\_domain](#input\_enable\_custom\_domain) | n/a | `bool` | n/a | yes |
| <a name="input_enable_dr"></a> [enable\_dr](#input\_enable\_dr) | n/a | `bool` | n/a | yes |
| <a name="input_full_domain"></a> [full\_domain](#input\_full\_domain) | n/a | `string` | `null` | no |
| <a name="input_lambda_oac_id"></a> [lambda\_oac\_id](#input\_lambda\_oac\_id) | n/a | `string` | n/a | yes |
| <a name="input_lambda_signed_origin_request_policy_id"></a> [lambda\_signed\_origin\_request\_policy\_id](#input\_lambda\_signed\_origin\_request\_policy\_id) | n/a | `string` | n/a | yes |
| <a name="input_oai_cloudfront_access_identity_path"></a> [oai\_cloudfront\_access\_identity\_path](#input\_oai\_cloudfront\_access\_identity\_path) | n/a | `string` | n/a | yes |
| <a name="input_primary_lambda_function_url"></a> [primary\_lambda\_function\_url](#input\_primary\_lambda\_function\_url) | n/a | `string` | n/a | yes |
| <a name="input_primary_region"></a> [primary\_region](#input\_primary\_region) | n/a | `string` | n/a | yes |
| <a name="input_ssr_swr_cache_policy_id"></a> [ssr\_swr\_cache\_policy\_id](#input\_ssr\_swr\_cache\_policy\_id) | n/a | `string` | n/a | yes |
| <a name="input_static_assets_dr_regional_domain_name"></a> [static\_assets\_dr\_regional\_domain\_name](#input\_static\_assets\_dr\_regional\_domain\_name) | n/a | `string` | `null` | no |
| <a name="input_static_assets_regional_domain_name"></a> [static\_assets\_regional\_domain\_name](#input\_static\_assets\_regional\_domain\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | n/a |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->
