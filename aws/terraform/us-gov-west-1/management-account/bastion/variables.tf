variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "resource_prefix" {
  description = "Resource prefix for resources"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "instance_name" {
  description = "The name of the ec2 instance"
  type        = string
}

variable "instance_size" {
  description = "The type of instance to start"
  type        = string
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
}

variable "root_volume_type" {
  description = "The type of the root ebs volume on the ec2 instances created"
  type        = string
  default     = "gp3"
}

variable "instance_volume_size" {
  description = "The size of the root ebs volume on the ec2 instances created"
  type        = string
}

variable "ebs_volumes" {
  description = "A list of maps that must contain device_name (ex. '/dev/sdb') and size (in GB). Optional args include type, throughput, iops, multi_attach_enabled, final_snapshot, snapshot_id, outpost_arn, force_detach, skip_destroy, stop_instance_before_detaching, and tags"
  type = list(object({
    device_name                    = string
    size                           = number
    type                           = string
    throughput                     = optional(number)
    iops                           = optional(number)
    multi_attach_enabled           = optional(bool, false)
    final_snapshot                 = optional(string)
    snapshot_id                    = optional(string)
    outpost_arn                    = optional(string)
    force_detach                   = optional(bool, false)
    skip_destroy                   = optional(bool, false)
    stop_instance_before_detaching = optional(bool, false)
    tags                           = optional(map(string), {})
  }))
  default = []
}

variable "ebs_optimized" {
  description = "Whether or not the instance is ebs optimized"
  type        = bool
  default     = false
}

variable "target_group_arns" {
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
  default     = []
  type        = list(string)
}


variable "private_ip" {
  description = "The private ip for the instance"
  type        = string
  default     = null
}

variable "additional_security_groups" {
  description = "A list of additional security groups to attach to the network interfaces"
  type        = list(string)
  default     = []
}

variable "associate_public_ip" {
  description = "Whether or not to associate a public IP (not EIP)"
  type        = bool
  default     = false
}

variable "associate_eip" {
  description = "Whether or not to associate an Elastic IP"
  type        = bool
  default     = false
}

variable "sg_description" {
  description = "This overwrites the default generated description for the security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "The list of rules for ingress traffic. Required fields for each rule are 'protocol', 'from_port', 'to_port', and at least one of 'cidr_blocks', 'ipv6_cidr_blocks', 'security_groups', 'self', or 'prefix_list_sg'. Optional fields are 'description' and those not used from the previous list"
  type = list(object({
    protocol         = string
    from_port        = string
    to_port          = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool)
    description      = optional(string, "Managed by Terraform")
  }))
  default = []
}

variable "egress_rules" {
  description = "The list of rules for egress traffic. Required fields for each rule are 'protocol', 'from_port', 'to_port', and at least one of 'cidr_blocks', 'ipv6_cidr_blocks', 'security_groups', 'self', or 'prefix_list_sg'. Optional fields are 'description' and those not used from the previous list"
  type = list(object({
    protocol         = string
    from_port        = string
    to_port          = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool)
    description      = optional(string, "Managed by Terraform")
  }))
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}


variable "keys_to_grant" {
  description = "A list of kms keys to grant permissions to for the role created."
  type        = list(string)
  default     = []
}

variable "additional_eni_ids" {
  description = "This variable allows for an ec2 instance to have multiple ENIs.  Instance count must be set to 1"
  type        = list(string)
  default     = []
}

variable "source_dest_check" {
  description = "Whether or not source/destination check should be enabled for the primary network interface"
  type        = bool
  default     = true
}

variable "assume_role_policy" {
  description = "Policy document allowing Principals to assume this role (e.g. Trust Relationship)"
  type        = string
  default     = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

variable "module_depends_on" {
  description = "A variable to simulate the depends on feature that resources have"
  type        = any
  default     = null
}