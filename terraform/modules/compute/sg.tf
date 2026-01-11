# Security Groups
resource "aws_security_group" "web" {
        name = local.public_sg_name
        vpc_id = var.vpc_id

        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = [var.vpc_cidr]
        }

        ingress {
                from_port = 9100
                to_port = 9100
                protocol = "tcp"
                cidr_blocks = ["10.0.0.136/32"]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }

        tags = var.common_tags
}

resource "aws_security_group" "private" {
        name = local.private_sg_name
        vpc_id = var.vpc_id

        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = [var.vpc_cidr]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }

        tags = var.common_tags
}
