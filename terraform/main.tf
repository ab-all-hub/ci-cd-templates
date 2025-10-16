module "rg" {
    source          = "git::https://github.com/ab-all-hub/terraform-modules.git//azure/resource_group?ref=main"
    resource_group  = var.resource_group
    tags            = var.tags
}

module "vnet" {
    source              = "git::https://github.com/ab-all-hub/terraform-modules.git//azure/virtual_network?ref=main"
    location            = module.rg.rg_location[0]
    resource_group_name = module.rg.rg_name[0]
    virtual_network     = var.virtual_network
    tags            = var.tags
}

module "lb" {
    source              = "git::https://github.com/ab-all-hub/terraform-modules.git//azure/load_balancer_private?ref=main"
    location            = module.rg.rg_location[0]
    resource_group_name = module.rg.rg_name[0]
    name                = var.lb_name
    frontend_ip_name    = var.lb_frontend_ip_name
    subnet_id           = module.vnet.snet_id[0]
    probe1_port         = var.lb_probe1_port
    tags                = var.tags
    depends_on = [
        module.rg,
        module.vnet
    ]
}

module "vm" {
    source              = "git::https://github.com/ab-all-hub/terraform-modules.git//azure/virtual_machine?ref=main"
    location            = module.rg.rg_location[0]
    resource_group_name = module.rg.rg_name[0]
    subnet_id           = module.vnet.snet_id[0]
    virtual_machine     = var.virtual_machine
    lb_bkap_id          = module.lb.lb_bkap_id
    tags                = var.tags
    depends_on = [
        module.rg,
        module.vnet,
        module.lb
    ]
}