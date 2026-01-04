# IAM (SSM)
resource "aws_iam_role" "ssm" {
	name = local.ssm_role_name

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [{
			Effect = "Allow"
			Principal = { Service = "ec2.amazonaws.com" }
			Action = "sts:AssumeRole"
		}]
	})

	tags = var.common_tags	
}

resource "aws_iam_role_policy_attachment" "ssm" {
	role = aws_iam_role.ssm.name
	policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "github_token" {
  name = "github-token-access"
  role = aws_iam_role.ssm.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ssm:GetParameter"]
      Resource = "arn:aws:ssm:*:*:parameter/devops/github/token"
    }]
  })
}

resource "aws_iam_instance_profile" "ssm" {
	name = local.ssm_profile
	role = aws_iam_role.ssm.name
}

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

# EC2 Dynamic and Named

resource "aws_instance" "vm" {
  for_each = var.instances

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = each.value.subnet_type == "public" ? var.public_subnet_id : var.private_subnet_id
  vpc_security_group_ids = each.value.subnet_type == "public" ? [aws_security_group.web.id] : [aws_security_group.private.id]
  user_data = each.value.role == "controller" ? templatefile("${path.module}/user_data/controller.sh", { TOKEN = "" }) : templatefile("${path.module}/user_data/common.sh", {})
  private_ip = each.value.private_ip
  
  iam_instance_profile = aws_iam_instance_profile.ssm.name

  tags = merge(var.common_tags, { Name = each.value.name })
}

