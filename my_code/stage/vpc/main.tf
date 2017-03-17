provider "aws" {
    region  = "${var.my_region}"
    profile = "${var.aws_profile}"
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
    cidr_block              = "${var.my_subnets["${var.my_region}a"]}"
    map_public_ip_on_launch = true
    availability_zone       = "${var.my_region}a"
    tags {
        Name = "example-a"
    }
}


resource "aws_subnet" "b" {
    vpc_id                  = "${aws_vpc.example.id}"
    cidr_block              = "${var.my_subnets["${var.my_region}b"]}"
    map_public_ip_on_launch = true
    availability_zone       = "${var.my_region}b"
    tags {
        Name = "example-b"
    }
}


resource "aws_subnet" "c" {
    vpc_id                  = "${aws_vpc.example.id}"
    cidr_block              = "${var.my_subnets["${var.my_region}c"]}"
    map_public_ip_on_launch = true
    availability_zone       = "${var.my_region}c"
    tags {
        Name = "example-c"
    }
}


resource "aws_subnet" "d" {
    vpc_id                  = "${aws_vpc.example.id}"
    cidr_block              = "${var.my_subnets["${var.my_region}d"]}"
    map_public_ip_on_launch = true
    availability_zone       = "${var.my_region}d"
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
