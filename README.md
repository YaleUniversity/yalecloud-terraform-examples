# yalecloud-terraform-examples

A grouping of terraform code and terraform modules useful for general purposes

## Modules 

load_balancer - uses AWS ALB.  Look at the load_balancer module README.md: modules/load_balancer/README.md

## Usage

### how to use the load_balancer module
 
* cd albs 

* mv example-app.tf ${your-app-name}.tf 

* customize the filename itself ${your-app-name}.tf, and follow along in modules/load_balancer/README.md

* paste ACCESS_KEYs into terminal: 

  * export AWS_ACCESS_KEY_ID="abc123"

  * export AWS_SECRET_ACCESS_KEY="xyx789"

* terraform init

* terraform plan

  * terraform will output errors if variables.tf is not updated correctly

* terraform apply

## Author

Darryl Wisneski darryl.wisneski@yale.edu

## License

GNU Affero General Public License v3.0 (GNU AGPLv3)

Copyright © 2020 Yale University
