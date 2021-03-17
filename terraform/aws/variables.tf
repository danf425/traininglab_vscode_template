////////////////////////////////
// AWS Connection

variable "aws_region" {
  default     = "us-east-1"
  description = "aws_region is the AWS region in which we will build instances"
}

variable "aws_profile" {
  default     = "default"
  description = "aws_profile is the profile from your credentials file which we will use to authenticate to the AWS API."
}

variable "aws_credentials_file" {
  default     = "~/.aws/credentials"
  description = "aws_credentials_file is the file on your local disk from which we will obtain your AWS API credentials."
}

variable "aws_key_pair_name" {
  default     = "habmgmt_demo"
  description = "aws_key_pair_naem is the AWS keypair we will configure on all newly built instances."
}

variable "aws_key_pair_file" {
  description = "aws_key_pair_file is the local SSH private key we will use to log in to AWS instances"
}

variable "aws_ami_id" {
  description = "aws_ami_id is the (optional) AWS AMI to use when building new instances if you would prefer to specify a specific AMI instead of using the latest for your platform."
  default     = ""
}

////////////////////////////////
// Object Tags

variable "tag_customer" {
  description = "tag_customer is the customer tag which will be added to AWS"
}

variable "tag_project" {
  description = "tag_project is the project tag which will be added to AWS"
}

variable "tag_name" {
  description = "tag_name is the name tag which will be added to AWS"
}

variable "tag_dept" {
  description = "tag_dept is the department tag which will be added to AWS"
}

variable "tag_contact" {
  description = "tag_contact is the contact tag which will be added to AWS"
}

variable "tag_application" {
  description = "tag_application is the application tag which will be added to AWS"
}

variable "tag_ttl" {
  default = 4
}

////////////////////////////////
// OS Variables

variable "aws_centos_image_user" {
  default     = "centos"
  description = "aws_centos_image_user is the username which will be used to log in to centos instances on AWS"
}

variable "aws_ubuntu_image_user" {
  default     = "ubuntu"
  description = "aws_ubuntu_image_user is the username which will be used to log in to ubuntu instances on AWS"
}

variable "platform" {
  default     = "ubuntu"
  description = "platform will be used to specify the correctl home directory to be used during A2 setup"
}

////////////////////////////////
// Training Lab

variable "channel" {
  default     = "current"
  description = "channel is the habitat channel which will be used for installing A2"
}

variable "lab_hostname" {
  description = "lab_hostname is the hostname which will be given to your A2 instance"
}

variable "lab_license" {
  default     = ""
  description = "lab_license is the license key for your A2 installation"
}

variable "lab_alb_acm_matcher" {
  default     = "*.workshops.learn.chef.io"
  description = "Matcher to look up the ACM cert for the ALB (when using training_lab_alb.tf"
}

variable "lab_alb_r53_matcher" {
  default     = "workshops.learn.chef.io."
  description = "Matcher to find the r53 zone"
}

variable "lab_custom_ssl" {
  default     = "false"
  description = "Enable to configure lab with the below certificate"
}

variable "lab_custom_ssl_private_key" {
  default     = "Paste private key here"
  description = "lab_private_key is the SSL private key that will be used to congfigure HTTPS for A2"
}

variable "lab_custom_ssl_cert_chain" {
  default     = "Paste certificate chain here"
  description = "lab_cert_chain is the SSL certificate chain that will be used to congfigure HTTPS for A2"
}

variable "lab_server_instance_type" {
  default     = "m4.xlarge"
  description = "lab_server_instance_type is the AWS instance type to be used for A2"
}

variable "lab_user_password" {
  description = "password for all lab user accounts"
}

////////////////////////////////
// Habitat Workstation

variable "workstation_ami_owner" {
  # type        = string
  description = "Amazon Owner ID for filtering AMI given by ami_filter"
  default     = "446539779517"
}

variable "workstation_user" {
  description = "SSH User for AMI given by ami_filter"
  default     = "centos"
}

variable "workstation_user_password" {
  description = "SSH User password for AMI given by ami_filter"
  default     = "L0gDN4!"
}


variable "workstation_type" {
  description = "Instance type for the application, eg. m4.large"
  default     = "t3.medium"
}

variable "workstation_count" {
  description = "Number of workstation (student) instances to create. Usually matches user_count for number of lab users to add."
}

variable "workstation_volume_size" {
  description = "Size in GB of instance main volume"
  default     = "8"
}

variable "workstation_dns_prefix" {
  description = "DNS Prefix of workstaion URL"
  default     = "chef"
}

