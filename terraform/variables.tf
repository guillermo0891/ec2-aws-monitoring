variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami" {
  type    = string
  default = "ami-0c02fb55956c7d316" # Amazon Linux 2 (update per region)
}

variable "target_count" {
  type    = number
  default = 2
}