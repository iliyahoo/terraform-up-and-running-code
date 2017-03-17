output "elb_dns" {
    value = "${aws_elb.example.dns_name}"
}


output "security_group" {
    value = "${aws_security_group.instance.id}"
}
