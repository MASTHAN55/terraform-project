
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The type of instance to create"
}

variable "ami_id" {
  type        = string
  default     = "ami-0e86e20dae9224db8"
  description = "The ID of the AMI to use for the instances"
}

variable "keypair" {
  description = "The name of the existing key pair"
  type        = string
}
