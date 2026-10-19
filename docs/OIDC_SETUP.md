# OIDC setup: GitHub Actions -> Azure (no stored secrets)

Do this only when you open the Azure free account. Replace the placeholders.

## 1. Sign in and pick the subscription

```bash
az login
az account show --query "{sub:id, tenant:tenantId}" -o table
```

## 2. Create the app registration and service principal

```bash
APP_ID=$(az ad app create --display-name "github-oidc-practica" --query appId -o tsv)
az ad sp create --id "$APP_ID"
```

## 3. Give it permissions on the subscription

`Contributor` is enough for this practice. Narrow it to a resource group later.

```bash
SUB_ID=$(az account show --query id -o tsv)
az role assignment create \
  --assignee "$APP_ID" \
  --role Contributor \
  --scope "/subscriptions/$SUB_ID"
```

## 4. Create the federated credential

Replace `OWNER/REPO` with your GitHub user and repository.

```bash
az ad app federated-credential create --id "$APP_ID" --parameters '{
  "name": "github-main",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:OWNER/REPO:ref:refs/heads/main",
  "audiences": ["api://AzureADTokenExchange"]
}'
```

For pull requests add a second credential with subject `repo:OWNER/REPO:pull_request`.

## 5. Save the IDs as GitHub repository variables

Repo -> Settings -> Secrets and variables -> Actions -> Variables:

| Name | Value |
| --- | --- |
| `AZURE_CLIENT_ID` | `$APP_ID` |
| `AZURE_TENANT_ID` | your tenant ID |
| `AZURE_SUBSCRIPTION_ID` | `$SUB_ID` |

These are identifiers, not secrets, so no password or key is stored anywhere.

## 6. Verify

Push to `main`. The `plan` job should authenticate and print a plan.
