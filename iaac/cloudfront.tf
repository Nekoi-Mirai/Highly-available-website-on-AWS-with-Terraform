locals {
  s3_origin_id = "s3-origin-resume"
}

resource aws_cloudfront_origin_access_identity frontend {
  comment = "OAI for S3 frontend"
}

resource aws_cloudfront_distribution frontend {
  origin {
    domain_name = aws_s3_bucket.static.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.frontend.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Distribution for resume website"
  default_root_object = "index.html"


  aliases = []

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  wait_for_deployment = true
}

output host_name {
  value = aws_cloudfront_distribution.frontend.domain_name
}