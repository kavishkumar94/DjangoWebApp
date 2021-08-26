resource "aws_key_pair" "si_key" {
  key_name   = "si_key"
  public_key = file(var.public_key_path)
}

data "template_file" "provision" {
template = "${file("provision.sh")}"
vars = {
  SQL_DATABASE = "${aws_db_instance.syn-app01-db.identifier}"
  SQL_USER= "${aws_db_instance.syn-app01-db.username}"
  SQL_PASSWORD =  "${aws_db_instance.syn-app01-db.password}"
  SQL_PORT = "${aws_db_instance.syn-app01-db.port}"
  }
 depends_on = [
    aws_db_instance.syn-app01-db
  ]
}

# Dynamic AMI for ec2-instance
data "aws_ami" "ubuntu_syntax" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "syn-app01" {
  ami = data.aws_ami.ubuntu_syntax.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.si_key.key_name
  vpc_security_group_ids = [ aws_security_group.syn-app01-sg.id ]
  tags = { 
    Name = "synapp-01"
  }
  user_data = data.template_file.provision.rendered
  depends_on = [
    aws_db_instance.syn-app01-db
  ]
}

resource "aws_security_group" "syn-app01-sg" {
  name  = "source_security_group"
  description = "Security group for synapp-01"
ingress {
    from_port = 22 
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${chomp(data.http.localhost_ip.body)}/32"]
  }
ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    cidr_blocks = ["${chomp(data.http.localhost_ip.body)}/32"]
  }
ingress {
    from_port = var.db_port
    to_port   = var.db_port
    protocol  = "tcp"
    cidr_blocks = ["${chomp(data.http.localhost_ip.body)}/32"]
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "syn-app01-db" {
  allocated_storage    = 5
  engine               = "postgres"
  engine_version       = "13.3"
  instance_class       = "db.t3.micro"
  skip_final_snapshot  = true
  storage_encrypted    = true
  identifier           = var.db_name
  port                 = var.db_port
  username             = var.db_username
  password             = var.db_password

}
