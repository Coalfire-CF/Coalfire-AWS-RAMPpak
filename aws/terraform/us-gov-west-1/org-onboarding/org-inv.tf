resource "null_resource" "account_org_invite_and_accept" {
  provisioner "local-exec" {
    command     = "chmod +x ${path.module}/account_invite.sh; ${path.module}/account_invite.sh ${data.aws_caller_identity.bu.account_id} ${var.role_arn} ${var.external_id} ${var.org_role_arn} ${var.org_external_id}"
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
  }
}