provider "google" {
    alias = "tokengen"
    credentials = "${file(var.terraform_sa_credentials)}"
}
data "google_service_account_access_token" "sa" {
    provider = google.tokengen
    target_service_account = var.terraform_runner
    lifetime = "600s"
    scopes = ["userinfo-email", "cloud-platform",]
}
provider "google" {
    project = var.project
    region = var.region
    zone = var.zone
    access_token = data.google_service_account_access_token.sa.access_token
}
