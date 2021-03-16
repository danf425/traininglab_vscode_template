# Driving Compliance Workshop

This repo is will spin up the necessary resources to run the Driving Compliance Wrokshop. Currently only the AWS terraform is updated.

## Requirements

- [ChefDK or Chef Workstation](https://downloads.chef.io)
- [Terraform](https://terraform.io)
- [jq](https://stedolan.github.io/jq/)
- AWS Account in the Chef SA Organization (for SSL certificates)
- Automate 2 License

## Provision Automate 2 & User Workstations

The terraform code in this repo allows you to provision a Chef Automate 2.0 instance and a Workstation for each user running VS Code-Server. The version of Code-Server needs to be specified in your `tfvars` file. DNS records for your automate instance and the individual workstations will be created.  The records are dynamically driven from variables in your `tfvars`. Additionally the code will create an application load balancer with a valid ssl certificate (`something.chef-demo.com`) and redirect all HTTP requests to HTTPS.

### AWS Considerations

This repo requires that a wild-card ACM certificat be pre-created and exist for consumption on the TLD of the A2 server. Currently uses the *.chef-demo.com wildcard certificate in  the SA-AWS.

### Azure Considerations (Terraform needs updated)

A DNS managed zone must exist in Azure DNS for provisioning to work properly.  This is controlled by settings in `variables.tf`.

### GCP Considerations (Terraform needs updated)

A DNS managed zone must exist in Google Cloud DNS for provisioning to work properly.  This is controlled by settings in `variables.tf`.


### Usage

1. This repo includes a `terraform.tfvars.SAexample` file. Copy that file to a new file called `terraform.tfvars` and update the values accordingly
2. Run `terraform init`
3. Run `terraform apply`

At the end of the `terraform` run you will see the credentials for your automate instance and URLs for the workstations in the `STDOUT`:

```bash
...
Apply complete! Resources: 52 added, 0 changed, 0 destroyed.

Outputs:

a2_admin = admin
a2_admin_password = 709ea04cbfaa090b81dd8ade53a49c82
a2_token =  9hUD_XqO5J8GiNriJEiIbw5bwhE=
a2_url = https://jquilty-a2.chef-demo.com
chef_automate_public_ip = 3.23.102.205
chef_automate_server_public_r53_dns = jquilty-a2.chef-demo.com
workstation_public_DNS = [
  "jq-workstation-1.chef-demo.com",
  "jq-workstation-2.chef-demo.com",
  "jq-workstation-3.chef-demo.com",
  "jq-workstation-4.chef-demo.com",
]
```
Users attending can access their workstations from any web browser and have access to a terminal and VS Code editor.
![VS-Code-Server](/images/vs-code-server.png)

