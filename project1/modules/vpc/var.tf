variable "vpc_name" {
    description = "The name of the VPC"
    type        = string
}

variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
  
}

variable "sub_region" {
    description = "az"
    type        = list(string)
  
}

variable "subnet_count" {
    description = "Number of subnets to create"
    type        = number
}

variable "subnet_cidr" {
    description = "The CIDR block for the subnets"
    type        = list(string)
  
}