data "google_project" "project" {}

resource "google_secret_manager_secret" "default" {
  secret_id = "dockerhub-password"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "default" {
  secret      = google_secret_manager_secret.default.id
  secret_data = var.dockerhub_password
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  secret_id = google_secret_manager_secret.default.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}

resource "google_artifact_registry_repository" "my-repo" {
  location      = var.location
  repository_id = "example-dockerhub-remote"
  description   = "example remote dockerhub repository with credentials"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description                 = "docker hub with custom credentials"
    disable_upstream_validation = true
    docker_repository {
      public_repository = "DOCKER_HUB"
    }
    upstream_credentials {
      username_password_credentials {
        username                = var.dockerhub_username
        password_secret_version = google_secret_manager_secret_version.default.name
      }
    }
  }
}
