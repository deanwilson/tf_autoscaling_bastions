output "bastion_elb_security_group_id" {
    value = "${aws_security_group.bastion_elb.id}"
}

output "bastion_security_group_id" {
    value = "${aws_security_group.bastion.id}"
}

output "elb_dns_name" {
    value = "${aws_elb.bastion_hosts_elb.dns_name}"
}

output "elb_zone_id" {
    value = "${aws_elb.bastion_hosts_elb.zone_id}"
}
