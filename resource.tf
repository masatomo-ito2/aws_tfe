provider "aws" {
  region     = "ap-northeast-1"
}

resource "aws_instance" "itmstm" {
  ami           = "ami-08847abae18baa040"
  instance_type = "t2.micro"
  key_name = "itmstm"

  # My security setting
  security_groups = ["${aws_security_group.default.name}"]
  
  # Provisioner to store public dns name in file
  provisioner "local-exec" {
  	command = "echo ${aws_instance.itmstm.public_dns} > public_dns.txt"
  }
}

resource "aws_security_group" "default" {
  name        = "terraform_security_group"
  description = "Allow access to SSH port"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "ip" {
	instance = "${aws_instance.itmstm.id}"
}

output "ip" {
	value = "${aws_eip.ip.public_ip}"
}
