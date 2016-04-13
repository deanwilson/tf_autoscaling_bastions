
variable "ami_id" {
    description = "AMI ID the bastions should be based on"
}

variable "asg_subnet_ids" {
    description = "A comma separated list of subnet IDs for the autoscaling group"
}

variable "bastion_elb_security_group_name" {
    default = "bastion-elb"
}

variable "bastion_security_group_name" {
    default = "bastion-instances"
}

variable "elb_ingress_port" {
    default = 2222
}

variable "elb_subnet_ids" {
    description = "A comma separated list of subnet IDs for the ELB"
}

variable "host_keys_bucket" { }

variable "instance_type" {
    default = "t2.micro"
}

variable "max_bastion_instances" {
    default = 1
}

variable "min_bastion_instances" {
    default = 1
}

# something used to namespace the bastions
# so multiple deployments can exist at once
variable "stackname" { }

variable "region" { }

variable "source_cidr_block" {
    default = "0.0.0.0/0"
}

variable "ssh_key_name" {
    default = "bastion-ssh-keys"
}

variable "vpc_id" {
    description = "The VPC ID the resources will be created in"
}
