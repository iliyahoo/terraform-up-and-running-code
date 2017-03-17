variable "aws_profile" {
    type        = "string"
    description = "AWS credentials."
    default     = "terraform"
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
