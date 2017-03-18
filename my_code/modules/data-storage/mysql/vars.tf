variable "aws_profile" {
    type        = "string"
    description = "AWS credentials."
}


variable "my_region" {
    type    = "string"
}


variable "db_password" {
    type = "string"
    description = "The password for the database."
}


variable "prefix" {
    type        = "string"
    description = "environment prefix"
}
