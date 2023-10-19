# Terraform for PetClinic

This document contains the stu-up of the infrastacture using terraform for PetClinic.

The folders include:

`ami` - an alternative that could potentially be used to create AMIs, however, we have provided a separate working code through Ansible already. (please note, this script has not been tested)
`s3` - This sets up a bucket to store your tfstate files. If you have a brand new machine, please make this is run before the petclinic code.
`terraform-petclinic` - Everything realted to the server set-up is included in here.

## Pre-Requists:

- AWS Account
- VPC that has the cidr-block set to 100.20.0.0/16
- Route Table setting with destionation to `0.0.0.0/0` with the target of `igw-0f4f620e2d6f4ab78`
- Jenkins Control and Agent machines set up manually - creating 2 instances


## S3

Please make sure your bucket is set-up **before** the petclinic script!

The directory includes the following:
- `variables.tf` - the required vairables for the script 
- `provider.tf` - confirming provide, which in our case is AWS
- `s3.tf` - the set up for our bucket (if you would like to have a new bucket, make sure you change the name that is globally unique)
- `policy.tf` - the policy set-up for your bucket. 

## Terraform Petclinic

After your S3 bucket has been set-up you can your your script for petclinic.

There are a couples of things that needs to be done in order to run the script succesfully:

**VPC**: We have already created a VPC manually, but in case you would like to set up a new vpc, you can follow the below instructions: 

1. On the search bar type in **VPC**
2. Select **Your VPCs** then click on **Create VPC**
3. Leave the resource state as **VPC only** 
4. Add a preffered name
5. for the **CIDR-block** we used : `100.20.0.0/16`. If you do wish to change it, please make sure all script are set up with the approriate CIDR-block.
6. Lave the IPv6 set-up as is
7. Add your preffered tag
8. Click on **Create VPC**


**AMI**: You should already have a script for creating an AMI, however, in order to create the AMI we need an **endpoint** from your database. You can run the script first, retrive the endpoint, add it to the relevant part of your Ansible code, and only after that you would be able to create the AMI. Once that is done, the AMI can be replaced in the `varuables.tf` secition and you can once again run the script with the correct AMI. 

- `provider.tf` - once again, we confirm the provider used for our script
- `vpc.tf` - we have already provided the manual set-up for a VPC, but this script will create the all the required **private** and **public** subnets, as well as the set-up for the **Route Table**.
- `sg.tf` - security group set-up. 
- `varaibles.tf` - variables for the scripts
- `db.tf` - Database set up - we used MySQL

if you wish to change the DB, you can either use our already creadted DB nsakpshot or create a new one and replace it 

- `webserver.tf` - it includes all the script to create an set-up your instances. 
- `alb.tf` - includes the application load balancer set-up


In case the script didn't start automatically, make sure you invidially log into `<tagname>` and `<tagname>` and run the `sudo systemctl start petclinic.service` command


## Jenkins Agent

To create a Jenkins Agent, you can use this documentation:
