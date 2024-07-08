provider "google" {
  project = "elegant-atom-428812-v4"
  region  = "us-central1"
}

resource "google_project_service" "run_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = true
}

# Create the Cloud Run service
resource "google_cloud_run_service" "run_service" {
  name     = "app"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/elegant-atom-428812-v4/docker-repo/hello:1.0"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  # Waits for the Cloud Run API to be enabled
  depends_on = [google_project_service.run_api]
}

# Allow unauthenticated users to invoke the service
resource "google_cloud_run_service_iam_member" "run_all_users" {
  service  = google_cloud_run_service.run_service.name
  location = google_cloud_run_service.run_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}



