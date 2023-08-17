# tquin/ansible

## Controller Setup

* A `.vault.key` file needs to be added to the root of the repo. This allows decryption of the `secret_vars.yaml` file, which also needs to be added separately. Then, to manually edit variables in the vault, use:
```
ansible-vault edit group_vars/all/secret_vars.yaml
```

### Client Setup

The only steps needed to do manually on a new machine is to install from a fresh ISO, configure a user account with sudo, and add the SSH key to the Ansible controller. Everything after that, including SSH hardening, can be done via the playbook.

* Install OS from ISO
  * ✔ Ubuntu Jammy 22.04
  * ✔ Debian Bookworm 12
  * ✔ Fedora 38
* Minimum specs for test VMs
  * 4GB RAM (mostly for Rust compiles)
  * 40GB disk space
* Ensure your user has sudo privileges
  * `su -` to root
  * `usermod -aG sudo <username>`
* If needed, install and start the SSH server
  * Check with `systemctl status sshd.service`
  * `su -c 'apt install -y openssh-server'`
  * `su -c 'dnf install -y openssh-server'`
  * `sudo systemctl enable --now sshd.service`
  * Then reboot for the sudo to take effect
* Generate an SSH key on the controller and copy it to the ansible_client
  * `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/ansible -C <email>`
  * `ssh-copy-id -i ~/.ssh/ansible <username>@<ansible_client>`
* Fill in the specific client hostname/IP details in the `hosts` file on the controller
  ```
  [all]
  <ansible_client> ansible_host=<client_ip> ansible_user="{{ username }}" ansible_connection=ssh ansible_ssh_private_key_file="/home/{{ username }}/.ssh/ansible"
  ```
* Optionally add the hostname into other host groups if you like (eg: add to `[workstation]` if you want GUI apps installed)
* Test the key is working without requiring a password
  * `ansible all -m ping`

### Usage

The included script will ensure all requirements are installed through `ansible-galaxy`, then run the main playbook.
```
./run.sh
```

### Role-Specific Usage

* Machines configured in the `[workstation]` group, they must have an active display session (not locked) during processing to allow for GNOME actions. Use the Caffeine extension once installed to support this. 
* If using the `[media]` group, the `.opml` file in `resources/` needs to be updated. The provided example only contains one podcast as a proof-of-concept to avoid taking unnecessary disk space on test VMs.

### Todo

- Plex
  - *cough* helpers
  - DB backups
- ZFS
  - Sanoid
- ZSH
- VPN
- Obsidian & drive sync
- Minecraft
  - BOMBE pub SSH key for backups
- rclone azure backups
- Error mailing for servers
