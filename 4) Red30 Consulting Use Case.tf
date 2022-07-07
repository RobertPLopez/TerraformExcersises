//-------------------------------------------------------------TERRAFORM USEAGE SCENARIOS------------------------------------------------------------------//

//key parts include web applications and a mySQL database to store data. This is the set up for these excerises (see the advanced terraform files for futher explination)

//Requirements 1: migrate to AWS using resoruces similar to the current arcetecture (lift-and-shift)

//Requirements 2: Improve applciation resilience using AWS Availabilty Zones

//Requirements 3: Maintain seperate environments: development, QA, stage, production  

    // first step is to analyze the current state arcitecture 

//-------------------------------------------------------------AWS TOOLS AND SETUP------------------------------------------------------------------//

//need to install the terraform extension in AWS and in terraform. need the access key and seceret access key within AWS

//-------------------------------------------------------------DESIGNING AWS INFRASTRUCTURE------------------------------------------------------------------//

//Linux VM = EC2 instances
//load balancer = AWS ELB
//AWS = VPC 
//Need to define the subnets
//Need and internet gatewate (need route table gateway)
//create and specficy a security group rules 

//----------------------------------------------------TERRAFORM CONFIGURATION STRUCTURE AND VARIABLE------------------------------------------------------------------//

# //////////////////////////////
# VARIABLES
# //////////////////////////////
variable "aws_access_key" {} //Need to get this from AWS

variable "aws_secret_key" {} //Need to get this from AWS

variable "ssh_key_name" {} //Need to get this from AWS

variable "private_key_path" {} //Need to get this from AWS

variable "region" {
  default = "us-east-2"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16" //65k hosts
}

variable "subnet1_cidr" {
  default = "172.16.0.0/24"
}

# //////////////////////////////
# PROVIDERS one of many providers availible
# //////////////////////////////
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

# //////////////////////////////
# RESOURCES Networking and other resources
# //////////////////////////////

# VPC
resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = "true"
}

# SUBNET
resource "aws_subnet" "subnet1" {
  cidr_block = var.subnet1_cidr
  vpc_id = aws_vpc.vpc1.id //Name of the VPC used in AWS
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[1]
}

# INTERNET_GATEWAY
resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.vpc1.id //Name of the VPC used in AWS
}

# ROUTE_TABLE
resource "aws_route_table" "route_table1" {
  vpc_id = aws_vpc.vpc1.id //Name of the VPC used in AWS

  route {
    cidr_block = "0.0.0.0/0" //any subnet within the VPC
    gateway_id = aws_internet_gateway.gateway1.id //associates the subnet with the entry VPC ID
  }
}

resource "aws_route_table_association" "route-subnet1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table1.id
}

# SECURITY_GROUP software defined firewall, use cidr notation to define what ports are utilized
resource "aws_security_group" "sg-nodejs-instance" {
  name = "nodejs_sg"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INSTANCE
resource "aws_instance" "nodejs1" {
  ami = data.aws_ami.aws-linux.id
  instance_type = "t2.micro" //Amazon offers 720 free micro hours a month. DONT FORGET TO CLEAN UP WHILE EXPIRAMENTING
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg-nodejs-instance.id] //square brackets indicate a list 
  key_name               = var.ssh_key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }
}


# //////////////////////////////
# DATA allows a configuration to query for external data
# //////////////////////////////
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# //////////////////////////////
# OUTPUT
# //////////////////////////////
output "instance-dns" {
  value = aws_instance.nodejs1.public_dns
}

//---------------------------------------------------------DEPLOYING THE BASIC CONFIGURATION------------------------------------------------------------------//

//need to initalize the command. Can have multiple provider 
    //command is: terraform init 
        //dont forget to change to the this file

    //terraform plan -out = s1.t-plan
        //used to review changes terraform will make 
        //plan is applied in reverse order, and is why you need understand the entirity of the system being implimented 

    //terraform, show s1.tfplan - spits out the human readable and machine readable json files 
        //this is used to help with the CI/CD pipeline
    
    //execute terraform show with no parameters. Shows you i a state file with no code. uses the state compared to the curret resources deployed then allows you to fix any discrepencies between the two. Configure the resrouces over code and iterate over it rather managing resrouces manually. 

//--------------------------------------------------------------REVIEW DEPLOYED RESORUCES------------------------------------------------------------------//

//useful command: 
    //export AWS_PAGER=""
    //aws ec2 describe-instances --query "Reservations[].Instances[].InstancesID" --output table

   //terraform destroy
