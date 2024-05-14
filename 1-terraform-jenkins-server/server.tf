data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "my-server" {
  ami                         = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.example.key_name
  subnet_id                   = aws_subnet.jenkins-subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.default-sg.id]
  availability_zone           = var.availability_zone
  associate_public_ip_address = true
  user_data                   = file("jenkins-script.sh")
  tags = {
    Name = "${var.env_prefix}-server"
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the private key to a file
resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/my_example_key_pair.pem"
  file_permission = "0400"
}

# Create the key pair in AWS using the generated public key
resource "aws_key_pair" "example" {
  key_name   = "my_example_key_pair"
  public_key = tls_private_key.example.public_key_openssh
}