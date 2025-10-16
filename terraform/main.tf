module "rg" {
    source          = "../../module/azure/resource_group"
    resource_group  = var.resource_group
    tags            = var.tags
}

module "vnet" {
    source              = "../../module/azure/resource_group"
    location            = module.rg.rg_location[0]
    resource_group_name = module.rg.rg_name[0]
    virtual_network     = var.virtual_network
    tags                = var.tags
}

module "lb" {
    source              = "../../module/azure/resource_group"
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
    source              = "../../module/azure/resource_group"
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