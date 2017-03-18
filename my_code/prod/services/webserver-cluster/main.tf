variable "my_region" {
    type = "string"
    default = "us-east-1"
}


variable "aws_profile" {
    type        = "string"
    description = "AWS credentials."
    default     = "terraform"
}


provider "aws" {
    region  = "${var.my_region}"
    profile = "${var.aws_profile}"
}


module "webserver-cluster" {
    source = "../../../modules/services/webserver-cluster"
    aws_profile = "${var.aws_profile}"
    my_region = "${var.my_region}"
    image_id = "ami-40d28157"
    instance_type = "t2.nano"
    key_name = "iliya@vika-note.strakovich.com"
    server_port = 8080
    min_size = 0
    max_size = 2
    prefix = "prod"
}


resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 1
  max_size              = 2
  desired_capacity      = 1
  recurrence            = "0 9 * * *"

  autoscaling_group_name = "${module.webserver-cluster.asg_name}"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 1
  max_size              = 2
  desired_capacity      = 1
  recurrence            = "0 17 * * *"

  autoscaling_group_name = "${module.webserver-cluster.asg_name}"
}
