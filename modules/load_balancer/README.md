## A terraform ALB module

### Usage

Under the ./albs directory create a file well named - e.g. project-name.tf - to represent the new ALB.  You can add many files each representing a different load balancer.

The backend will need to listen on 443 with HTTPS/TLS - self-signed certificates are fine.  Do this with nginx.

The ALB access log S3 bucket will be created only during the first run - if it does not exist.

#### account specific variables

Replace the following variables with elements from your AWS account: e.g., <vpcID> --> "vpc-nnnnnnnnnnnnnnnnn".  These variables will be reused for every new ALB you add.

##### modules/load_balancer/variables.tf

vpc_id:
<vpcID>

public_subnets:
<subnetID01>,<subnetID02>

cert:
arn:aws:acm:us-east-1:<accountID>:certificate/<certID>

##### albs/variables.tf

s3_alb_access_log_name:
<s3-alb-access-log>

#### Replace the following variables on the with albs/project-name.tf

- fqdn - fully qualified domain name
- name - can be the same as the project-name.tf - this is the friendly name in AWS
- cert - the default for the module would be defined here - probaly a wild-card certificate *.example.org.  Look up the ARN in the ITS spinup account in ACM
- target_id - ID for EC2 instance
- tags - Do get actual useful information

```module "example-app-01" {
  source            = "../modules/load_balancer"

  fqdn            = "example-app-01.example.org"
  name            = "example-app-01"
  cert            = "place AWS ACM certificate here - full ARN " # or comment out/remove and take the default ^^^ from modules/load_balancer/variables.tf
  target_group_id = "<EC2 instance ID>"
  tags            = {
    Description              = "example-app-01"
    CreatedBy                = "netid"
    Environment              = "tst/prd"
    SupportDepartment        = "changeme"
    SupportDepartmentContact = "changeme"
  }
}
```
