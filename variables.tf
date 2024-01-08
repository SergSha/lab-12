variable "yc_token" {
  type      = string
  sensitive = true
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-b"
}

variable "db_root_password" {
  type = string
  sensitive = true
}

variable "db_user_username" {
  type = string
  sensitive = true
}

variable "db_user_password" {
  type = string
  sensitive = true
}