
variable "ami_id" {
    default = {
        eu-west-1 = "ami-bfa319cc"
    }
}

variable "availability_zones" {
    default = {
        eu-west-1 = "eu-west-1a,eu-west-1b,eu-west-1c"
    }
}

variable "bastion_elb_security_group_name" {
    default = "bastion-elb"
}

variable "bastion_security_group_name" {
    default = "bastion-instances-"
}

variable "elb_ingress_port" {
    default = 2222
}

variable "host_keys_bucket" { }

variable "instance_type" {
    default = "t1.micro"
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

