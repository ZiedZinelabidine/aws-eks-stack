terraform {
  backend "s3" {
    bucket       = "eks-workshop-zz"
    key          = "tfstates/infrastructure/prod.tfstate"
    encrypt      = true
    use_lockfile = true
    region       = "eu-west-1"
  }
}
