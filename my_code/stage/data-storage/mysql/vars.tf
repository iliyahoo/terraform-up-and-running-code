variable "aws_profile" {
    type        = "string"
    description = "AWS credentials."
    default     = "terraform"
}


variable "my_region" {
    type    = "string"
    default = "us-east-1"
}


variable "db_password" {
    description = "The password for the database."
}
