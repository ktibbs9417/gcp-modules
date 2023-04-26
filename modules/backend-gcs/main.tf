terraform {
  required_version = ">= 1.3.0"
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}


# Create gcs for state file
resource "google_storage_bucket" "tf_state" {
  name                        = "${random_id.bucket_prefix}-tf-state"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = false
  storage_class               = "STANDARD"
  versioning {
    enabled = true
  }
}