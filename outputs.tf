output "id" {
  description = "ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.main.id
}

output "arn" {
  description = "ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.main.arn
}

output "domain_name" {
  description = "The distribution cloudfront.net domain name, used as the target for a DNS alias record."
  value       = aws_cloudfront_distribution.main.domain_name
}

output "hosted_zone_id" {
  description = "CloudFront hosted zone ID, required when creating a Route 53 alias record to the distribution."
  value       = aws_cloudfront_distribution.main.hosted_zone_id
}
