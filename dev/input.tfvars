rg_name             = "rg-tst"
rg_location         = "eastus2"
virtual_network = [
    {
        name                = "vn-tst-01"
        vnet_address_space  = ["10.0.0.0/16"]
        snet_name           = "sn-tst-01"
        snet_address_prefix = "10.0.1.0/24"
    }
]
lb_name             = "lb-tst-01"
lb_frontend_ip_name = "feip"
lb_probe1_port      = "80"
virtual_machine = [
    {
        name            = "vm1"
        os_type         = "windows"
        size            = "standard_d4s_v2"
        admin_username  = "adminuser"
        admin_password  = "admin@123456#"
        os_image        = "WindowsServer"
        lb_enable       = "true"
    },
    {
        name            = "vm2"
        os_type         = "windows"
        size            = "standard_d4s_v2"
        admin_username  = "adminuser"
        admin_password  = "admin@123456#"
        os_image        = "WindowsServer"
        lb_enable       = "true"
    },
    {
        name            = "vm3"
        os_type         = "windows"
        size            = "standard_d4s_v2"
        admin_username  = "adminuser"
        admin_password  = "admin@123456#"
        os_image        = "WindowsServer"
        lb_enable       = "false"
    }
]