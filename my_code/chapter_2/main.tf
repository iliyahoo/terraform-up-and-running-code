variable "server_port" {
    type        = "string"
    description = "The port the server will use for HTTP requests"
    default     = 8080
}


variable "my_region" {
    type    = "string"
    default = "us-east-1"
}


variable "my_subnets" {
    type = "map"
    default = {
        us-east-1   = "192.168.56.0/21"
        us-east-1a  = "192.168.56.0/23"
        us-east-1b  = "192.168.58.0/23"
        us-east-1c  = "192.168.60.0/23"
        us-east-1d  = "192.168.62.0/23"
    }
}


provider "aws" {
    region  = "${var.my_region}"
    profile = "terraform"
}


resource "aws_vpc" "example" {
    cidr_block            = "${var.my_subnets["${var.my_region}"]}"
    instance_tenancy      = "default"
    enable_dns_support    = true
    enable_dns_hostnames  = true
    tags {
        Name = "example"
    }
}


resource "aws_subnet" "a" {
    vpc_id                  = "${aws_vpc.example.id}"
    cidr_block              = "${var.my_subnets["us-east-1a"]}"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"
    tags {
        Name = "example-a"
    }
}


resource "aws_subnet" "b" {
    vpc_id                  = "${aws_vpc.example.id}"
    cidr_block              = "${var.my_subnets["us-east-1b"]}"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1b"
    tags {
        Name = "example-b"
    }
}


resource "aws_subnet" "c" {
    vpc_id                  = "${aws_vpc.example.id}"
    cidr_block              = "${var.my_subnets["us-east-1c"]}"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1c"
    tags {
        Name = "example-c"
    }
}


resource "aws_subnet" "d" {
    vpc_id                  = "${aws_vpc.example.id}"
    cidr_block              = "${var.my_subnets["us-east-1d"]}"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1d"
    tags {
        Name = "example-d"
    }
}


resource "aws_internet_gateway" "example" {
    vpc_id = "${aws_vpc.example.id}"
    tags {
        Name = "example"
    }
}


resource "aws_route_table" "example" {
    vpc_id = "${aws_vpc.example.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.example.id}"
    }
    tags {
        Name = "example"
    }
}


resource "aws_main_route_table_association" "example" {
    vpc_id         = "${aws_vpc.example.id}"
    route_table_id = "${aws_route_table.example.id}"
}


resource "aws_route_table_association" "a" {
    subnet_id      = "${aws_subnet.a.id}"
    route_table_id = "${aws_route_table.example.id}"
}


resource "aws_route_table_association" "b" {
    subnet_id      = "${aws_subnet.b.id}"
    route_table_id = "${aws_route_table.example.id}"
}


resource "aws_route_table_association" "c" {
    subnet_id      = "${aws_subnet.c.id}"
    route_table_id = "${aws_route_table.example.id}"
}


resource "aws_route_table_association" "d" {
    subnet_id      = "${aws_subnet.d.id}"
    route_table_id = "${aws_route_table.example.id}"
}


resource "aws_launch_configuration" "example" {
    instance_type     = "t2.nano"
    key_name          = "iliya@vika-note.strakovich.com"
    image_id          = "ami-40d28157"
    security_groups   = ["${aws_security_group.instance.id}"]
    user_data         = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p "${var.server_port}" &
        EOF
    lifecycle {
        create_before_destroy = true
    }
}


resource "aws_security_group" "instance" {
    name    = "terraform-example-instance"
    vpc_id  = "${aws_vpc.example.id}"
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
    lifecycle {
        create_before_destroy = true
    }
    tags {
        Name = "terraform-sg-example"
    }
}


resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    vpc_zone_identifier  = [
        "${aws_subnet.a.id}",
        "${aws_subnet.b.id}",
        "${aws_subnet.c.id}",
        "${aws_subnet.d.id}"
    ]
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
    subnets         = [
        "${aws_subnet.a.id}",
        "${aws_subnet.b.id}",
        "${aws_subnet.c.id}",
        "${aws_subnet.d.id}"
    ]
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
    vpc_id  = "${aws_vpc.example.id}"
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


output "elb_dns" {
    value = "${aws_elb.example.dns_name}"
}
