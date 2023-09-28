# Coalfire Edits
Changed "prelim.yml" lines 27, 29, 34, 39 variable name "tmp_mnt_type" to "tmp_mnt_type_prelim" in order to avoid set_fact from overwriting the same variable name.

## Section 1
Changed cis_1.1.2.x.yml - cis_1.1.7.x.yml

Old:
```
name: "{{ item.device }}"
src: "{{ item.fstype }}"
state: present
fstype: tmpfs
```

New:
```
name: /var
src: "{{ item.device }}"
fstype: "{{ item.fstype }}"
state: present
```

Set static name for name, preserved existing fstype, set src to device.  This mirrors working RHEL CIS role.
This change was made because the old configuration kept leading to boot errors, suspect it was misconfigured.


## Section 5
Changed "cis_5.3.x.yml" line 52 from "ec2-user" to "ubuntu" to allow passwordless sudo for default user.