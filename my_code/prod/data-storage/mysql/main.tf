variable "my_region" {
    type = "string"
    default = "us-east-1"
}


variable "aws_profile" {
    type        = "string"
    description = "AWS credentials."
    default     = "terraform"
}


variable "db_password" {
    type = "string"
    description = "The password for the database."
}


provider "aws" {
    region  = "${var.my_region}"
    profile = "${var.aws_profile}"
}


module "mysql" {
    source = "../../../modules/data-storage/mysql"
    aws_profile = "${var.aws_profile}"
    my_region = "${var.my_region}"
    db_password = "${var.db_password}"
    prefix = "prod"
}
