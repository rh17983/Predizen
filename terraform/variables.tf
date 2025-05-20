variable "aws_region" {
  default = "us-east-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "key_name" {
  default = "fastapi-auto-key"
}

variable "github_repo" {
  description = "GitHub repo in format user/repo"
}