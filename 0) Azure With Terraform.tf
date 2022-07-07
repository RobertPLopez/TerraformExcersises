//------------------------------------Intro to Terraform on Azure---------------------------//

//devided in blocks, code, and exceptions. Cloud agnostic and cross platform tool. Simplifies the management of most if not all infrastructure. 

// The pieces of your environments are broken up into modules 

//BICEP vs Terraform 
    //BICEP: 
        //uses a declartivie syntax to manage resoruce (BICEP is propitary to Microsoft). 
        //State file automatically managed 
        //Immediate support for new Azure features 

    //Terraform: 
        //cloud agnostic 
        //state file must be maintatined 
        //may take time to support new azure features 

//------------------------------------Setting up the Envrinment---------------------------//

//Install Azure CLI (download the MSI file from Microsoft website)
    //enter into the current azure powershell session
    //choclate helps you manage your windows open source packages. 

//use source control to manage you version control 

//------------------------------------Getting started with Terraform----------------------//

//Terraform init - initalize a terraform command
//Terraform validate - troubleshooting 
//terraform plan - changes that will take place with your current configuration 
//Terraform apply - to apply the current configuration 
//Terraform destroy - will destroy all previous infrastrucutrue 

//Terraform CLI workspaces - allows you have multiple workspaces within the same terriform directory. Terraform cloud workspaces create differetn directories 
    //terraform workspace show 
    //terraform workspace list - lists all workspaces
    //terraform workspace new dev - creates new workspace
    //terraform workspace select dev - to change workspaces 

//Terraform state: the state file maps real world resoruces to your configuration, keeps track of metadata, and improves performance for large infrastrucutres
    //dont directly edit this file 
    //locally stored in files called"terraform.tfstate"
    //can be stored remotely. Does refresh to make sure your resrouces are matching on azure 
    //written in JSON

//------------------------------------Creating with Terraform---------------------------//

//Resource
    //resource blocks are the most important part of terraform 
    //decribe one or more virtual objects 
    //resource are save in the terraform state file once they are run with terrform apply 

//providers
    //relies on external providers to tell terraform where you configuring your resources 
    //azure rm provider 
    //run terraform inti to add providers to the state files 

//------------------------------------Terraform in Action---------------------------//

//See below for the azure example:

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.12.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
}

//first terraform resrouce for creatation:

resource "azurerm_resrouce_group" "main" {
    name = "learn-tf-rg-eastus"
    location = "eastus"
}

#Creates virtual network
resource "azurerm_virtual_network" "main" {
  name                = "learn-tf-vnet-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
}

#Create subnet
resource "azurerm_subnet" "main" {
  name = "learn-tf-subnet-eastus"
  virtual_network_name = azurerm_virtual_network.main.name 
  resource_group_name = azurerm_resource_group.main.name 
  address_prefixes = ["10.0.0.0/24"]
}

#Creates network interface card (NIC)
resource "azurerm_network_interface" "internal" {
  name                = "learn-tf-nic-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create a VM
resource "azurerm_windows_virtual_machine" "main" {
    name = "learn-tf-vm-eastus"
    resource_group_name = azurerm_resrouce_group.main.name
    location = azurerm_resource_group.main.location
    size = "Standard_B1s"
    admin_username = "user.admin"
    admin_password = "enter-password"

    network_interface_ids = [
        azurerm_network_interface.internal.id
    ]

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "MicrosoftwindowsServer"
      offer = "windowsServer"
      sku = "2019"
      version = "latest"
    }
}

#Make sure to run terraform destroy! On expiramnetal or destroyed based environments