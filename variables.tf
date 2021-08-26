variable aws_region {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

variable "access_key" {
  description = "AWS access key"
  type = string
}

variable "secret_key" {
  description = "AWS secret key"
  type = string
}

variable "db_name" {
 description = "DB name"
  type = string
}
variable "db_port" {
 description = "DB Port"
  type = number
}

variable "db_username" {
 description = "DB Username"
  type = string
}

variable "db_password" {
 description = "DB Password"
  type = string
}

variable "public_key_path" {
  default = ".\\keys\\syntax_interview.pub"
}

variable "private_key_path" {
  default = ".\\keys\\syntax_interview"
}

data "http" "localhost_ip" {
  url = "http://ipv4.icanhazip.com"
}


