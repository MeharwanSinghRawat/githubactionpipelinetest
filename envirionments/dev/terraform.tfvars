resource_group = {
  rg1 = {
    rg_name  = "Todo_Infra_rg"
    location = "Central India"
    # managed_by = "azurerm_user_assigned_identity.test"  # optional
    # tags = {
    #   environment = "dev"
    #   project     = "terraform-setup"
    #   costcenter  = "CC-1001"
    # }
  }
}

virtual_network = {
  vnet1 = {
    vnet_name               = "todovnet"
    rg_name                 = "Todo_Infra_rg"
    location                = "Central India"
    address_space           = ["10.0.0.0/16"]
    dns_servers             = ["8.8.8.8", "8.8.4.4"]
    flow_timeout_in_minutes = 10
    # tags = {
    #   environment = "dev"
    #   project     = "terraform-network"
    #   owner       = "mehar"
    # }
  }
}

subnet = {
  subnet1 = {
    subnet_name      = "mehar_frontend_subnet"
    vnet_name        = "todovnet"
    rg_name          = "Todo_Infra_rg"
    address_prefixes = ["10.0.0.0/24"]
    # service_endpoints = ["Microsoft.Storage"]
    # delegation = [
    #   {
    #     name = "delegation1"
    #     service_delegation = {
    #       name    = "Microsoft.Web/serverFarms"
    #       actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    #     }
    #   }
    # ]
  }

    subnet2 = {
      subnet_name      = "mehar_backend_subnet"
      vnet_name        = "todovnet"
      rg_name          = "Todo_Infra_rg"
      address_prefixes = ["10.0.1.0/24"]
    private_endpoint_network_policies     = "Disabled"
    private_link_service_network_policies = "Enabled"    
    delegation = [
      {
        name = "delegation1"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    ]
  }
}

public_ip = {
  frontpip = {
    pip_name          = "frontend_mehapip2"
    rg_name           = "Todo_Infra_rg"
    location          = "Central India"
    allocation_method = "Static"
    sku               = "Standard"
    # idle_timeout_in_minutes = 10
    # domain_name_label = "mehar-lb"
    # zones             = ["1", "2", "3"]
    # tags = {
    #   environment = "dev"
    #   project     = "loadbalancer"
    # }
  }

  backendip= {
    pip_name          = "backend_mehapip1" 
    rg_name           = "Todo_Infra_rg"
    location          = "Central India"
    allocation_method = "Static"
    sku               = "Standard"
    # domain_name_label = "mehar-bastion"
  }

   anisble = {
    pip_name          = "ansible_mehapip1" 
    rg_name           = "Todo_Infra_rg"
    location          = "Central India"
    allocation_method = "Static"
    sku               = "Standard"
    # domain_name_label = "mehar-bastion"
  }

}

network_nic = {
  nic1 = {
    nic_name        = "frontend_meharnic1"
    location        = "Central India"
    rg_name         = "Todo_Infra_rg"
    ip_config_name  = "internal"
    private_ip_meth = "Dynamic"
    subnet_name     = "mehar_frontend_subnet"
    vnet_name       = "todovnet"
    pip_name        = "frontend_mehapip2"
    # enable_accelerated_networking = true
    # tags = {
    #   environment = "dev"
    #   owner       = "mehar"
    # }
  }

  nic2 = {
    nic_name        = "backend_meharnic2"
    location        = "Central India"
    rg_name         = "Todo_Infra_rg"
    ip_config_name  = "internal"
    private_ip_meth = "Dynamic"
    subnet_name     = "mehar_backend_subnet"
    vnet_name       = "todovnet"
    pip_name          = "backend_mehapip1" 
    # enable_ip_forwarding = true
  }

   nic3 = {
    nic_name        = "ansible_meharnic2"
    location        = "Central India"
    rg_name         = "Todo_Infra_rg"
    ip_config_name  = "internal"
    private_ip_meth = "Dynamic"
    subnet_name     = "mehar_backend_subnet"
    vnet_name       = "todovnet"
    pip_name          = "ansible_mehapip1"  
    # enable_ip_forwarding = true
  }

}


virtual_machine = {
  vm1 = {
    vm_name        = "lbvm1"
    rg_name        = "Todo_Infra_rg"
    location       = "Central India"
    vm_size        = "Standard_D2s_v6"
    admin_username = "Useradmin"
    admin_password = "Useradmin@1234"
    nic_name       = "frontend_meharnic1"
  }

  vm2 = {
    vm_name        = "lbvm2"
    rg_name        = "Todo_Infra_rg"
    location       = "Central India"
    vm_size        = "Standard_D2s_v6"
    admin_username = "Useradmin"
    admin_password = "Useradmin@1234"
    nic_name       = "backend_meharnic2"
  }
    vm3 = {
    vm_name        = "ansible"
    rg_name        = "Todo_Infra_rg"
    location       = "Central India"
    vm_size        = "Standard_D2s_v6"
    admin_username = "Useradmin"
    admin_password = "Useradmin@1234"
    nic_name       = "ansible_meharnic2"
  }
}

network_nsg = {
  nsg1 = {
    nsg_name = "backend-nsg"
    location = "Central India"
    rg_name  = "Todo_Infra_rg"
    rules = [
      {
        rule_name                  = "allow-ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        rule_name                  = "allow-http"
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  nsg2 = {
    nsg_name = "frontend_nsg"
    location = "eastus"
    rg_name  = "Todo_Infra_rg"
    rules = [
      {
        rule_name                  = "allow-sql"
        priority                   = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
      }
    ]
  }
}






