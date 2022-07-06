//provider "aws" {
  //profile = "default"
  //region = "us-east"
//}

//resource "aws_s3_nucket" "tf_course" {
  //bucket = "tf-course-20220703"
  //acl = "private"
//}

//terraform init //Same directory as your terraform file

//Automatically download and install what we need. 

//terraform apply

//Lets you define infrastructure as a code. Define resrouces by using other resource. Terraform is taking your code comparing it to the current state, and developing a plan for how to make the code match the state.

//---------------------------------------------------------------PLAN--------------------------------------------------------------------//

//terraform plan --help
//terraform okan -destroy
  //terramorn plan -destroy -out=example.plan This saves the terraform plan to the requested file 
  //terraform show example.plan This will show your file (this is saved as a binary file)

//---------------------------------------------------------------STATE------------------------------------------------------------------//

//terraform.tstate allows you see the current state of the plan

//terraform state allows you see the state. Try to avoid this 

//terraform show 
  //terraform -json (gives you the binary wrapper state)

//--------------------------------------------------------------GRAPH--------------------------------------------------------------------//

//terraform graph - allows you to see what terraform is doing from a visual perspective

//webgraphbiz.com - allows you use the terraform graph to oput an image file. Copy and past the terraform graph output into the file 

//--------------------------------------------------------------APPLY--------------------------------------------------------------------//

//terraform apply -auto-approve is lets you auto apply your plan without your own involvement