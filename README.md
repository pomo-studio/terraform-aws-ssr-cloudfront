# terraform-aws-ssr-cloudfront

[![Terraform Validation](https://github.com/pomo-studio/terraform-aws-ssr-cloudfront/actions/workflows/terraform.yml/badge.svg)](https://github.com/pomo-studio/terraform-aws-ssr-cloudfront/actions/workflows/terraform.yml)
[![Terraform Registry](https://img.shields.io/badge/terraform-registry-844FBA?logo=terraform)](https://registry.terraform.io/modules/pomo-studio/ssr-cloudfront/aws)

Reusable CloudFront distribution module for SSR stacks.

This module provisions the multi-origin distribution used by serverless SSR, including Lambda origins, static asset origins, and cache/origin request policy wiring.
