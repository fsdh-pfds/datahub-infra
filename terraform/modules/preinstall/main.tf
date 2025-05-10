resource "azurerm_role_assignment" "kv_role_creator" {
  for_each = toset(["Key Vault Crypto User", "Key Vault Certificate User", "Key Vault Secrets User", "Contributor", "Owner"])

  scope                = var.key_vault_id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = each.key
}

resource "null_resource" "rg_tag_git_version" {
  provisioner "local-exec" {
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOF
      az tag update --resource-id ${data.azurerm_resource_group.datahub_rg.id} --operation merge --tags "git_version_url=${var.git_version_url}" "git_branch_name=${var.git_branch_name}"

    EOF
    on_failure  = continue
  }

  triggers = { always_run = "${timestamp()}" }
}
