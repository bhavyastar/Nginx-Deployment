
# Deploy Nginx Web Server Using Terraform and Ansible

This project demonstrates how to deploy an Nginx web server on private instances using Ansible, route requests through an Application Load Balancer, and provide access to the ALB via an API Gateway on AWS.

## Features

- **VPC with Large CIDR Block**: Configures a VPC suitable for at least 32,000 IPs, including both public and private subnets.
- **SSH Keypair Management**: Dynamically generates SSH keypairs for secure instance access.
- **Multi-zone EC2 Deployment**: Deploys two private instances and one public jump host across three availability zones.
- **Ansible Integration**: Uses Ansible to install Nginx and Docker on all private instances.
- **NAT and Internet Gateway Setup**: Facilitates internet connectivity for instances through a NAT and an Internet Gateway.
- **Load Balancer Configuration**: Implements an ALB to manage traffic to the private instances.
- **API Gateway Module**: Sets up an API Gateway to expose services through the ALB and display the Nginx page.

## Prerequisites


- Terraform 0.13+
- AWS CLI with configured credentials
- Ansible 2.9+

## Initial Setup

1. **Configure AWS CLI**:
   Ensure your AWS CLI is configured with at least `AdministratorAccess`. Run the following:
   ```bash
   aws configure
   ```
   Enter your AWS Access Key ID, Secret Access Key, region, and output format.

   <img width="455" alt="Screenshot 2024-05-20 at 7 57 23 AM" src="https://github.com/bhavyastar/zenskar-assignment/assets/84725791/13aa4e75-b40e-406c-9f33-6a6258b0ea90">


2. **Configure Paths**:
   In `terraform/main.tf`, update the actual path of your `key.pem`. In `module/ec2/main.tf`, configure the template file path and file name path. Use `pwd` in your terminal from your project's root directory (e.g., `zenskar-assignment`) and adjust the paths accordingly. 

   ```bash
   /Users/bhavyasachdeva/Desktop/zenskar-assignment
   ```


   

## Clone the Repository

```bash
git clone https://github.com/bhavyastar/zenskar-assignment.git
cd zenskar-assignment/terraform
```

## Using Terraform Commands to Create Infrastructure

1. **Initialize**:
   ```bash
   terraform init
   ```

2. **Plan**:
   ```bash
   terraform plan
   ```

3. **Apply**:
   Apply the Terraform configuration to start building the infrastructure:
   ```bash
   terraform apply
   ```

4. Automation ensures that Ansible does not require manual intervention.

   
<img width="646" alt="Screenshot 2024-05-20 at 7 58 23 AM" src="https://github.com/bhavyastar/zenskar-assignment/assets/84725791/8e5fdcc2-f4f7-4446-aac0-49047efcebf8">



## Verifying from AWS

1. After completing all steps, go to your AWS Console. You should see that instances are running, and the load balancer is configured properly.

<img width="677" alt="Screenshot 2024-05-20 at 7 58 42 AM" src="https://github.com/bhavyastar/zenskar-assignment/assets/84725791/8f0737bb-8dbc-4989-bd6b-e6db29097c8c">


2. Locate the API Gateway named `ngx-api` where our Nginx is deployed.
<img width="676" alt="Screenshot 2024-05-20 at 7 59 06 AM" src="https://github.com/bhavyastar/zenskar-assignment/assets/84725791/f5c7ad7b-11c5-45fd-91bb-a1b5c247a74e">

<img width="1058" alt="Screenshot 2024-05-20 at 8 02 45 AM" src="https://github.com/bhavyastar/zenskar-assignment/assets/84725791/c8585e10-6d51-43de-ae17-0c1a07cd0093">


3. Click on the stages and navigate to "default" to copy the Invoke URL and paste it into the browser:

<img width="642" alt="Screenshot 2024-05-20 at 7 57 51 AM" src="https://github.com/bhavyastar/zenskar-assignment/assets/84725791/9ace737e-f608-4cb7-85be-e3aff3186929">

<img width="684" alt="Screenshot 2024-05-20 at 8 00 55 AM" src="https://github.com/bhavyastar/zenskar-assignment/assets/84725791/5e7c1913-082e-4a8c-920e-c4a830d2e9fe">

4. Add the root path after "default" like this:

```plaintext
https://<id>.execute-api.us-east-1.amazonaws.com/default/
```

5. You will see a welcome message from Instance 1, indicating that it serves the Nginx page. Depending on the load, you may also see "Welcome from Instance 2", demonstrating the main purpose of the API Gateway.

<img width="951" alt="Screenshot 2024-05-20 at 8 00 09 AM" src="https://github.com/bhavyastar/zenskar-assignment/assets/84725791/893a83d4-23b8-40e2-b8a6-f15c1a4c545c">



## Architecture

<img width="1024" alt="Screenshot 2024-05-20 at 8 05 46 AM" src="https://github.com/bhavyastar/zenskar-assignment/assets/84725791/1b73f9e5-5295-4cbc-9a57-97649f92ef58">


