
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

   ![AWS CLI Configuration](https://hackmd.io/_uploads/r1789XdXA.png)

2. **Configure Paths**:
   In `terraform/main.tf`, update the actual path of your `key.pem`. In `module/ec2/main.tf`, configure the template file path and file name path. Use `pwd` in your terminal from your project's root directory (e.g., `zenskar-assignment`) and adjust the paths accordingly. 

   ```bash
   /Users/bhavyasachdeva/Desktop/zenskar-assignment
   ```

   ![Path Configuration](https://hackmd.io/_uploads/SyrY27Om0.png)

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

   ![Ansible Automation](https://hackmd.io/_uploads/r1W307dmC.png)



## Verifying from AWS

1. After completing all steps, go to your AWS Console. You should see that instances are running, and the load balancer is configured properly.

![AWS Console Load Balancer](https://hackmd.io/_uploads/SkX-1E_XA.png)

2. Locate the API Gateway named `ngx-api` where our Nginx is deployed.

![API Gateway](https://hackmd.io/_uploads/SJ571VOXA.png)

3. Click on the stages and navigate to "default" to copy the Invoke URL and paste it in the browser:

![Invoke URL](https://hackmd.io/_uploads/r19FkE_X0.png)

4. Add the root path after "default" like this:

```plaintext
https://<id>.execute-api.us-east-1.amazonaws.com/default/
```

5. You will see a welcome message from Instance 1, indicating that it is serving the Nginx page. Depending on the load, you may also see "Welcome from Instance 2", demonstrating the main purpose of the API Gateway.

![Welcome Page](https://hackmd.io/_uploads/BJ37eEdXA.png)
```
