output "my_vpc" {
    value = "${module.vpc.my_vpc}"
}


output "my_subnets" {
    value = ["${module.vpc.my_subnets}"]
}


output "instance_sg" {
    value = "${module.vpc.instance_sg}"
}
