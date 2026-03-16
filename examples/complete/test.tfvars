logical_product_family  = "lp"
logical_product_service = "lps"
class_env               = "dev"
instance_env            = 0
instance_resource       = 0

resource_names_map = {
  sns_topic = {
    name       = "snstopic"
    max_length = 256
  }
  kms_key = {
    name       = "kmskey"
    max_length = 256
  }
}

tags = {
  Environment = "test"
  Terraform   = "true"
}
