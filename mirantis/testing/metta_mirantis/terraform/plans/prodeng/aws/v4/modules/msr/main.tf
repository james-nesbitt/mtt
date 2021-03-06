resource "aws_security_group" "msr" {
  name        = "${var.cluster_name}-msrs"
  description = "mke cluster msrs"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  subnet_count = length(var.subnet_ids)
}


resource "aws_instance" "msr" {
  count = var.msr_count

  tags = {
    "Name"                 = "${var.cluster_name}-msr-${count.index + 1}"
    "Role"                 = "msr"
    (var.kube_cluster_tag) = "shared"
    "project"              = var.project
    "platform"             = var.platform
    "expire"               = var.expire
  }

  instance_type          = var.msr_type
  iam_instance_profile   = var.instance_profile_name
  ami                    = var.image_id
  key_name               = var.ssh_key
  vpc_security_group_ids = [var.security_group_id, aws_security_group.msr.id]
  subnet_id              = var.subnet_ids[count.index % local.subnet_count]
  ebs_optimized          = true
  user_data              = <<EOF
#!/bin/bash
# Use full qualified private DNS name for the host name.  Kube wants it this way.
HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/hostname)
echo $HOSTNAME > /etc/hostname
grep -q $HOSTNAME /etc/hosts || sed -ie "s|\(^127\.0\..\.. .*$\)|\1 $HOSTNAME|" /etc/hosts
hostname $HOSTNAME
EOF

  lifecycle {
    ignore_changes = [ami]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = var.msr_volume_size
  }
}
