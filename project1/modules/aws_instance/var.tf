variable "public_key_path" {
    description = "The name of the key pair"
    type        = string
}

variable "os_name" {
    description = "The OS AMI ID"
    type        = string
}

variable "aws_instance_count" { 
    description = "Number of AWS instances to create"
    type        = number        
  
}
variable "instance_type" {
    description = "Type of AWS instance"
    type        = string
  
}

variable "subnet_id" {
    description = "List of Subnet IDs"
    type        = list(string)
}