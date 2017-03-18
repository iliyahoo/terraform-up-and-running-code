variable "my_region" {
    description = "AWS region"
}


variable "my_subnets" {
    description = "list of VPC subnets"
    type = "map"
}


variable "prefix" {
    type = "string"
}
