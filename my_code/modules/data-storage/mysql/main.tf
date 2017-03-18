resource "aws_db_instance" "example" {
    engine = "mysql"
    allocated_storage = 5
    instance_class = "db.t2.micro"
    name = "${var.prefix}_mysql"
    username = "admin"
    password = "${var.db_password}"
    db_subnet_group_name    = "${aws_db_subnet_group.example.id}"
    vpc_security_group_ids  = ["${data.terraform_remote_state.vpc.instance_sg}"]
    tags {
        Name = "${var.prefix}_mysql"
    }
}


resource "aws_db_subnet_group" "example" {
    name       = "${var.prefix}_subnet_group"
    subnet_ids = ["${data.terraform_remote_state.vpc.my_subnets}"]
    tags {
        Name = "${var.prefix}_subnet_group"
    }
}


data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket  = "terraform-up-and-running-state-iliyahoo"
        key     = "my_code/${var.prefix}/vpc/terraform.tfstate"
        region  = "${var.my_region}"
        profile = "${var.aws_profile}"
    }
}


data "terraform_remote_state" "webserver" {
    backend = "s3"
    config {
        bucket  = "terraform-up-and-running-state-iliyahoo"
        key     = "my_code/${var.prefix}/services/webserver-cluster/terraform.tfstate"
        region  = "${var.my_region}"
        profile = "${var.aws_profile}"
    }
}
