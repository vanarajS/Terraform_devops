variable "vpc_main_id" {
    description = "The VPC ID"
    type        = string
  
}
variable "subnet_id" {
    description = "List of Subnet IDs"
    type        = list(string)
}

variable "instance_ids" {
    description = "List of Instance IDs to attach to ALB"
    type        = list(string)
  
}