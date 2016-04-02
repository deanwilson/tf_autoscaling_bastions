
resource "aws_iam_instance_profile" "bastion_profile" {
    name  = "bastion_profile_${var.stackname}"
    roles = ["${aws_iam_role.bastion_role.name}"]
}


resource "aws_iam_role" "bastion_role" {
    name = "bastion_role_${var.stackname}"
    path = "/"
    assume_role_policy = "${file("${path.module}/files/assume-role-policy.json")}"
}



resource "aws_iam_policy_attachment" "bastion-attach" {
    name = "bastion-attachment_${var.stackname}"
    roles = ["${aws_iam_role.bastion_role.name}"]
    policy_arn = "${aws_iam_policy.s3_hostkey_policy.arn}"
}

resource "template_file" "s3_hostkey_policy_template" {
    template = "${file("${path.module}/templates/hostkey-access-policy.json.tpl")}"

    vars {
        host_keys_bucket = "${var.host_keys_bucket}"
    }
}

resource "aws_iam_policy" "s3_hostkey_policy" {
    name = "bastion_hostkey_policy_${var.stackname}"
    path = "/"
    description = "Bastion instance S3 hostkeys bucket access policy"
    policy = "${template_file.s3_hostkey_policy_template.rendered}"
}
