variable "region" {}
variable "ami" {}
variable "ansible_instance_type" {}
variable "worker_instance_type" {}
variable "spoke_count" {
  type = number
}
variable "key_location" {}
variable "environment" {}