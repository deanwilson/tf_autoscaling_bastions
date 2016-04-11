# Autoscaling Bastion Hosts Terraform Module

## Introduction

One of the more common practices when running your infrastructure
remotely is to have a number of public facing [bastion
hosts](https://en.wikipedia.org/wiki/Bastion_host), or jump boxes, that
everyone connects to. From that instance you can then 'jump' further in
to your infrastructure. The advantage of this model is that you have a
defined place that can be heavily locked down and audited while still
granting access and protecting all the machines behind it.

This Terraform module implements the pattern in AWS using:

 * A publicly visible, but locked to a given CIDR range, ELB
 * An autoscaling group of bastion hosts that ensures at least one is running

In addition to this there are a few embellishments that make it a little nicer than
what you'd get by default.

 * It listens to a non-standard port on the public ELB interface
 * The ELB only accepts connections from given ranges
 * Each instance pulls ssh host keys from a secure S3 bucket on creation
   so you don't get host key warnings when ever a host is created or
   destroyed.

Before using this module you should already have created an S3 bucket,
referred to as `host_keys_bucket` in the code, and copied your ssh host
keys over to it. This can be done using Terraform or out of bounds with
another tool.

This is my very first pass at using a number of these resources in Terraform
and so might contain oddities, mistakes and omissions. I'm putting it on GitHub
as another example of Terraform in the wild and to hopefully get some
constructure criticism and feedback about my Terraform code.

## Usage

Use the module in your terraform files:

    module "bastion_hosts" {
        source = "github.com/deanwilson/tf_autoscaling_bastions"

        asg_subnet_ids = "subnet-11111111,subnet-22222222"
        elb_subnet_ids = "subnet-33333333,subnet-44444444"

        host_keys_bucket = "org.example.terraform.bastion-hostkeys"

        region   = "eu-west-1"
        ssh_key_name = "dwilson-test"
        stackname = "mctesty"

        vpc_id = "vpc-8ba044ef
    }

and then run a `terraform get` to download the module.

Once you've applied it you can check the value with

    terraform output -module=bastion_hosts elb_dns_name

### Module Input Variables

 * `asg_subnet_ids`
   * A comma separated list of subnet ids to be used by the autoscaling group
 * `elb_ingress_port`
   * the external port to ssh to on the ELB.
   * defaults to 2222
 * `elb_subnet_ids`
   * A comma separated list of subnet ids to be used by the ELB
 * `host_keys_bucket` - the s3 bucket instances download their ssh host keys from
 * `instance_type`
   * defaults to a `t1.micro`
 * `stackname`
   * An arbitrary name used to uniquely identify all the resources from a single
     apply of the module. Allows multiple stacks to live side by side.
 * `region`
   * The region to deploy the resources to.
 * `source_cidr_block`
   * The CIDR range the ELB exposed the `elb_ingress_port` port to.
   * Defaults to `0.0.0.0/0`. Which allows everyone to attempt to connect.
 * `ssh_key_name`
   * The ssh key used to connect to bastion instances.
   * Must already exist in the AWS region.
 * `vpc_id`
   * The VPC ID to be used by the security groups.

### Module Outputs

 * `bastion_elb_security_group_id`
 * `bastion_security_group_id`
   * this is the id you'll want to add to your own groups to allow connections from the bastion hosts
 * `elb_dns_name`
   * you'll probably use this output when pointing a `route53 alias` at the ELB
 * `elb_zone_id`

#### TODO

 * Find a way to pass an arbitrary mapping of tags through to the resources
 * Add support for notifications
 * Finish documenting input vars
 * Kill instances when the userdata fails

#### Author

  [Dean Wilson](http://www.unixdaemon.net)
