provider "aws" {
	region = var.region
}

module "network" {
	source = "./modules/network"

	project = var.project
	prefix = local.prefix
	common_tags = local.common_tags
}

module "compute" {
	source = "./modules/compute"

	project	= var.project
	prefix = local.prefix
	common_tags = local.common_tags
	vpc_id = module.network.vpc_id
	vpc_cidr = module.network.vpc_cidr
	public_subnet_id = module.network.public_subnet_id
	private_subnet_id = module.network.private_subnet_id

	instances = var.instances
	ami = var.ami
	instance_type = var.instance_type
}
