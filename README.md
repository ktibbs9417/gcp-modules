# GCP Project Module

This terraform module and code repository is intended to be used to deploy various types of GCP Projects.

The three types of projects deployed using this module are: VPC Host Projects, Service Projects, and GCP Projects (with self-contained, or no, VPCs).

Following the sequential build system that these modules are intended for, a VPC Host project needs to be created so that a Shared VPC (SVPC) can be created. Once the SVPC is created, then a Service Project can be created and attached to the SVPC accordingly. GCP Projects, without reliance on, or an intention of creating a SPVC, can be created at any time.

## Required Permissions

The following permissions are required to be given to the service account, or user, being used to deploy this module for the following types of deployment.

### Creating a project without an attached SVPC

The following permissions are required at the folder, or the organization level, depending on the parent of the project:

```
resourcemanager.organizations.get
resourcemanager.projects.create
orgpolicy.constraints.list
orgpolicy.policies.list
orgpolicy.policy.get
resourcemanager.folders.get
resourcemanager.folders.list
resourcemanager.projects.get
resourcemanager.projects.list
```

Alternatively, these permissions are contained within the predefined roles: Folder Viewer(`roles/resourcemanager.folderViewer`) and Project Creator(`roles/resourcemanager.projectCreator`).

### Creating a project with an SVPC attachment

In addition to the permissions above, the service account, or user, will need the following permissions on the network, or the project hosting the network, in order to attach the project to the SVPC. These permissions are contained in the predefined role Network User(`roles/compute.networkUser`).

The permissions for Network User are extensive and can be found [here](https://cloud.google.com/compute/docs/access/iam#compute.networkUser)

### Creating a Project that will Host an SVPC

The service account, or user, deploying the code will need to have the permissions-equivalent of Project Creator(`roles/resourcemanager.projectCreator`) and the Network Admin(`roles/compute.networkAdmin`) predefined roles in order to maintain and manage the host-VPC. In addition to the Project Creator role.

The Network Admin specific permissions are extensive and can be found [here](https://cloud.google.com/compute/docs/access/iam#compute.networkAdmin). 


## Example GCP Project Deployment

This repository, like the other modules in the GCP Toolkit set of modules, is intended to be deployed via variable values declared in a `.tfvars` file in an environment folder. The below example represents a block of code for deploying a non-SVPC attached VPC with Compute, OsLogin, and Container APIs included to be activated when the project is deployed.

``` tf
projects = {
  iap-project-template-v1 = {
    uses_vpc_host_project    = false
    is_vpc_host_project      = false
    default_srv_accnt_action = "DEPRIVILEGE" # Creates the Default API SVC Account but removes IAM Roles
    create_project_srv_accnt = true
    org_id                   = ""
    folder_id                = ""
    skip_delete              = false
    auto_create_network      = false
    activate_additional_apis = [
      "compute.googleapis.com"
    ]
    labels = {
      managed_by = "terraform"
      env        = "back-to-demo"
    }

    per_project_iam_roles = {
      "roles/compute.instanceAdmin.v1" = {
        members = ["user:ktibbs9413@gmail.com"]
      },
      "roles/compute.admin" = {
        members = ["serviceAccount:terraform-service-account@project_id.iam.gserviceaccount.com"]
      },
      "roles/iap.admin" = {
        members = ["serviceAccount:terraform-service-account@project_id.iam.gserviceaccount.com"]
      },
      "roles/storage.admin" = {
        members = ["serviceAccount:terraform-service-account@project_id.iam.gserviceaccount.com"]
      }
    }
  },
}

service_account = {
  "service_accounts" = {
    project_id = "iap-project-template-v1"
    service_account = {
      "gce-svc-acc" = {
        display_name = "GCE Service Account"
        members      = ["user:user@gmail.com"]
        role         = "roles/iam.serviceAccountUser"
      }
    }
  }
}

custom_vpc = {
  "iap-demo" = {
    project_id              = "iap-project-template-v1"
    auto_create_subnetworks = false
    subnets = {
      "iap-west" = {
        ip_cidr_range = "10.1.0.0/16"
        subnet_region = "us-west4"
      },
      "iap-centrl" = {
        ip_cidr_range = "10.2.0.0/16"
        subnet_region = "us-central1"
      },
    }
  }
}

firewall_rules = {
  "iap-demo-firewall" = {
    project_id = "iap-project-template-v1"
    firewall_rule = {
      "fw-999-allow-iap-tcp-forwarding" = {
        vpc_name = "iap-demo"
        allow = [{
          ports    = ["22"]
          protocol = "tcp"
        }]
        description = "Allows Google's IP to forward SSH traffic over HTTPS"
        direction   = "INGRESS"
        priority    = 999
        ranges      = ["35.235.240.0/20"]
      },
    }
  }
}

gce_instance = {
  "iap-demo" = {
    project_id                = "iap-project-template-v1"
    hostname                  = "iap-demo"
    region                    = "us-west4"
    zone                      = "us-west4-a"
    machine_type              = "e2-micro"
    gce_image                 = "debian-cloud/debian-10"
    gce_service_account_email = "gce-svc-acc@iap-project-template-v1.iam.gserviceaccount.com"
    tags                      = ["demo"]
    labels = {
      env = "demo"
    }
    network_interface = {
      "network" = {
        subnet_name = "iap-west"
      }
    }
  }
}

iap-iam = {
  "iap-tunnel-instance" = {
    instance   = "iap-demo"
    zone       = "us-west4-a"
    project_id = "iap-project-template-v1"
    role       = "roles/iap.tunnelResourceAccessor"
    members    = ["user:user@gmail.com"]
  }
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >=4.41.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp-projects"></a> [gcp-projects](#module\_gcp-projects) | ./modules/gcp-project | n/a |
| <a name="module_service-projects"></a> [service-projects](#module\_service-projects) | ./modules/gcp-project | n/a |
| <a name="module_vpc-host-projects"></a> [vpc-host-projects](#module\_vpc-host-projects) | ./modules/gcp-project | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_iam_roles"></a> [iam\_roles](#input\_iam\_roles) | n/a | <pre>map(object({<br>	    role    = string<br>	    members = list(string)<br>      }))</pre> | `{}` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | terraform project. | `any` | n/a | yes |
| <a name="input_projects"></a> [projects](#input\_projects) | List of project objects. | <pre>map(object({<br>	uses_vpc_host_project        = bool	<br>    host_project_name            = string<br>	is_vpc_host_project          = bool<br>	default_srv_accnt_action     = string<br>	create_project_srv_accnt     = bool<br>	#either org_id or folder_id<br>	org_id                       = string<br>	folder_id                    = string<br>	billing_account              = string<br>	skip_delete                  = bool<br>	auto_create_network          = bool<br>	activate_apis                = list(string)<br>    labels                       = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_service_projects"></a> [service\_projects](#input\_service\_projects) | List of service project objects. these must be created after vpc host projects | `map(any)` | `{}` | no |
| <a name="input_vpc_host_projects"></a> [vpc\_host\_projects](#input\_vpc\_host\_projects) | List of vpc host project objects. these must be created first | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gcp-projects_outputs"></a> [gcp-projects\_outputs](#output\_gcp-projects\_outputs) | n/a |
| <a name="output_service-projects_outputs"></a> [service-projects\_outputs](#output\_service-projects\_outputs) | n/a |
| <a name="output_vpc-host-projects_outputs"></a> [vpc-host-projects\_outputs](#output\_vpc-host-projects\_outputs) | n/a |
<!-- END_TF_DOCS -->