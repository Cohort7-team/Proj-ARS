data "aws_availability_zones" "available" {
  state = "available"
}

data "vault_aws_access_credentials" "creds" {
  backend = "ars-aws"
  role    = "admin-access-role"
}