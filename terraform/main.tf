resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Public Subnet
resource "azurerm_subnet" "public" {
  name                 = var.public_subnet
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
}

# Private Subnet
resource "azurerm_subnet" "private" {
  name                 = var.private_subnet
  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
}


resource "azurerm_container_registry" "acr" {
  name                = var.acr_name # Must be globally unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic" # You can also use "Standard" or "Premium"
  admin_enabled       = true    # Enables username/password login
}


resource "azurerm_service_plan" "plan" {
  name                = var.appservice_plan
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = true
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    DOCKER_REGISTRY_SERVER_URL          = "https://shobiacr.azurecr.io"
    DOCKER_CUSTOM_IMAGE_NAME            = "shobiacr.azurecr.io/dotnetdiscount:latest"
    DOCKER_REGISTRY_SERVER_USERNAME     = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD     = azurerm_container_registry.acr.admin_password
  }
}
#database
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.postgres
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.location2
  administrator_login    = "pgadmin"
  administrator_password = var.db_password
  version                = "13"
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
   zone                = "3" 
  #   high_availability {
  #   mode                       = "ZoneRedundant"
  #   standby_availability_zone = "Not enabled"  # <-- match Azure exactly
  # }


}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "AllowAll"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

#network security group

resource "azurerm_network_security_group" "web_nsg" {
  name                = "r-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

#gateways

resource "azurerm_public_ip" "lb_ip" {
  name                = "demo-lb-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb" {
  name                = "demo-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicFrontend"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}