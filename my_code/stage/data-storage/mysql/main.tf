provider "aws" {
    region  = "${var.my_region}"
    profile = "${var.aws_profile}"
}


resource "aws_db_instance" "example" {
    engine = "mysql"
    allocated_storage = 5
    instance_class = "db.t2.micro"
    name = "example_database"
    username = "admin"
    password = "${var.db_password}"
    db_subnet_group_name    = "${aws_db_subnet_group.example.id}"
    vpc_security_group_ids  = ["${data.terraform_remote_state.webserver.security_group}"]
}


resource "aws_db_subnet_group" "example" {
    name       = "main"
    subnet_ids = ["${data.terraform_remote_state.vpc.my_subnets}"]

    tags {
        Name = "My DB subnet group"
    }
}


data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket  = "terraform-up-and-running-state-iliyahoo"
        key     = "my_code/stage/vpc/terraform.tfstate"
        region  = "${var.my_region}"
        profile = "${var.aws_profile}"
    }
}


data "terraform_remote_state" "webserver" {
    backend = "s3"
    config {
        bucket  = "terraform-up-and-running-state-iliyahoo"
        key     = "my_code/stage/services/webserver-cluster/terraform.tfstate"
        region  = "${var.my_region}"
        profile = "${var.aws_profile}"
    }
}
