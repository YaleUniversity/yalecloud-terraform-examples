module "example-app" {
  source = "../modules/load_balancer"

  fqdn            = "example-app.yale.edu"
  name            = "example-app"
  cert            = "place AWS ACM certificate full ARN here - or remove entry to take default defined in module"
  target_id       = "<EC2 instance ID>"
  tags = {
    Application              = "example-app"
    Description              = "a good description of the webap"
    CreatedBy                = "netid"
    Environment              = "prd"
    SupportDepartment        = ""
    SupportDepartmentContact = ""
  }
}
