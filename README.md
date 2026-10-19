# azure-iac-practice

Infrastructure as Code practice: provisions an Azure resource group and a storage
account with Terraform, validated by a GitHub Actions pipeline that authenticates
to Azure with OIDC (no stored credentials).

## What it does

- `terraform fmt`, `validate` and `plan` run on every push and pull request.
- The pipeline signs in to Azure with a short-lived OIDC token instead of a secret.
- Resources: one resource group and one storage account (LRS, TLS 1.2, no public blobs).

## Structure

```
main.tf        resources and providers
variables.tf   inputs with validation
outputs.tf     resource group and storage account names
.github/workflows/ci.yml   CI pipeline
docs/OIDC_SETUP.md         how to connect GitHub and Azure
```

## Run locally

```bash
az login
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
terraform init
terraform plan
terraform apply
terraform destroy   # always clean up after practicing
```

Override variables with `-var`, for example `terraform apply -var="environment=test"`.

## CI/CD

See [docs/OIDC_SETUP.md](docs/OIDC_SETUP.md) to configure the federated credential and
the repository variables `AZURE_CLIENT_ID`, `AZURE_TENANT_ID` and `AZURE_SUBSCRIPTION_ID`.
Until they are set, only the format and validate job runs.

## Possible improvements

- Remote state in an Azure Storage backend with state locking.
- Manual-approval `apply` job using a GitHub Environment.
- Docker image build step.
- Policy checks (tflint, checkov).
