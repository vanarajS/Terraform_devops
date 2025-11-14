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

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.vpc_name}-igw"
    }
  
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id 
    }
    tags = {
        Name = "${var.vpc_name}-rt"
    }
}

resource "aws_route" "route" {
    route_table_id         = aws_route_table.rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
  
}

resource "aws_route_table_association" "a" {
  count = length(var.subnet_cidr)
  subnet_id      = aws_subnet.sb[count.index].id
  route_table_id = aws_route_table.rt.id
}