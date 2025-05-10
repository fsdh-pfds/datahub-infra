# Destroy Terraform managed resources

Using DEV environment to illustrate.

- Run `setup/az-login.ps1 dev`
- Go to environment directory: `cd env/dev`
- Run pre-detroy command: `..\..\scripts\predestroy.ps1 dev`
- Destroy: `terraform destroy`
- Repeat the above Destroy step a few times. You also need to manually delete the Key Vault keys manually when Terraform is failing to delete keys
