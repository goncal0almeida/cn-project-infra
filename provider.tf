terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
    }
  }

  backend "gcs" {
    bucket = "cn-poc-terraform-remote-backend"
    prefix = "terraform/state"
  }
}


provider "google" {
  # Configuration options
  project = var.project_id
  region  = var.location
}
