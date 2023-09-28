### Windows Gold ###
build {
  name = "windows"
  source "source.amazon-ebs.windows" {
    name       = "win-base"
    ami_name   = "win2019-gold-${local.datetime}"
    source_ami = data.amazon-ami.win-base.id
    run_tags = {
      Name     = "win2019-ms-gold-coalfire"
      OSType   = "Windows"
      OSFamily = "Windows2019"
      Release  = "${local.datetime}"
    }
    tags = {
      Name     = "win2019-ms-gold-coalfire"
      OSType   = "Windows"
      OSFamily = "Windows2019"
      Release  = "${local.datetime}"
    }
  }
  source "source.amazon-ebs.windows" {
    name       = "win-asg"
    ami_name   = "win2019-asg-gold-${local.datetime}"
    source_ami = data.amazon-ami.win-base.id
    run_tags = {
      Name     = "win2019-asg-ms-gold-coalfire"
      OSType   = "Windows"
      OSFamily = "Windows2019"
      Release  = "${local.datetime}"
    }
    tags = {
      Name     = "win2019-asg-ms-gold-coalfire"
      OSType   = "Windows"
      OSFamily = "Windows2019"
      Release  = "${local.datetime}"
    }
  }

  provisioner "powershell" {
    inline = [
      "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12",
      "Install-PackageProvider -Name NuGet -Force",
      "Start-Sleep -s 5",
      "setx /M EC2LAUNCH_TELEMETRY 0",
      "Uninstall-WindowsFeature -Name FS-SMB1",
      "Uninstall-WindowsFeature -Name Windows-Defender"
    ]
  }

  provisioner "powershell" {
    inline = [
      "if (!(Test-Path -Path $PROFILE.AllUsersCurrentHost)) {\n  New-Item -ItemType File -Path $PROFILE.AllUsersCurrentHost -Force\n}",
      "echo \"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12\" | Out-File -FilePath $PROFILE.AllUsersCurrentHost"
    ]
  }
#  provisioner "powershell" {
#    only = ["amazon-ebs.win-asg"]
#    environment_vars = [
#        "AWS_REGION=${var.aws_region}",
#        "SPLUNK_DOWNLOAD_URL=${local.splunk_win_download_url}",
#        "SPLUNK_FILENAME=${local.splunk_win_file_name}"
#    ]
#    script = "./scripts/windows/Install-Agents.ps1"
#  }

  provisioner "windows-restart" {
  }

  provisioner "powershell" {
    inline = [
      "C:\\ProgramData\\Amazon\\EC2-Windows\\Launch\\Scripts\\InitializeInstance.ps1 -Schedule",
      "C:\\ProgramData\\Amazon\\EC2-Windows\\Launch\\Scripts\\SysprepInstance.ps1 -NoShutdown"
    ]
  }
}