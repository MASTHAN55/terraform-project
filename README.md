# Terraform-project

## Deploying and Managing AWS resources by using TERRAFROM

The project involves using Terraform, an open-source Infrastructure as Code (IaC) tool, to automate the deployment and management of scalable and secure AWS cloud infrastructure. This setup supports a multi-tier architecture, including VPC, subnets, EC2 instances, security groups, AWS cli, Jenkins, and Docker while allowing for version control, reuse, and easy modifications to the infrastructure.

# Key Components:

## Virtual Private Cloud (VPC):
Create a VPC with public and private subnets across multiple availability zones for high availability.
Internet Gateway (IGW) for public access.
NAT Gateway for secure internet access from private subnets.

## Security Groups and Network ACLs:
Configure security groups to control inbound and outbound traffic for EC2 instances.
Set up Network Access Control Lists (NACLs) for additional network traffic filtering.

## EC2 Instances:
Provision EC2 instances in public subnets to act as web servers.
Launch EC2 instances in private subnets for backend databases or application services.
Use user data scripts for automatic configuration (installing web servers, etc.)

## S3 Buckets:
Set up S3 buckets for storing static assets, backups, or logs.
Configure proper policies for secure access to S3 resources.

## Elastic Load Balancer (ELB):
Deploy a load balancer to distribute traffic across EC2 instances in different availability zones, ensuring fault tolerance.

## RDS (Relational Database Service):
Provision a MySQL/PostgreSQL database using RDS in private subnets.
Enable multi-AZ deployment for database redundancy.

## Auto Scaling:
Configure Auto Scaling groups to automatically adjust the number of EC2 instances based on traffic load.

## IAM Roles and Policies:
Define IAM roles and attach them to EC2 instances to securely access AWS services (e.g., access to S3).
Implement least privilege principle by assigning minimal permissions required for each service.

# Outcome:
The project successfully demonstrated how to use Terraform for automating and managing AWS infrastructure, enabling efficient resource scaling, improved security, and simplified management. This project highlighted the ability to treat infrastructure as code, reducing manual intervention and errors.
