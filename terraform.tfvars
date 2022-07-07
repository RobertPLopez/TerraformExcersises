whitelist            = ["0.0.0.0/0"]
web_image_id         = "ami-03c8adc67e56c7f1d"
web_instance_type    = "t2.micro"
web_desired_capacity = 1
web_max_size         = 1
web_min_size         = 1

# MAC/LINUX
# aws ec2 create-key-pair --key-name tf_key --query 'KeyMaterial' --output text > tf_key.pem
###
# WINDOWS
# aws ec2 create-key-pair --key-name tf_key --query 'KeyMaterial' --output text | out-file -encoding ascii -filepath tf_key.pem
