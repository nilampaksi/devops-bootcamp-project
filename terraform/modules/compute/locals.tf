locals {
	ssm_role_name = "${var.project}-ec2-ssm-role"
	ssm_profile = "${var.project}-ec2-ssm-profile"
	public_sg_name = "${var.project}-public-sg"
	private_sg_name = "${var.project}-private-sg"
}
