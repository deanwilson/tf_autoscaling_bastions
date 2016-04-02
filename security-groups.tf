resource "aws_security_group" "bastion_elb" {
    name = "${var.bastion_elb_security_group_name}_${var.stackname}"
    description = "Bastion ELB SG: ${var.bastion_elb_security_group_name}_${var.stackname}"
}


resource "aws_security_group_rule" "elb_ssh_ingress" {
    type = "ingress"
    security_group_id = "${aws_security_group.bastion_elb.id}"

    from_port = 2222
    to_port = 2222
    protocol = "tcp"
    cidr_blocks = ["${var.source_cidr_block}"]
}

resource "aws_security_group_rule" "elb_ssh_egress" {
    type = "egress"
    security_group_id = "${aws_security_group.bastion_elb.id}"

    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = "${aws_security_group.bastion.id}"
}



resource "aws_security_group" "bastion" {
    name = "${var.bastion_security_group_name}_${var.stackname}"
    description = "Bastion SG: ${var.bastion_security_group_name}_${var.stackname}"
}

resource "aws_security_group_rule" "bastion_ssh_ingress" {
    type = "ingress"
    security_group_id = "${aws_security_group.bastion.id}"

    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = "${aws_security_group.bastion_elb.id}"
}

resource "aws_security_group_rule" "bastion_everything_egress" {
    type = "egress"
    security_group_id = "${aws_security_group.bastion.id}"

    from_port = 0
    to_port = 65335
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
