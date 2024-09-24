output "vpc_id" {
value = aws_vpc.ars_vpc.id
}

output "public_subnet_ids" {
value = aws_subnet.ars_public_subnet[*].id
}