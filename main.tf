resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service"
  location = var.location
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
