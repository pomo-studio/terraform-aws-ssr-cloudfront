# Basic CloudFront Example

Shows the module building a CloudFront distribution for an SSR app with primary and DR origins.

## What it creates

- One `aws_cloudfront_distribution` with origin groups for the Lambda function and static assets.
- Cache behaviors for `/api/*`, the default SSR route, `/_nuxt/*`, and the static root paths.
- Uses `enable_custom_domain = false`, so the default CloudFront certificate is used and no alias is set.
- Uses `enable_dr = false`, so only the primary origins carry traffic.

## Before you start

- AWS provider, primary region `us-east-1`, DR `us-west-2`.
- The example sets mock credentials and skip flags. It is meant for `init` and `plan` offline.
- Replace the mock credentials with real ones before `apply`. The plan also expects an existing Lambda function URL, OAC ID, static bucket domain, OAI path, and policy IDs.

## Run it

```bash
terraform init
terraform plan
terraform apply
```

## Clean up

```bash
terraform destroy
```
