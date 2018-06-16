resource "azurerm_virtual_machine_extension" "deploy" {
  name                 = "hostname"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  depends_on           = ["azurerm_virtual_machine.bastion", "azurerm_lb_rule.cf-balancer-rule-http", "azurerm_lb_rule.cf-balancer-rule-https"]
  virtual_machine_name = "${azurerm_virtual_machine.bastion.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/scripts/utils.sh",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/bosh.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/cpi.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/custom-cpi-release.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/custom-environment.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/use-service-principal-with-certificate.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/use-azure-dns.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/jumpbox-user.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/keep-failed-or-unreachable-vms.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/cloud-config.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/cf-deployment.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/azure.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/scale-to-one-az.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/use-compiled-releases.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/use-managed-disks.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/use-azure-storage-blobstore.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/aci.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/no-aci.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/manifests/debug.yml",
                    "https://raw.githubusercontent.com/virtualcloudfoundry/cf-azure-deployment/temp_test_cpi/cf/scripts/setup_env.sh",
                    "https://s3-us-west-1.amazonaws.com/cf-cli-releases/releases/v6.34.1/cf-cli-installer_6.34.1_x86-64.deb"]
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "commandToExecute": "bash -l -c \"./setup_env.sh ${var.tenant_id} ${var.client_id} ${base64encode(var.client_secret)} 2>&1 | tee /home/${var.ssh_user_username}/install.log\""
  }
PROTECTED_SETTINGS

  tags {
    environment = "${var.prefix}-bosh"
  }
}

# output "kubo_subnet" {
#   value = "${azurerm_subnet.bosh-subnet.name}"
# }

