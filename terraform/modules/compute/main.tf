resource "tls_private_key" "ansible" {
  algorithm = "ED25519"
}

# EC2 Dynamic and Named
resource "aws_instance" "vm" {
  for_each = var.instances

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = each.value.subnet_type == "public" ? var.public_subnet_id : var.private_subnet_id
  vpc_security_group_ids = each.value.subnet_type == "public" ? [aws_security_group.web.id] : [aws_security_group.private.id]
  user_data = each.value.role == "controller" ? templatefile("${path.module}/user_data/controller.sh", { TOKEN = "", ANSIBLE_PRIVATE_KEY = tls_private_key.ansible.private_key_openssh }) : templatefile("${path.module}/user_data/common.sh", { ANSIBLE_PUBLIC_KEY = tls_private_key.ansible.public_key_openssh, SSH_DIR = "/home/ubuntu/.ssh", USER = "ubuntu" })
  private_ip = each.value.private_ip
  
  iam_instance_profile = aws_iam_instance_profile.ssm.name

  tags = merge(var.common_tags, { Name = each.value.name })
}

