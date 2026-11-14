# Build steps

After each step, take a screenshot (list at the end) and tick the matching box in the README.
Use fictional data and lab-only passwords. Keep the lab on an isolated network.

## 0. Requirements
- VMware Workstation or VirtualBox (check which one is free for your use)
- Windows Server 2022 evaluation ISO (Microsoft evaluation, free) and a Windows 10 ISO (from Microsoft)
- 8 GB host: give SV-DC01 2 GB of RAM and SV-CLIENT01 2 GB, use dynamic disks (about 40 GB and 30 GB), and close other programs while the VMs run.

## 1. Create the two VMs on an isolated network
- SV-DC01: Windows Server 2022, one network adapter on a host-only / internal network.
- SV-CLIENT01: Windows 10, one adapter on the same network.
- A second NAT adapter on SV-DC01 is optional (only for updates).

## 2. SV-DC01: name and address
1. Rename the computer to `SV-DC01`.
2. Static IP `192.168.10.10`, mask `255.255.255.0`, DNS `127.0.0.1`.

## 3. SV-DC01: Active Directory
1. Add the role **Active Directory Domain Services** (this also sets up DNS during promotion).
2. Promote the server: new forest `sv.local`, with a lab-only DSRM password.
3. Restart and log in as `SV\Administrator`.

## 4. Users, groups and policies (scripts)
In PowerShell as administrator on SV-DC01 (copy the `scripts` folder there first). Try the scripts on the small sample first:
```powershell
.\scripts\create_users.ps1
.\scripts\password_policy.ps1
.\scripts\audit_policy.ps1
```
Optional scale test: generate 1,000 fictional users with `python python\generate_users.py 1000 users_generated.csv`, then run `create_users.ps1 -CsvPath .\users_generated.csv`.

## 5. SV-CLIENT01: join the domain
1. Rename to `SV-CLIENT01`, IP `192.168.10.20`, mask `255.255.255.0`, DNS `192.168.10.10`.
2. Check connectivity with `ping 192.168.10.10`.
3. Join the domain `sv.local`, restart, and log in with a lab user.

## 6. Failed logons and analysis
1. On SV-CLIENT01, enter a wrong password several times for one lab user.
2. On SV-DC01: `.\scripts\get_failed_logons.ps1`
3. Run: `python python\analyze_failed_logons.py failed_logons.csv`

## 7. Screenshots to take (into `docs/screenshots/`)
1. The two VMs and their network settings
2. `ipconfig` on SV-DC01 and SV-CLIENT01
3. Active Directory Users and Computers: OUs, users and groups
4. Group Policy / password policy settings
5. Event Viewer: event 4625
6. Output of the Python analyzer on your own exported events

Before committing, hide e-mail addresses, license keys and anything that is not part of the fictional lab.

## 8. Notes (write these yourself)
After each step, add 2 or 3 lines to `docs/notes.md`: what you did, what failed, how you fixed it.
