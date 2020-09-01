variable "region" {
  default = "us-east-1"
}

variable "name" {
  description = "Name of the ALB"
}

variable "vpc_id" {
  description = "The VPC id"
  default     = "<vpcID>"
}

variable "public_subnets" {
  description = "The public subnet id's in this VPC"
  default     = ["<subnetID01>", "<subnetID02>"]
}

variable "elbsecuritypolicy" {
  description = "ELBSecurityPolicy TLSv1.2 only"
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "cert" {
  description = "*.example.org wildcard certificate from AWS ACM"
  default     = "arn:aws:acm:us-east-1:<accountID>:certificate/<certID>"
}

variable "target_id" {
  description = "target id"
}

variable "fqdn" {
  description = "fqdn"
}

variable "tags" {
  type        = map
  description = "Tags to be applied to all resources"
}
