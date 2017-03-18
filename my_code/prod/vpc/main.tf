variable "my_region" {
    type = "string"
    default = "us-east-1"
}


provider "aws" {
    region  = "${var.my_region}"
    profile = "terraform"
}


module "vpc" {
    source = "../../modules/vpc"
    my_region = "${var.my_region}"
    my_subnets = {
        us-east-1   = "192.168.40.0/21"
        us-east-1a  = "192.168.40.0/23"
        us-east-1b  = "192.168.42.0/23"
        us-east-1c  = "192.168.44.0/23"
        us-east-1d  = "192.168.46.0/23"
    }
    prefix = "prod"
}
