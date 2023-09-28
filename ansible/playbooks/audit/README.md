# Auditing Playbooks
These are things that might run on a regular basis to pull information from the environment and store them for retrieval (usually in S3).
It is preferred to use a SIEM or Log Solution (Splunk, ELK) for most things, these plays might fill the gap if there are certain commands that can't otherwise be run or something more ad-hoc needs to be run.