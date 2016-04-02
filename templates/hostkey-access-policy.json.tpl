{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${host_keys_bucket}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "S3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${host_keys_bucket}/*"
            ]
        }
    ]
}
