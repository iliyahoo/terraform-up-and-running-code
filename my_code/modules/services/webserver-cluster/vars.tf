variable "aws_profile" {
    type        = "string"
    description = "AWS credentials."
}


variable "server_port" {
    type        = "string"
    description = "The port the server will use for HTTP requests"
}


variable "my_region" {
    type    = "string"
    description = "ec2 region"
}


variable "instance_type" {
    type        = "string"
    description = "ec2 instance type"
}


variable "key_name" {
    type        = "string"
    description = "SSH key"
}


variable "image_id" {
    type        = "string"
    description = "desired AMI"
}


variable "prefix" {
    type        = "string"
    description = "environment prefix"
}


variable "min_size" {
    type        = "string"
    description = "ASG min_size"
}


variable "max_size" {
    type        = "string"
    description = "ASG max_size"
}
