# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name = var.resource_group
  location = var.location
}

resource "azurerm_mariadb_server" "example" {
  name = var.server_name
  location = var.location
  resource_group_name = azurerm_resource_group.example.name

  sku_name = "B_Gen5_2"

  storage_mb = 51200
  backup_retention_days = 7
  geo_redundant_backup_enabled = false

  administrator_login = var.username
  administrator_login_password = var.password
  version = "10.2"
  ssl_enforcement_enabled = true
}

resource "azurerm_mariadb_database" "example" {
  name = var.db_name
  resource_group_name = azurerm_resource_group.example.name
  server_name = azurerm_mariadb_server.example.name
  charset = "utf8"
  collation = "utf8_general_ci"
}

variable "server_name" {
  type = string
  description = "mariadb server name"
  default = "mariadb-svr-sample"
}

variable "db_name" {
  default = "backend"
  type = string
  description = "Database instance name"
}

variable "username" {
  default = "acctestun"
  type = string
  description = "Database instance username"
}

variable "password" {
  default = "H@Sh1CoR3!faked"
  type = string
  description = "Database instance password"
}

variable "location" {
  description = "Azure location"
  type = string
  default = "West Europe"
}

variable "resource_group" {
  description = "Resource group"
  type = string
  default = "kubevela-group"
}

output "SERVER_NAME" {
  value = var.server_name
}

output "DB_NAME" {
  value = var.db_name
}
output "DB_USER" {
  value = var.username
}
output "DB_PASSWORD" {
  sensitive = true
  value = var.password
}
output "DB_PORT" {
  value = 3306
}
output "DB_HOST" {
  value = azurerm_mariadb_server.example.fqdn
}
