terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "finops-practice"
  region  = "us-central1"
}

resource "google_bigquery_dataset" "billing_data" {
  dataset_id                  = "billing_data"
  location                    = "US"
  description                 = "Synthetic billing data for FinOps practice"
  delete_contents_on_destroy  = true
}
