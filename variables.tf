variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_region_key" {
  type    = string
  default = "AWS_Key_Pair"
}

variable "db_read_capacity" {
  type    = number
  default = 5
}

variable "db_write_capacity" {
  type    = number
  default = 5
}

variable "region_ami" {
  default = {
    ap-northeast-2 = "ami-03461b78fdba0ff9d"
    us-east-1 = "ami-0cff7528ff583bf9a"
  }
}