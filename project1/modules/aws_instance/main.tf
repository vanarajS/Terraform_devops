resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)
  }

resource "aws_instance" "web1" {
  count = var.aws_instance_count
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer.key_name
  subnet_id = var.subnet_id[count.index]
  ami = var.os_name
}