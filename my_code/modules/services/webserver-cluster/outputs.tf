output "elb_dns" {
    value = "${aws_elb.example.dns_name}"
}


output "asg_name" {
    value = "${aws_autoscaling_group.example.name}"
}
