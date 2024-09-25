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

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ars_vpc.id

  tags = {
    Name = "vault-vpc-gw"
  }
}

resource "aws_route" "r" {
  route_table_id            = aws_route_table.ars_route.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_subnet" "ars_private_subnet" {
  count = length(var.ars_private_cidr_block)
  vpc_id     = aws_vpc.ars_vpc.id
  cidr_block = var.ars_private_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "ars-private-subnet-${element(data.aws_availability_zones.available.names,count.index)}"
  }
}

resource "aws_route_table" "ars_private_route" {
  vpc_id = aws_vpc.ars_vpc.id

  tags = {
    Name = "ars-private-route"
  }
}

resource "aws_route_table_association" "rt_tb_private" {
  count = length(var.ars_private_cidr_block)
  subnet_id      = aws_subnet.ars_private_subnet[count.index].id
  route_table_id = aws_route_table.ars_private_route.id
}

resource "aws_eip" "lb" {
    domain   = "vpc"
}

resource "aws_nat_gateway" "ars_ngw" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.ars_private_subnet[0].id

  tags = {
    Name = "ars-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.ars_route.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.ars_ngw.id
}