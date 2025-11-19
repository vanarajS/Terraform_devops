variable "vpc_main_id" {
    description = "The VPC ID"
    type        = string
  
}
variable "subnet_id" {
    description = "List of Subnet IDs"
    type        = list(string)
}