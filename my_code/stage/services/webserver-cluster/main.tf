provider "aws" {
    region  = "${var.my_region}"
    profile = "${var.aws_profile}"
}


resource "aws_launch_configuration" "example" {
    instance_type     = "${var.instance_type}"
    key_name          = "${var.key_name}"
    image_id          = "${var.image_id}"
    security_groups   = ["${aws_security_group.instance.id}"]
    user_data         = "${data.template_file.user_data.rendered}"
    lifecycle {
        create_before_destroy = true
    }
}


resource "aws_security_group" "instance" {
    name    = "terraform-example-instance"
    vpc_id  = "${data.terraform_remote_state.vpc.my_vpc}"
    ingress {
        from_port   = "${var.server_port}"
        to_port     = "${var.server_port}"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        self      = true
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    lifecycle {
        create_before_destroy = true
    }
    tags {
        Name = "terraform-sg-example"
    }
}


resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    vpc_zone_identifier  = ["${data.terraform_remote_state.vpc.my_subnets}"]
    load_balancers       = ["${aws_elb.example.name}"]
    health_check_type    = "ELB"
    min_size = 1
    max_size = 2
    tag {
        key                 = "Name"
        value               = "terraform-asg-example"
        propagate_at_launch = true
    }
}


resource "aws_elb" "example" {
    name            = "terraform-asg-example"
    subnets         = ["${data.terraform_remote_state.vpc.my_subnets}"]
    security_groups = ["${aws_security_group.elb.id}"]
    listener {
        lb_port           = 80
        lb_protocol       = "http"
        instance_port     = "${var.server_port}"
        instance_protocol = "http"
    }
    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        interval            = 30
        target              = "HTTP:${var.server_port}/"
    }
}


resource "aws_security_group" "elb" {
    name    = "terraform-example-elb"
    vpc_id  = "${data.terraform_remote_state.vpc.my_vpc}"
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
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


data "terraform_remote_state" "db" {
    backend = "s3"
    config {
        bucket  = "terraform-up-and-running-state-iliyahoo"
        key     = "my_code/stage/data-storage/mysql/terraform.tfstate"
        region  = "${var.my_region}"
        profile = "${var.aws_profile}"
    }
}


data "template_file" "user_data" {
    template = "${file("user-data.sh")}"
    vars {
        server_port = "${var.server_port}"
        db_address  = "${data.terraform_remote_state.db.address}"
        db_port     = "${data.terraform_remote_state.db.port}"
    }
}
