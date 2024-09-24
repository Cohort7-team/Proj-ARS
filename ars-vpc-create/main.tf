resource "aws_vpc" "ars_vpc" {
  cidr_block       = "10.10.0.0/16"

  tags = {
    Name = "ars-vpc"
  }
}

resource "aws_subnet" "ars_public_subnet" {
  count = length(var.ars_public_cidr_block)
  vpc_id     = aws_vpc.ars_vpc.id
  cidr_block = var.ars_public_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "ars-public-subnet-${element(data.aws_availability_zones.available.names,count.index)}"
  }
}

resource "aws_route_table" "ars_route" {
  vpc_id = aws_vpc.ars_vpc.id

  tags = {
    Name = "ars-route"
  }
}

resource "aws_route_table_association" "rt_tb_public" {
  count = length(var.ars_public_cidr_block)
  subnet_id      = aws_subnet.ars_public_subnet[count.index].id
  route_table_id = aws_route_table.ars_route.id
}

provider "aws" {
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}