locals {
	vpc_name = "${var.project}-vpc"
	public_subnet_name = "${var.project}-public-subnet"
	private_subnet_name = "${var.project}-private-subnet"
	igw_name = "${var.project}-igw"
	nat_eip_name = "${var.project}-nat-eip"
	nat_gw_name = "${var.project}-ngw"
	public_rt_name = "${var.project}-public-route"
	private_rt_name = "${var.project}-private-route"
}
