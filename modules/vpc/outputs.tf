####### modules/vpc/outputs.tf #######

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway attached to the VPC"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "ID of the route table associated with the public subnets"
  value       = aws_default_route_table.public.id
}
