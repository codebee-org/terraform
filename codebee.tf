provider "aws" {
  version = "~> 3.00"
  region  = var.region
}

terraform {
  backend "remote" {
    organization = "codebee"

    workspaces {
      name = "codebee-dev"
    }
  }
}

resource "aws_instance" "codebee-web" {
  ami             = lookup(var.amis, var.region)
  key_name        = "codebee_uw1"
  instance_type   = "t2.micro"
  security_groups = ["launch-wizard-4"]
  tags = {
    Name   = "codebee-web"
    Delete = "False"
  }
  depends_on = ["aws_s3_bucket.example"]

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install git -y",
      "sudo yum install httpd -y",
      "git clone https://github.com/codebee-org/codebee.git"
    ]
    connection {
      user        = "ec2-user"
      private_key = file("/Users/jorgecastaneda/keys/aws/codebee/uw1/codebee_uw1.pem")
    }
  }
}

resource "aws_eip" "ip" {
  instance = aws_instance.codebee-web.id
}

resource "aws_s3_bucket" "example" {
  bucket = "codebee-getting-started-examples"
  acl    = "private"
}
