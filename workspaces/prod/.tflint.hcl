# .tflint.hcl

plugin "aws" {
  enabled = true
  version = "0.21.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_instance_invalid_type" {
  enabled = true
}

rule "aws_s3_bucket_name_invalid" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

# Exclure certaines règles (optionnel)
rule "aws_instance_previous_type" {
  enabled = false
}

# Configurer des règles spécifiques (optionnel)
rule "aws_s3_bucket_acl" {
  enabled = true
  values  = ["private", "log-delivery-write"]
}
