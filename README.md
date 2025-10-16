# Terraform Pipeline Template
![Precheck Pipeline](https://img.shields.io/badge/workflow-terraform--pipeline-blue)
![Terraform Pipeline](https://img.shields.io/badge/workflow-terraform--pipeline-blue)

| Project | Environment | Pipeline Name | Author |
| :----: | :----: | :----: | :----:|
| CI-CD Template | DEV/TEST/PROD | Azure Resource Deployment |  **Anand Babu P**<br>Senior Technical Leader \| [anbu143dude@gmail.com](mailto:anbu143dude@gmail.com)|

## Overview

This GitHub Actions workflow is a reusable Terraform pipeline template designed to:
	•	Validate and create required Azure resources (Resource Group, Storage Account, Blob Container) if they do not exist.
	•	Initialize, validate, plan, and apply Terraform configurations.
	•	Work with private GitHub repositories for Terraform modules.

It can be called from other workflows using workflow_call.

## Workflow Name
precheck-pipeline-template
terraform-pipeline-template

## Trigger

This workflow is triggered using workflow_call, allowing other workflows to call it as a template.


## Inputs

Input | Required | Type | Default | Description
------|-----------|-------|---------|-------------
environment	| Yes	| string	| -	| Target environment (e.g., dev, qa, prod).
runner  | Yes | string | ubuntu-latest | Target runner nam
tf_version	| Yes	| string	| -	| Terraform version to use.
tf_init	| Yes	| boolean	| true | Whether to run terraform init.
tf_plan	| Yes	| boolean	| false	| Whether to run terraform plan.
tf_apply	| No	| boolean	| false	| Whether to run terraform apply.
tf_varsfile	| Yes	| string	| -	| Path to Terraform variables file.
backend_config	| Yes	| string	| -	| Path to Terraform backend config file.
Org	| Yes	| string	| -	| GitHub organization name for repository.
repo	| Yes	| string	| -	| Repository name containing Terraform code.

## Secrets
The following secrets must be provided when calling this workflow:

Secret | Required	| Description
-------|----------|------------
ARM_CLIENT_ID	| Yes	| Azure Service Principal client ID.
ARM_CLIENT_SECRET	| Yes	| Azure Service Principal client secret.
ARM_SUBSCRIPTION_ID	| Yes	| Azure subscription ID.
ARM_TENANT_ID	| Yes	| Azure tenant ID.
MODULE_TOKEN	| Yes | GitHub Personal Access Token for private module template repo
DEPLOY_TOKEN  | Yes | GitHUb Personal Access Token for private deployment repo

## Jobs
1. Precheck
	-	Checks out the Terraform repository.
	-	Logs in to Azure using provided Service Principal credentials.
	-	Validates existence of Resource Group, Storage Account, and Blob Container. Creates them if not found.

2. Terraform Deployment
	-	Checks out the Terraform repository again.
	-	Configures Git to access private modules.
	-	Sets up the specified Terraform version.
	-	Runs Terraform commands based on input flags:
	-	terraform init
	-	terraform validate
	-	terraform plan
	-	terraform apply

## Example Usage

```yaml
name: deployment-pipeline-template
on:
  push:
    branches: [ main ]

jobs:
  precheck:
    uses: ab-all-hub/ci-cd-templates/.github/workflows/precheck-pipeline-template.yml@main
    permissions:
      id-token: write
      contents: read
    secrets:
      ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
      ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
      ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
      ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
      DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
    with:
      environment: "dev"
      runner: "ubuntu-latest"
      tf_varsfile: "input.tfvars.json"
      backend_config: "backend-config.tfvars.json"
      Org: "anbu143dude"
      repo: "deployment-template"

  terraform:
    needs: [precheck]
    uses: ab-all-hub/ci-cd-templates/.github/workflows/terrafrom-pipeline-template.yml@main
    permissions:
      id-token: write
      contents: read
    secrets:
      ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
      ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
      ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
      ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
      MODULE_TOKEN: ${{ secrets.MODULE_TOKEN }}
      DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
    with:
      environment: "dev"
      runner: "ubuntu-latest"
      tf_version: "1.8.5"
      tf_init: true
      tf_plan: true
      tf_apply: false
      tf_varsfile: "input.tfvars.json"
      backend_config: "backend-config.tfvars.json"
      Org: "anbu143dude"
      repo: "deployment-template"
```

## Repository Structure
```bash
.
├── .github/
│   ├── workflows/
│   │   ├── precheck-pipeline-template.yml      # GitHub Actions workflow template
│   │   └── terraform-pipeline-template.yml     # GitHub Actions workflow template
├── terraform/
│   ├── main.tf                          # Reusable terraform module configuration
│   ├── variables.tf                     # Input variables definitions
│   └── providers.tf                     # Provider and authentication setup
```

**Notes:**
  - Ensure the backend configuration file and variables file paths are correct relative to the Terraform directory.
  -	This workflow supports both public and private repositories for Terraform modules.
  -	Conditional execution of Terraform commands allows flexible CI/CD pipelines.

## Contact
For any questions or feedback, reach out to:
Anand Babu P Email: anbu143dude@gmail.com