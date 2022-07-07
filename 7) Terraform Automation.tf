//----------------------------CI/CD Automation------------------------------------//

//Source control / and CI/CD orrchestrator such as jenkins. Test code can be deployed to new provisioned environments, including configuration drift, but resources, upgrades on newly provisioned infrastructure, can be provisioned and walled off, deploy services to new vms and then test through provisioning and deployment of new applciations. 

//----------------------------Using Jenkins------------------------------------//

//jenkins the deployments need to be done in a remote state. deploys the infrastrucuture configuration into a single pipeline essentially hooks

//written in groovy. Clones the files, then breaks up the terraform CLI command. Pipelibe definiation. Can be extended and enhanved to include application deployments and a testing environment. 

//----------------------------setting Terraform Cloud------------------------------------//

//base plan is free and is offered by HashiCorp

//----------------------------setting Terraform GitHub------------------------------------//

//Flow is always the init plan and apply commands. Supports a GitOps Pipeline that sends a trigger whenever a branch changes. This allows you to apply branch changes autoamtically utilizing Jenkins combined with terraform. need to install a terraform plugin to your github to enable automatic deployment. Click configure variables. 

//Dont forget to setup the terraform working directory to figure out where our deployment lives. 

