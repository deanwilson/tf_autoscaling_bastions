
resource "template_file" "user_data" {
    template = "${file("${path.module}/templates/bastion-user-data.sh.tpl")}"

    vars {
        host_keys_bucket = "${var.host_keys_bucket}"
        region           = "${var.region}"
    }
}


resource "aws_launch_configuration" "bastion_lc" {
    name_prefix = "bastion-lc-${var.stackname}-"
    image_id = "${lookup(var.ami_id, var.region)}"

    instance_type = "${var.instance_type}"

    iam_instance_profile = "${aws_iam_instance_profile.bastion_profile.name}"
    key_name = "${var.ssh_key_name}"
    security_groups = ["${aws_security_group.bastion.id}"]

    user_data = "${template_file.user_data.rendered}"

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "bastion_asg" {
    availability_zones = ["${split(",", lookup(var.availability_zones, var.region))}"]

    name = "bastion_asg_${var.stackname}"
    launch_configuration = "${aws_launch_configuration.bastion_lc.name}"
    load_balancers = ["${aws_elb.bastion_hosts_elb.name}"]

    max_size = "${var.max_bastion_instances}"
    min_size = "${var.min_bastion_instances}"

    tag {
        key = "terraform"
        value = "true"
        propagate_at_launch = true
    }

    tag {
        key = "Name"
        value = "bastion-host"
        propagate_at_launch = true
    }

    tag {
        key = "stackname"
        value = "${var.stackname}"
        propagate_at_launch = true
    }

    lifecycle {
      create_before_destroy = true
    }
}
