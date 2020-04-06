provider "aws" {
  region = "us-east-1"
  # shared_credentials_file = "/home/nelson/.aws/sso/cache/9cbcd2e573df943bafdb496ecb072776ba8ddecb.json"
  # profile                 = "tools"
}

# # Find the latest available AMI that is tagged with Component = web
# data "aws_ami" "ubuntu" {
#   filter {
#     name   = "id"
#     values = ["ami-07ebfd5b3428b6f4d"]
#   }
#
#
#   most_recent = true
# }

resource "aws_instance" "ubuntu_1804" {
  ami                         = "ami-07ebfd5b3428b6f4d"
  instance_type               = "t1.micro"
  key_name                    = "personal-aws"
  associate_public_ip_address = true
  user_data                   = file("./userdata.sh")
}

resource "aws_instance" "suse_linux" {
  ami                         = "ami-0df6cfabfbe4385b7"
  instance_type               = "t1.micro"
  key_name                    = "personal-aws"
  associate_public_ip_address = true
  user_data                   = file("./userdata.sh")
}

resource "aws_instance" "redhat_enterprise" {
  ami                         = "ami-0c322300a1dd5dc79"
  instance_type               = "t1.micro"
  key_name                    = "personal-aws"
  associate_public_ip_address = true
  user_data                   = file("./userdata.sh")
}

resource "aws_instance" "debian_stretch" {
  ami                         = "ami-066027b63b44ebc0a"
  instance_type               = "t1.micro"
  key_name                    = "personal-aws"
  associate_public_ip_address = true
  user_data                   = file("./userdata.sh")
}

resource "aws_instance" "arch_linux" {
  ami                         = "ami-0f040c7d22aedeb27"
  instance_type               = "t1.micro"
  key_name                    = "personal-aws"
  associate_public_ip_address = true
  user_data                   = file("./userdata.sh")
}


output "ubuntu_ip" { value = "ubuntu@${aws_instance.ubuntu_1804.public_ip}" }
output "suse_ip" { value = "ec2-user@${aws_instance.suse_linux.public_ip}" }
output "redhat_ip" { value = "ec2-user@${aws_instance.redhat_enterprise.public_ip}" }
output "debian_ip" { value = "admin@${aws_instance.debian_stretch.public_ip}" }
output "arch_ip" { value = "arch@${aws_instance.arch_linux.public_ip}" }
# TERM=xterm sudo ./squashfs-root/usr/bin/tmux -2
