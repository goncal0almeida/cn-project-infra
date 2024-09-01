resource "google_cloud_run_v2_service" "default" {
  name     = "test-service"
  location = var.location
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }

  lifecycle {
    ignore_changes = [
      template["image"],
    ]
  }
}

resource "google_cloud_run_v2_service_iam_member" "member" {
  location = var.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_compute_region_network_endpoint_group" "default" {
  name                  = "cloudrun-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.location
  cloud_run {
    service = google_cloud_run_v2_service.default.name
  }
}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 9.0"
  project = var.project_id
  name    = "my-lb"

  backends = {
    default = {
      groups = [
        {
        group = google_compute_region_network_endpoint_group.default.id }
      ]
      protocol   = "HTTP"
      enable_cdn = false

      log_config = {
        enable = false
      }

      iap_config = {
        enable = false
      }
    }
  }
}
