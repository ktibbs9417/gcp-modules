#!/bin/bash

# NOTES: 
#    After the svc account is created, it's address will need to be added to the within TF .tfvars (line 6)

# Variables
ORGANIZATION_ID=" " # Your GCP Organization ID 
PROJECT_ID=" " # Project to create
SERVICE_ACCOUNT_NAME="terraform-service-account"
SERVICE_ACCOUNT_DISPLAY_NAME="Terraform Service Account"
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
KEY_FILE_PATH="auto-keyfile.json"
IAM_ROLES=(
  "roles/resourcemanager.projectCreator"
  "roles/billing.user"
)
PRJ_APIS=(
  "cloudbilling.googleapis.com"
  "cloudresourcemanager.googleapis.com"
  "iam.googleapis.com"
)

# Create tf executor project
echo "Creating project"
gcloud projects create "${PROJECT_ID}" \
  --folder 323038757240 \
  --name "Terraform Runner Project" \
  --labels=type=demo

# Enable Required APIs
echo "Enabling APIs"
for api in "${PRJ_APIS[@]}"; do
gcloud services enable "${api}" \
  --project "${PROJECT_ID}"
done

# Create service account
echo "Creating service account..."
gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}" \
  --display-name "${SERVICE_ACCOUNT_DISPLAY_NAME}" \
  --project "${PROJECT_ID}"

# Assign IAM roles to the project if needed

# Assign IAM roles to organization
echo "Assigning IAM roles to organiztion..."
for role in "${IAM_ROLES[@]}"; do
gcloud organizations add-iam-policy-binding "${ORGANIZATION_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role "${role}"
done

# Create and download key file
echo "Creating and downloading key file..."
gcloud iam service-accounts keys create "${KEY_FILE_PATH}" \
  --iam-account "${SERVICE_ACCOUNT_EMAIL}" \
  --project "${PROJECT_ID}"

# Display information
echo "Service account created:"
echo "  Email: ${SERVICE_ACCOUNT_EMAIL}"
echo "  Key file: ${KEY_FILE_PATH}"
echo "Make sure to set the following environment variables before using Terraform:"
echo "export GOOGLE_APPLICATION_CREDENTIALS=${KEY_FILE_PATH}"