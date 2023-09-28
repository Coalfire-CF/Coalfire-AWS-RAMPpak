#!/usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

# Clean up apt caches to reduce the image size
apt-get clean

# Clean up files to reduce confusion during debug
rm -rf \
    /opt/packer \
    /etc/hostname \
    /etc/machine-id \
    /etc/ssh/ssh_host* \
    /home/ec2-user/.ssh/authorized_keys \
    /root/.ssh/authorized_keys \
    /var/lib/cloud/data \
    /var/lib/cloud/instance \
    /var/lib/cloud/instances \
    /var/lib/cloud/sem \
    /var/lib/dhclient/* \
    /var/lib/dhcp/dhclient.* \
    /var/log/cloud-init-output.log \
    /var/log/cloud-init.log \
    /var/log/secure \
    /var/log/wtmp

touch /etc/machine-id
