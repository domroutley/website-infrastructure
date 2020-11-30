resource "azurerm_cdn_profile" "web_cdn_profile" {
  name                = "website-cdn"
  location            = var.cdn_location
  resource_group_name = azurerm_resource_group.web_rg.name
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "web_cdn_endpoint" {
  name                = var.endpoint
  profile_name        = azurerm_cdn_profile.web_cdn_profile.name
  location            = var.cdn_location
  resource_group_name = azurerm_resource_group.web_rg.name

  global_delivery_rule {
    cache_expiration_action {
      behavior = "Override"
      duration = "00:00:10"
    }
  }

  origin_host_header = azurerm_storage_account.web_sa.primary_web_host
  origin {
    name      = "web-origin"
    host_name = azurerm_storage_account.web_sa.primary_web_host
  }
}