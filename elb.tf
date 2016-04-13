resource "aws_elb" "bastion_hosts_elb" {
    subnets = ["${split(",", var.elb_subnet_ids)}"]

    cross_zone_load_balancing = true
    security_groups = ["${aws_security_group.bastion_elb.id}"]

    listener {
        instance_port = 22
        instance_protocol = "tcp"
        lb_port = "${var.elb_ingress_port}"
        lb_protocol = "tcp"
    }


    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "TCP:22"
        interval = 30
    }

    tags {
        Name = "bastion_hosts_elb_${var.stackname}"
        terraform = "true"
        stackname = "${var.stackname}"
    }

}
