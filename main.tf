 = var.aws_region
}

#Created security group with firewall rules
resource "aws_security_group" "security-ec2" {
  name        = "security-ec2"
  description = "security group for ec2"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from nginx server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = "security_ec2"
  }
}

resource "aws_instance" "myFirstInstance" {
  ami = "ami-09e67e426f25ce0d7"
  key_name = var.ec2-tf
  instance_type = var.instance_type
  security_groups= [ "security_ec2"]
  user_data = <<-EOF
   #!/bin/bash
   sudo apt update -y
   sudo apt install nginx -y
   sudo systemctl start nginx
   sudo systemctl enable nginx
   sudo bash -c 'echo Welcome to Nginx Webserver!! > /var/www/html/index.html'
   EOF
  tags= {
    Name = "nginx_instance"
  }
}
resource "aws_key_pair" "ec2-key" {
key_name = "deployer-key"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}
