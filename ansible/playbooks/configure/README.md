# Configure Playbooks
These are copied over and adjusted from the original Launchpad "coalfire-ansible" repository and adjusted to work with ansible-core 2.13.
It is expected that any "Day 2" configurations (after initial deployment, or something that needs to run regularly) will be kept here.  Typically this would largely be agent installations and reapplying hardening benchmarks.

Patching plays are simple to include but were excluded since [AWS SSM Patch Policies](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-policies-about.html) seem to make it entirely unnecessary.  The patch policies can only be manually configured, but it is simple enough to do in 5 minutes with a few clicks.