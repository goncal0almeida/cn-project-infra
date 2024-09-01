variable "location" {
  type    = string
  default = "europe-west3"
}
variable "project_id" {
  type    = string
  default = "log-gdc-poc"
}

variable "dockerhub_username" {
  type      = string
  sensitive = true
}

variable "dockerhub_password" {
  type      = string
  sensitive = true
}
