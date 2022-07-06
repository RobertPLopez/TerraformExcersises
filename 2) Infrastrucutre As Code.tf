//---------------------------------------------------------------RESOURCES------------------------------------------------------------------//

//Provider definition for the type of resource

    //provider "aws" {
        //profile = "default"
        // regions = "us-west-2"
    //}

//Tells you what resource your resource wants to create
    //resource "aws+s3+bucket" "tf-course" {
        //bucket = "samuelson-terraform-20191107"
        //acl = "private"
    //}

//---------------------------------------------------------------BASIC RESOURCE TYPES------------------------------------------------------------------//

//See above VPC = virtual private cloud
//ingress / egress

//---------------------------------------------------------------TERAFORM STYLE------------------------------------------------------------------//

//propper spacing is two indents 
//single meta-arguments first

//---------------------------------------------------------------EXPANDING YOUR INSTALLATION------------------------------------------------------------------//

//---------------------------------------------------------------SECURITY GROUP------------------------------------------------------------------//

//can add descriptions for everything see bellow for setting up security rules

    //name = "prod_web"
    //description = "allow standard http and https ports inbound and everythign outbound"

    //ingress{
        //from_port = 80
        //to_port = 80
        //protocol = "tcp"
        //cidr_blocks = ["0.0.0.0", "1.2.3.4/32"] - can define multiple ips or an ip range
    //}

    //ingress{
        //from_port = 443
        //to_port = 443
        //protocol = "tcp"
        //cidr_blocks = ["0.0.0.0", "1.2.3.4/32"] - can define multiple ips or an ip range
    //}

    //egress{
        //from_port = 0
        //to_port = 0
        //protocol = "-1" - allows every protocal
        //cidr_blocks = ["0.0.0.0", "1.2.3.4/32"] - can define multiple ips or an ip range
    //}

    //tags = { - helps identify which resoruces are managed by terraform and is a good practice
        //"terraform" : "true"
    //}
//}

//---------------------------------------------------------------INSTANCE------------------------------------------------------------------//

//resource "aws_instance" "prod_web" {
    //ami = "instance id from aws"
    //instance_type ="t2.nano"
    //vpc_security_group_ids = [
        //aws_securtiy_group.prod_web.id
    //] - is the vpc that was created above

        //tags = { - helps identify which resoruces are managed by terraform and is a good practice
        //"terraform" : "true"
    //}
//}

//---------------------------------------------------------------STATIC IP------------------------------------------------------------------//

//resource "aws_eip" "prod_web" {
    //instance = aws_instance.prod_web.id

    //tags = { - helps identify which resoruces are managed by terraform and is a good practice
        //"terraform" : "true"
    //}
//}

//---------------------------------------------------------------SCALING------------------------------------------------------------------//

//terraform graph | grep -v -e 'metea -e -'close' -e 's3' -e 'vpc' -Gives you a pared down graph

//resource "aws_eip_association" "prod_web" {
    //instance = aws_instance.prod_web.id -use .0 or .1 to refers to the differnet allocation IDs 
        //allocation_id = aws_eip.prod_web.id
    //}

    //-decoupling the creation of the IP and its assignment

    //tags = { - helps identify which resoruces are managed by terraform and is a good practice
        //"terraform" : "true"
    //}

//---------------------------------------------------------------LOAD BALANCER------------------------------------------------------------------//

//resource "aws_default_subnet" "default" {}
    //availabilty_zone = "us-west-2a"
    //tage = {
        //"terraform" : "true"
    //}

//resource "aws_elb" "prod_web" {
    //name = "prod-web"
    //instance = aws_instance.prod_web.*.id
    //subnets = [aws_default_subnet.defualt_az1.id, aws_default_subnet.defualt_az2.id,]
    //security_groups = [aws_securitygroup.prod_web.id]

    //listener {
        //instance_port = 80
        //instance_port = "http"
        //lb_port = 80
        //lb_port = "http"
    //}

    //tage = {
        //"terraform" : "true"
    //}
//}



