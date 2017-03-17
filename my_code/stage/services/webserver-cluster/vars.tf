variable "aws_profile" {
    type        = "string"
    description = "AWS credentials."
    default     = "terraform"
}


variable "server_port" {
    type        = "string"
    description = "The port the server will use for HTTP requests"
    default     = 8080
}


variable "my_region" {
    type    = "string"
    default = "us-east-1"
}


variable "instance_type" {
    type        = "string"
    description = ""
    default     = "t2.nano"
}


variable "key_name" {
    type        = "string"
    description = ""
    default     = "iliya@vika-note.strakovich.com"
}


variable "image_id" {
    type        = "string"
    description = ""
    default     = "ami-40d28157"
}
