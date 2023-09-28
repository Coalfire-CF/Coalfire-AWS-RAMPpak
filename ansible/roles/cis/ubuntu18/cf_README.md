## Coalfire Edits
Pulled from original repo at this commit time:
https://github.com/ansible-lockdown/UBUNTU18-CIS/commit/1191254cc31934f0104dfd4bea5c746966f15be2

Used devel branch for greater compatibility with Ansible-core 2.12 and higher.

Also commented out apt update task in prelim.yml as it was failing with a vague error.  The apt update task on the command line does not fail.

Scroll through defaults > main.yml for "Coalfire Edits" in comments.

SSH Defaults Originals:

ciphers: "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr"
kex_algorithms: "curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256"


SSH Defaults Modified (to work with FIPS):
ciphers: "aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr"
kex_algorithms: "diffie-hellman-group14-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256"
