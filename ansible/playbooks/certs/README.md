# Certificate Playbooks
These are plays for initial TLS certificate generation of each respective application.  The plays largely call only one role (gen_tls_cert) with different arguments/variables (instance count, password, application name) to generate certificates needed by each application.

These only generate the certificates and do nothing to install them anywhere.  These are expected to be run by Terraform calling Ansible and are not expected to be run manually.