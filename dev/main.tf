module "rg" {
    source      = "git::https://github.com/owner/terraform-modules.git//azure/resource_group?ref=main"
    name        = var.rg_name
    location    = var.rg_location
}

module "vnet" {
    source              = "git::https://github.com/owner/terraform-modules.git//azure/virtual_network?ref=main"
    location            = module.rg.rg_location
    resource_group_name = module.rg.rg_name
    virtual_network     = var.virtual_network
}

module "lb" {
    source              = "git::https://github.com/owner/terraform-modules.git//azure/load_balancer_private?ref=main"
    location            = module.rg.rg_location
    resource_group_name = module.rg.rg_name
    name                = var.lb_name
    frontend_ip_name    = var.lb_frontend_ip_name
    subnet_id           = module.vnet.snet_id[0]
    probe1_port         = var.lb_probe1_port
    depends_on = [
        module.rg,
        module.vnet
    ]
}

module "vm" {
    source              = "git::https://github.com/owner/terraform-modules.git//azure/virtual_machine?ref=main"
    location            = module.rg.rg_location
    resource_group_name = module.rg.rg_name
    subnet_id           = module.vnet.snet_id[0]
    virtual_machine     = var.virtual_machine
    lb_bkap_id          = module.lb.lb_bkap_id
    depends_on = [
        module.rg,
        module.vnet,
        module.lb
    ]
}