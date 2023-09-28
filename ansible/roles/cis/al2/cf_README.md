## Coalfire Edits
Pulled from original repo at this commit time:
https://github.com/ansible-lockdown/AMAZON2-CIS/commit/1f6950c1b12c494ee0e0d669d24be147ab4e147d

Used devel branch for greater compatibility with Ansible-core 2.12 and higher.

Added handlers as it was missing from original code, even though tasks referred to them:
```
- name: remount home
  command: mount -o remount /home
  args:
      warn: false

- name: remount var_tmp
  command: mount -o remount /var/tmp
  args:
      warn: false
```

Review defaults > main.yml for "Coalfire Edit" in comments to see changes from original.