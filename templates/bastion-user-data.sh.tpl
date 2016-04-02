#!/bin/bash

apt-get update
apt-get install awscli -y

aws --region ${region} s3 cp --recursive s3://${host_keys_bucket}/ /etc/ssh/

chown -R root: /etc/ssh/
