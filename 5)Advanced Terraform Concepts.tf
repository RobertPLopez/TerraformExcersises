//-----------------------------------------------------VARIABLES-------------------------------------------------------------//

//Map variable - key value pairs
//Object variables
//Tuples variables

# //////////////////////////////
# VARIABLES
# //////////////////////////////
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "region" {
  default = "us-east-2"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet1_cidr" {
  default = "172.16.0.0/24"
}

variable "environment_list" {
  type = list(string)
  default = ["DEV","QA","STAGE","PROD"]
}

variable "environment_map" {
  type = map(string)
  default = {
    "DEV" = "DEV",
    "QA" = "QA",
    "STAGE" = "STAGE",
    "PROD" = "PROD"
  }
}

variable "environment_instance_type" {
  type = map(string)
  default = {
    "DEV" = "t2.micro",
    "QA" = "t2.micro",
    "STAGE" = "t2.micro",
    "PROD" = "t2.micro"
  }
}

variable "environment_instance_settings" {
  type = map(object({instance_type=string, monitoring=bool}))
  default = {
    "DEV" = {
      instance_type = "t2.micro", 
      monitoring = false
    },
   "QA" = {
      instance_type = "t2.micro", 
      monitoring = false
    },
    "STAGE" = {
      instance_type = "t2.micro", 
      monitoring = false
    },
    "PROD" = {
      instance_type = "t2.micro", 
      monitoring = true
    }
  }
}

# //////////////////////////////
# PROVIDERS
# //////////////////////////////
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

# //////////////////////////////
# RESOURCES
# //////////////////////////////

# VPC
resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = "true"
}

# SUBNET
resource "aws_subnet" "subnet1" {
  cidr_block = var.subnet1_cidr
  vpc_id = aws_vpc.vpc1.id
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[1]
}

# INTERNET_GATEWAY
resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.vpc1.id
}

# ROUTE_TABLE
resource "aws_route_table" "route_table1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }
}

resource "aws_route_table_association" "route-subnet1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route_table1.id
}

# SECURITY_GROUP
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
  instance_type = var.environment_instance_type["DEV"]
  //instance_type = var.environment_instance_settings["PROD"].instance_type
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.sg-nodejs-instance.id]

  monitoring = var.environment_instance_settings["PROD"].monitoring

  tags = {Environment = var.environment_list[0]}

}

# //////////////////////////////
# DATA
# //////////////////////////////
data "aws_availability_zones" "available" {}

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

output "private-dns" {
  value = aws_instance.nodejs1.private_dns
}

//-------------------------------------------------FUNCTIONS IN TERRAFORM--------------------------------------------------------//

//files:
    //terraform.tfvars, terraform.tfvars.json, *.auto.tfvars 
    //Sets the various terraforms values for integration with other tools 

//Enviornment variables
    //export TF_VAT_nameOfInstance to be set 

//command line
    //-var can set variables within the CLI
    //dont store seceret in the variable files 

//----------------------------------------------------OUTPUT VARIABLES-------------------------------------------------------------//

# //////////////////////////////
# OUTPUT
# //////////////////////////////
output "instance-dns" {
  value = aws_instance.nodejs1.public_dns
}

//tells the program what to output the variable 

//-------------------------------------------------EXPRESSIONS IN TERRAFORM--------------------------------------------------------//

//Does not support user-defined functions 
//terraform console starts a RAPL 
    //Read
    //Analize
    //Prep
    //Loop
        //There is some basic support for logic (ternery opperators)

//-------------------------------------------------FUNCTIONS IN TERRAFORM--------------------------------------------------------//

//Terraform functions are grouped within the language known as libraries (these are built into the program)
    //Numeric
    //string 
    //collection 
    //encoding
    //filesystem
    //date and tiem
    //hash and crypto
    //ip network
    //type conversion

//terraform console (will bring you in the RAPL)
    //can call out the terrafrom CaaI from above into the terraform console. This allows HCL to work directly with the files and see how they interact on a code level. 

//--------------------------------------------------COUNT----------------------------------------------------------//

//You can put the count into the instance to help determine how many times terraform repeats the resource deployment 
//each instance will have its own state entry
    //add .*. to the output command to apply each of those plans 

//use the for_each arguement to itterate over the count use the following code block to iterate a for each loop within HCI
    resource "aws_iam_user" "iam-users" {
        for_each = var.iam_accounts

        name = each.key
    }

//-------------------------------------------------MODULES--------------------------------------------------------//

//self contained encapsualted set of resoruces 
// Hashicorp maitain a large library of modules 
//use the terriform registry
