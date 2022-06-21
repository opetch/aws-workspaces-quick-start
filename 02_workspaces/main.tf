provider "aws" {
  region = var.region
}

variable "region" {
  type = string
}

variable "domain" {
  type = string
}

variable "users" {
  type = list(string)
}

variable "bundle_id" {
  type    = string
  default = "wsb-clj85qzj1"
}

variable "directory_id" {
  type = string
}

resource "aws_workspaces_workspace" "workspace" {
  for_each     = toset(var.users)
  directory_id = var.directory_id
  user_name    = each.value
  bundle_id    = var.bundle_id

  root_volume_encryption_enabled = true
  user_volume_encryption_enabled = true
  volume_encryption_key          = "alias/aws/workspaces"

  workspace_properties {
    compute_type_name                         = "VALUE"
    user_volume_size_gib                      = 10
    root_volume_size_gib                      = 80
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }

  tags = {
    (var.domain) = true
  }
}
