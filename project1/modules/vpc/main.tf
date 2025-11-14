resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block 
    tags = {
        Name = var.vpc_name
    }
  
}

resource "aws_subnet" "sb" {
    count = length(var.subnet_cidr)
    vpc_id            = aws_vpc.vpc.id
    cidr_block       = var.subnet_cidr[count.index]
    availability_zone = var.sub_region[count.index]
    tags = {
        Name = "${var.vpc_name}-subnet"
    }
  
}
