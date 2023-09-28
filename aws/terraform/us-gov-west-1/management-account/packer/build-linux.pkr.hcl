build {
  ### Base OS ###
  name = "linux"
  source "source.amazon-ebs.linux" {
    name         = "al2-cis"
    ami_name     = "al2-coalfire-${local.datetime}"
    source_ami   = data.amazon-ami.al2.id
    ssh_username = local.aws_ssh_username
    run_tags = {
      Name      = "al2-coalfire"
      OSType    = "Linux"
      OSFamily  = "al2"
      Release   = local.datetime
      Benchmark = "cis"
    }
    tags = {
      Name      = "al2-coalfire"
      OSType    = "Linux"
      OSFamily  = "al2"
      Release   = local.datetime
      Benchmark = "cis"
    }
  }
  source "source.amazon-ebs.linux" {
    name         = "rhel-cis"
    ami_name     = "rhel8-coalfire-${local.datetime}"
    source_ami   = data.amazon-ami.rhel8.id
    ssh_username = local.aws_ssh_username
    run_tags = {
      Name      = "rhel8-coalfire"
      OSType    = "Linux"
      OSFamily  = "rhel8"
      Release   = local.datetime
      Benchmark = "cis"
    }
    tags = {
      Name      = "rhel8-coalfire"
      OSType    = "Linux"
      OSFamily  = "rhel8"
      Release   = local.datetime
      Benchmark = "cis"
    }
  }
  source "source.amazon-ebs.linux" {
    name         = "rhel-stig"
    ami_name     = "rhel8-coalfire-${local.datetime}"
    source_ami   = data.amazon-ami.rhel8.id
    ssh_username = local.aws_ssh_username
    run_tags = {
      Name      = "rhel8-coalfire"
      OSType    = "Linux"
      OSFamily  = "rhel8"
      Release   = local.datetime
      Benchmark = "stig"
    }
    tags = {
      Name      = "rhel8-coalfire"
      OSType    = "Linux"
      OSFamily  = "rhel8"
      Release   = local.datetime
      Benchmark = "stig"
    }
  }
  source "source.amazon-ebs.linux" {
    name         = "ubuntu2004-cis"
    ami_name     = "ubuntu2004-coalfire-${local.datetime}"
    source_ami   = data.amazon-ami.ubuntu2004.id
    ssh_username = "ubuntu"
    run_tags = {
      Name      = "ubuntu2004-coalfire"
      OSType    = "Linux"
      OSFamily  = "ubuntu2004"
      Release   = local.datetime
      Benchmark = "cis"
    }
    tags = {
      Name      = "ubuntu2004-coalfire"
      OSType    = "Linux"
      OSFamily  = "ubuntu2004"
      Release   = local.datetime
      Benchmark = "cis"
    }
  }
  source "source.amazon-ebs.linux" {
    name         = "ubuntu2004-stig"
    ami_name     = "ubuntu2004-coalfire-${local.datetime}"
    source_ami   = data.amazon-ami.ubuntu2004.id
    ssh_username = "ubuntu"
    run_tags = {
      Name      = "ubuntu2004-coalfire"
      OSType    = "Linux"
      OSFamily  = "ubuntu2004"
      Release   = local.datetime
      Benchmark = "stig"
    }
    tags = {
      Name      = "ubuntu2004-coalfire"
      OSType    = "Linux"
      OSFamily  = "ubuntu2004"
      Release   = local.datetime
      Benchmark = "stig"
    }
  }
  source "source.amazon-ebs.linux" {
    name         = "ubuntu2204-cis"
    ami_name     = "ubuntu2204-coalfire-${local.datetime}"
    source_ami   = data.amazon-ami.ubuntu2204.id
    ssh_username = "ubuntu"
    run_tags = {
      Name      = "ubuntu2204-coalfire"
      OSType    = "Linux"
      OSFamily  = "ubuntu2204"
      Release   = local.datetime
      Benchmark = "cis"
    }
    tags = {
      Name      = "ubuntu2204-coalfire"
      OSType    = "Linux"
      OSFamily  = "ubuntu2204"
      Release   = local.datetime
      Benchmark = "cis"
    }
  }

  ### ECS ###
  source "source.amazon-ebs.linux" {
    name     = "al2-ecs-cis"
    ami_name = "al2-ecs-coalfire-${local.datetime}"
    launch_block_device_mappings {
      delete_on_termination = true
      device_name           = "/dev/sdc"
      volume_size           = 20
      volume_type           = "gp3"
    }
    source_ami   = data.amazon-ami.al2-ecs.id
    ssh_username = local.aws_ssh_username
    run_tags = {
      Name      = "al2-ecs-coalfire"
      OSType    = "Linux"
      OSFamily  = "al2"
      Release   = local.datetime
      Benchmark = "cis"
    }
    tags = {
      Name      = "al2-ecs-coalfire"
      OSType    = "Linux"
      OSFamily  = "al2"
      Release   = local.datetime
      Benchmark = "cis"
    }
  }

  ### EKS ###
  source "source.amazon-ebs.eks" {
    name            = "al2-eks-cis"
    ami_description = "EKS Kubernetes Worker AMI on AmazonLinux2 image (k8s: ${var.eks_major_version})"
    ami_name        = "amazon-eks-node-coalfire-${var.eks_major_version}-al2-${local.datetime}"
    source_ami      = data.amazon-ami.eks-al2.id
    ssh_username    = local.aws_ssh_username
    run_tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_major_version}-al2-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "al2"
      BuildDate = local.datetime
      Benchmark = "cis"
    }
    tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_major_version}-al2-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "al2"
      BuildDate = local.datetime
      Benchmark = "cis"
    }
  }
  source "source.amazon-ebs.eks" {
    name            = "ubuntu1804-eks-cis"
    ami_description = "EKS Kubernetes Worker AMI on Ubuntu 18.04 (k8s: ${var.eks_version})"
    ami_name        = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu1804-${local.datetime}"
    source_ami      = data.amazon-ami.ubuntu1804.id
    ssh_username    = "ubuntu"
    run_tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu1804-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "ubuntu1804"
      BuildDate = local.datetime
      Benchmark = "cis"
    }
    tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu1804-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "ubuntu1804"
      BuildDate = local.datetime
      Benchmark = "cis"
    }
  }
  source "source.amazon-ebs.eks" {
    name            = "ubuntu2004-eks-cis"
    ami_description = "EKS Kubernetes Worker AMI on Ubuntu 20.04 (k8s: ${var.eks_version})"
    ami_name        = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu2004-${local.datetime}"
    source_ami      = data.amazon-ami.ubuntu2004.id
    ssh_username    = "ubuntu"
    run_tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu2004-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "ubuntu2004"
      BuildDate = local.datetime
      Benchmark = "cis"
    }
    tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu2004-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "ubuntu2004"
      BuildDate = local.datetime
      Benchmark = "cis"
    }
  }
  source "source.amazon-ebs.eks" {
    name            = "ubuntu2004-eks-stig"
    ami_description = "EKS Kubernetes Worker AMI on Ubuntu 20.04 (k8s: ${var.eks_version})"
    ami_name        = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu2004-${local.datetime}"
    source_ami      = data.amazon-ami.ubuntu2004.id
    ssh_username    = "ubuntu"
    run_tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu2004-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "ubuntu2004"
      BuildDate = local.datetime
      Benchmark = "stig"
    }
    tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu2004-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "ubuntu2004"
      BuildDate = local.datetime
      Benchmark = "stig"
    }
  }
  source "source.amazon-ebs.linux" {
    name            = "ubuntu2204-eks-cis"
    ami_description = "EKS Kubernetes Worker AMI on Ubuntu 22.04 (k8s: ${var.eks_version})"
    ami_name        = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu2204-${local.datetime}"
    source_ami      = data.amazon-ami.ubuntu2204.id
    ssh_username    = "ubuntu"
    run_tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu2204-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "ubuntu2204"
      BuildDate = local.datetime
      Benchmark = "cis"
    }
    tags = {
      Name      = "amazon-eks-node-coalfire-${var.eks_version}-ubuntu2204-${local.datetime}"
      OSType    = "Linux"
      OSFamily  = "ubuntu2204"
      BuildDate = local.datetime
      Benchmark = "cis"
    }
  }

  ### Make Packer Temp dir ###
  # For distros with ec2-user
  provisioner "shell" {
    only = [
      "amazon-ebs.rhel-cis",
      "amazon-ebs.rhel-stig",
      "amazon-ebs.al2-cis",
      "amazon-ebs.al2-ecs-cis",
      "amazon-ebs.al2-eks-cis"
    ]
    pause_before = "15s"
    inline = [
      "sudo mkdir -p /opt/packer/files",
      "sudo chown -R ${local.aws_ssh_username}:root /opt"
    ]
  }
  # For Ubuntu
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu2004-cis",
      "amazon-ebs.ubuntu2004-stig",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig",
      "amazon-ebs.ubuntu2204-cis",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    inline = [
      "sudo mkdir -p /opt/packer/files",
      "sudo chown -R ubuntu:root /opt"
    ]
  }

  ### Packages ###
  # Install AL2 Packages
  provisioner "shell" {
    only = [
      "amazon-ebs.al2-cis",
      "amazon-ebs.al2-ecs-cis",
      "amazon-ebs.al2-eks-cis"
    ]
    remote_folder = "/opt/packer/files"
    inline = [
      "sudo yum -y update",
      "sudo yum install -y unzip wget jq",
      "sudo yum install -y ipa-client oddjob oddjob-mkhomedir sssd realmd krb5-workstation samba-common-tools adcli"
    ]
  }
  # Note: Only the ECS optimized AMI seems to exclude awscli for some reason
  provisioner "shell" {
    only          = ["amazon-ebs.al2-ecs-cis"]
    remote_folder = "/opt/packer/files"
    inline = [
      "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip",
      "cd /tmp; unzip awscliv2.zip",
      "sudo /tmp/aws/install -i /usr/local/aws-cli -b /usr/bin"
    ]
  }

  # RHEL packages
  provisioner "shell" {
    only = [
      "amazon-ebs.rhel-cis",
      "amazon-ebs.rhel-stig"
    ]
    remote_folder = "/opt/packer/files"
    inline = [
      "sudo dnf update -y && sudo yum autoremove -y",
      "sudo dnf install -y unzip wget jq",
      "sudo dnf install -y python3 python3-pip python3-setuptools python3-libs",
      "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip",
      "cd /tmp; unzip awscliv2.zip",
      "sudo /tmp/aws/install -i /usr/local/aws-cli -b /usr/bin",
      "sudo dnf install -y --nobest sssd realmd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools krb5-workstation openldap-clients python3-policycoreutils",
      "sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm --nogpgcheck",
      "sudo systemctl enable amazon-ssm-agent",
      "sudo pip3 install --upgrade boto3 requests",
      "sudo dnf upgrade -y"
    ]
  }

  # Ubuntu packages
  # Ubuntu 20.04
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu2004-cis",
      "amazon-ebs.ubuntu2004-stig",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig"
    ]
    remote_folder = "/opt/packer/files"
    pause_before  = "120s" # Wait must be long enough otherwise package lock will fail
    inline = [
      "sudo apt update",
      "sudo apt install -y python3.9 python3.9-dev python3.9-venv",
      "sudo apt install -y unzip wget jq sshpass acl",
      "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip",
      "cd /tmp; unzip awscliv2.zip",
      "sudo /tmp/aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin",
      "sudo apt install -y packagekit sssd sssd-tools libnss-sss libpam-sss realmd oddjob oddjob-mkhomedir adcli samba-common ldap-utils",
      "sudo chown -R ubuntu:root /opt",
      "sudo apt upgrade -y",
      "sudo apt autoremove -y",
      "sudo apt -y dist-upgrade"
    ]
  }
  # Ubuntu 22.04
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu2204-cis",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    remote_folder = "/opt/packer/files"
    pause_before  = "120s" # Wait must be long enough otherwise package lock will fail
    inline = [
      "sudo apt update",
      "sudo apt install -y python3.10-dev python3.10-venv",
      "sudo apt install -y unzip wget jq sshpass",
      "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip",
      "cd /tmp; unzip awscliv2.zip",
      "sudo /tmp/aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin",
      "sudo apt install -y packagekit sssd sssd-tools libnss-sss libpam-sss realmd oddjob oddjob-mkhomedir adcli samba-common ldap-utils",
      "sudo chown -R ubuntu:root /opt",
      "sudo apt upgrade -y",
      "sudo apt autoremove -y",
      "sudo apt -y dist-upgrade"
    ]
  }

  provisioner "shell" {
    remote_folder     = "/opt/packer/files"
    expect_disconnect = true
    inline            = ["sudo reboot"]
    pause_after       = "30s"
  }
  ### Install Ansible ###
  # AL2 Python & Ansible Core
  # Note: EPEL is added for sshpass, which is required for Ansible to authenticate using SSH password
  provisioner "shell" {
    only = [
      "amazon-ebs.al2-cis",
      "amazon-ebs.al2-ecs-cis",
      "amazon-ebs.al2-eks-cis"
    ]
    remote_folder = "/opt/packer/files"
    inline = [
      "sudo yum install -y yum-utils",
      "sudo amazon-linux-extras install epel -y",
      "sudo yum-config-manager --enable epel",
      "sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel sshpass",
      "sudo yum update -y && sudo yum autoremove -y",
      "sudo yum install -y parted system-lsb-core",
      "cd /opt",
      "wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz",
      "tar xzf Python-3.9.16.tgz",
      "cd Python-3.9.16",
      "sudo ./configure --enable-optimizations",
      "sudo make altinstall",
      "cd /opt",
      "sudo rm -rf /opt/Python-3.9.16.tgz /opt/Python-3.9.16",
      "python3.9 -V",
      "sudo mkdir -p /usr/share/ansible/collections",
      "sudo chown -R ${local.aws_ssh_username}:root /usr/share/ansible/collections",
      "umask 0022",
      "sudo /usr/local/bin/python3.9 -m pip install --upgrade pip",
      "sudo /usr/local/bin/pip3.9 install --upgrade cryptography"
    ]
  }
  provisioner "shell" {
    only = [
      "amazon-ebs.al2-cis",
      "amazon-ebs.al2-ecs-cis",
      "amazon-ebs.al2-eks-cis"
    ]
    remote_folder   = "/opt/packer/files"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} bash -l {{ .Path }}"
    inline = [
      "#!/bin/bash -e",
      "mkdir /opt/venv",
      "cd /opt/venv",
      "python3.9 -m venv ansible",
      "source /opt/venv/ansible/bin/activate",
      "pip3.9 install ansible-core==2.13.3",
      "pip3.9 install --upgrade requests pyopenssl boto3 botocore",
      "ansible-galaxy collection install amazon.aws -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.aws -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.general -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.crypto -p /usr/share/ansible/collections",
      "ansible-galaxy collection install ansible.posix -p /usr/share/ansible/collections"
    ]
  }

  # RHEL
  provisioner "shell" {
    only = [
      "amazon-ebs.rhel-cis",
      "amazon-ebs.rhel-stig"
    ]
    remote_folder = "/opt/packer/files"
    inline = [
      "sudo dnf install -y ansible-core-2.13.3 python3-dnf-plugin-versionlock",
      "sudo dnf versionlock ansible-core",
      "umask 0022",
      "sudo pip3.9 install --upgrade boto3 botocore jmespath",
      "sudo mkdir -p /usr/share/ansible/collections",
      "sudo chown -R ${local.aws_ssh_username}:root /usr/share/ansible/collections",
      "ansible-galaxy collection install amazon.aws -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.aws -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.general -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.crypto -p /usr/share/ansible/collections",
      "ansible-galaxy collection install ansible.posix -p /usr/share/ansible/collections"
    ]
  }
  # Ubuntu
  # Ubuntu 20.04
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu2004-cis",
      "amazon-ebs.ubuntu2004-stig",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig"
    ]
    remote_folder = "/opt/packer/files"
    inline = [
      "sudo mkdir -p /usr/share/ansible/collections",
      "sudo chown -R ubuntu:root /usr/share/ansible/collections",
      "cd /tmp",
      "umask 0022",
      "curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py",
      "sudo python3.9 get-pip.py",
      "rm get-pip.py",
      "sudo python3.9 -m pip install --upgrade pip",
      "sudo pip3.9 install --upgrade cryptography"
    ]
  }
  # Ubuntu 22.04
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu2204-cis",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    remote_folder = "/opt/packer/files"
    inline = [
      "sudo mkdir -p /usr/share/ansible/collections",
      "sudo chown -R ubuntu:root /usr/share/ansible/collections",
      "cd /tmp",
      "umask 0022",
      "curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py",
      "sudo python3.10 get-pip.py",
      "rm get-pip.py",
      "sudo python3.10 -m pip install --upgrade pip",
      "sudo pip3.10 install --upgrade cryptography pyopenssl"
    ]
  }

  provisioner "shell" {
    expect_disconnect = true
    remote_folder     = "/opt/packer/files"
    inline            = ["sudo reboot"]
    pause_after       = "30s"
  }

  # Ubuntu unprivileged tasks
  # Ubuntu 20.04
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu2004-cis",
      "amazon-ebs.ubuntu2004-stig",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig"
    ]
    remote_folder   = "/opt/packer/files"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} bash -l {{ .Path }}"
    inline = [
      "#!/bin/bash -e",
      "mkdir /opt/venv",
      "cd /opt/venv",
      "python3.9 -m venv ansible",
      "source /opt/venv/ansible/bin/activate",
      "pip3.9 install ansible-core==2.13.3",
      "pip3.9 install --upgrade requests boto3 botocore pyopenssl",
      "ansible-galaxy collection install amazon.aws -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.aws -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.general -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.crypto -p /usr/share/ansible/collections",
      "ansible-galaxy collection install ansible.posix -p /usr/share/ansible/collections"
    ]
  }
  # Ubuntu 22.04
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu2204-cis",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    remote_folder   = "/opt/packer/files"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} bash -l {{ .Path }}"
    inline = [
      "#!/bin/bash -e",
      "mkdir /opt/venv",
      "cd /opt/venv",
      "python3.10 -m venv ansible",
      "source /opt/venv/ansible/bin/activate",
      "pip3.10 install ansible-core==2.13.3",
      "pip3.10 install --upgrade requests boto3 botocore",
      "ansible-galaxy collection install amazon.aws -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.aws -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.general -p /usr/share/ansible/collections",
      "ansible-galaxy collection install community.crypto -p /usr/share/ansible/collections",
      "ansible-galaxy collection install ansible.posix -p /usr/share/ansible/collections"
    ]
  }

  ### EKS ###
  # Copy Files
  provisioner "file" {
    only = [
      "amazon-ebs.al2-eks-cis",
      "amazon-ebs.ubuntu1804-eks-cis",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    destination = "/opt/packer/files/"
    source      = "./files/eks/shared/"
  }
  provisioner "file" {
    only = [
      "amazon-ebs.al2-eks-cis",
      "amazon-ebs.ubuntu1804-eks-cis",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    destination = "/opt/packer/files/"
    source      = "./files/eks/log-collector-script/linux/"
  }
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu1804-eks-cis",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    remote_folder = "/opt/packer/files"
    inline        = ["sudo chmod -R a+x /opt/packer/files/bin/", "sudo mv /opt/packer/files/bin/* /usr/bin/"]
  }

  # Configure EKS
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu1804-eks-cis",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    environment_vars = [
      "AWS_ACCESS_KEY_ID=",
      "AWS_SECRET_ACCESS_KEY=",
      "AWS_SESSION_TOKEN=",
      "KUBERNETES_VERSION=${var.eks_version}",
      "KUBERNETES_BUILD_DATE=${var.eks_build_date}",
      "BINARY_BUCKET_NAME=${local.binary_bucket_name}",
      "BINARY_BUCKET_REGION=${local.binary_bucket_region}",
      "CNI_PLUGIN_VERSION=${var.cni_plugin_version}",
      "PULL_CNI_FROM_GITHUB=${local.pull_cni_from_github}",
      "PAUSE_CONTAINER_VERSION=${local.pause_container_version}",
      "CACHE_CONTAINER_IMAGES=${local.cache_container_images}"
    ]
    remote_folder = "/opt/packer/files"
    script        = "./scripts/linux/ubuntu/install-worker.sh"
  }

  ### Pre-Hardening Customization ###
  # Partition Disk
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.al2-cis",
      "amazon-ebs.al2-ecs-cis",
      "amazon-ebs.al2-eks-cis",
      "amazon-ebs.ubuntu2004-cis",
      "amazon-ebs.ubuntu2004-stig",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig",
      "amazon-ebs.ubuntu2204-cis",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = local.partition_disk_ansible
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}partition_disk"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.rhel-cis",
      "amazon-ebs.rhel-stig"
    ]
    command                 = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = local.partition_disk_ansible
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}partition_disk"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }

  provisioner "shell" {
    remote_folder     = "/opt/packer/files"
    expect_disconnect = true
    inline            = ["sudo reboot"]
    pause_after       = "30s"
  }
  # Post Partition Disk Cleanup
  # This is here to avoid old files (usually logs) from writing back to their old locations
  provisioner "shell" {
    only = [
      "amazon-ebs.rhel-cis",
      "amazon-ebs.rhel-stig",
      "amazon-ebs.al2-cis",
      "amazon-ebs.al2-ecs-cis",
      "amazon-ebs.al2-eks-cis",
      "amazon-ebs.ubuntu2204-cis",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    remote_folder = "/opt/packer/files"
    inline        = ["sudo rm -rf /var/log/audit-old /var/log-old /var/tmp-old /tmp-old /home-old /var-old"]
  }
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu2004-cis",
      "amazon-ebs.ubuntu2004-stig",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig"
    ]
    remote_folder = "/opt/packer/files"
    inline        = ["sudo rm -rf /var/log-old /var/tmp-old /tmp-old /home-old /var-old"]
  }

  # ECS
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.al2-ecs-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/shared/configure_docker.yml"
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}docker"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }

  ### Hardening ###
  # OS
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.al2-cis",
      "amazon-ebs.al2-ecs-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/al2/al2-cis.yml"
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}cis/al2"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.al2-eks-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/al2/al2-eks-cis.yml"
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}cis/al2"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.rhel-cis"
    ]
    command                 = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/rhel8/rhel8-cis-l1.yml"
    playbook_dir            = local.playbook_dir
    extra_arguments         = ["--tags", "level1-server"]
    role_paths              = ["${local.ansible_role_path}cis/rhel8"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.rhel-stig"
    ]
    command                 = "ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/rhel8/rhel8-stig.yml"
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}stig/rhel8"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.ubuntu2004-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/ubuntu/ubuntu20-cis-l1.yml"
    playbook_dir            = local.playbook_dir
    extra_arguments         = ["--tags", "level1-server,prelim_tasks"]
    role_paths              = ["${local.ansible_role_path}cis/ubuntu20"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.ubuntu2004-eks-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/ubuntu/ubuntu20-eks-cis-l1.yml"
    playbook_dir            = local.playbook_dir
    extra_arguments         = ["--tags", "level1-server,prelim_tasks"]
    role_paths              = ["${local.ansible_role_path}cis/ubuntu20"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.ubuntu2004-stig"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/ubuntu/ubuntu20-stig.yml"
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}stig/ubuntu20"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.ubuntu2004-eks-stig"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/ubuntu/ubuntu20-eks-stig.yml"
    playbook_dir            = local.playbook_dir
    extra_arguments         = ["--tags", "level1-server,prelim_tasks"]
    role_paths              = ["${local.ansible_role_path}stig/ubuntu20"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.ubuntu2204-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/ubuntu/ubuntu22-cis.yml"
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}cis/ubuntu22"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/linux/ubuntu/ubuntu22-eks-cis.yml"
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}cis/ubuntu22"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }

  provisioner "shell" {
    expect_disconnect = true
    remote_folder     = "/opt/packer/files"
    inline            = ["sudo reboot"]
    pause_after       = "30s"
  }

  # ECS
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.al2-ecs-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/shared/cis-docker.yml"
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}cis/docker"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }

  # EKS
  provisioner "ansible-local" {
    only = [
      "amazon-ebs.al2-eks-cis",
      "amazon-ebs.ubuntu1804-eks-cis",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    command                 = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
    playbook_file           = "./scripts/shared/cis-eks.yml"
    playbook_dir            = local.playbook_dir
    role_paths              = ["${local.ansible_role_path}cis/aws/eks"]
    clean_staging_directory = false
    staging_directory       = "/opt/packer/files"
  }

  ### Post Hardening Custom Configurations ###

#  provisioner "ansible-local" {
#    only = [
#      "amazon-ebs.al2-ecs-cis",
#      "amazon-ebs.al2-eks-cis",
#      "amazon-ebs.ubuntu2004-eks-cis",
#      "amazon-ebs.ubuntu2004-eks-stig",
#      "amazon-ebs.ubuntu2204-eks-cis"
#    ]
#    command       = "source /opt/venv/ansible/bin/activate && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook"
#    playbook_file = "./scripts/shared/lin_install_agents.yml"
#    playbook_dir  = local.playbook_dir
#    extra_arguments = [
#      "--extra-vars", "aws_region=${var.aws_region}",
#      "--extra-vars", "is_gov=${local.is_gov}"
#    ]
##    role_paths = [
##      "${local.ansible_role_path}trenddsm/linux_trend_agent_deploy",
##      "${local.ansible_role_path}elk/lin_deploy_elastic_agent",
##      "${local.ansible_role_path}splunk/lin_splunk_uf_deploy"
##    ]
#    clean_staging_directory = false
#    staging_directory       = "/opt/packer/files"
#  }

  ### Cleanup ###
  # Cleanup Ansible Core and Collections
  provisioner "shell" {
    only = [
      "amazon-ebs.al2-cis",
      "amazon-ebs.ubuntu2004-cis",
      "amazon-ebs.ubuntu2004-stig",
      "amazon-ebs.al2-eks-cis",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig",
      "amazon-ebs.ubuntu2204-cis",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    remote_folder = "/opt/packer/files"
    inline = [
      "sudo rm -rf /usr/share/ansible /opt/venv"
    ]
  }
  provisioner "shell" {
    only = [
      "amazon-ebs.rhel-cis",
      "amazon-ebs.rhel-stig"
    ]
    remote_folder = "/opt/packer/files"
    inline = [
      "sudo rm -rf /usr/share/ansible",
      "sudo dnf remove -y ansible-core"
    ]
  }

  # General cleanup
  provisioner "shell" {
    only = [
      "amazon-ebs.rhel-cis",
      "amazon-ebs.rhel-stig"
    ]
    inline = [
      "sudo rm -rf /opt/packer",
      "sudo shred -fu /etc/ssh/ssh_host_*",
      "sudo shred -fu /root/.ssh/authorized_keys",
      "sudo dnf clean all",
      "sudo rm -rf /var/cache/dnf",
      "sudo chage -M 9999 -m 9999 root",
      "sudo chage -M 9999 -m 9999 ec2-user",
      "sudo sestatus"
    ]
  }
  provisioner "shell" {
    only = [
      "amazon-ebs.al2-cis",
      "amazon-ebs.al2-eks-cis"
    ]
    remote_folder   = "/opt/packer/files"
    execute_command = "echo 'packer' | {{ .Vars }} sudo -S -E bash -eux '{{ .Path }}'"
    scripts = [
      "./scripts/linux/al2/hardening.sh",
      "./scripts/linux/al2/cleanup.sh"
    ]
  }
  provisioner "shell" {
    only = [
      "amazon-ebs.ubuntu2004-cis",
      "amazon-ebs.ubuntu2004-stig",
      "amazon-ebs.ubuntu2004-eks-cis",
      "amazon-ebs.ubuntu2004-eks-stig",
      "amazon-ebs.ubuntu2204-cis",
      "amazon-ebs.ubuntu2204-eks-cis"
    ]
    remote_folder   = "/opt/packer/files"
    execute_command = "echo 'packer' | {{ .Vars }} sudo -S -E bash -eux '{{ .Path }}'"
    scripts = [
      "./scripts/linux/ubuntu/cleanup.sh"
    ]
  }
}
