output "my_vpc" {
    value = "${aws_vpc.example.id}"
}


output "my_subnets" {
    value = [
        "${aws_subnet.a.id}",
        "${aws_subnet.b.id}",
        "${aws_subnet.c.id}",
        "${aws_subnet.d.id}"
    ]
}
