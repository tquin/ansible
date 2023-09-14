# tquin/ansible

## Controller Setup

* A `.vault.key` file needs to be added to the root of the repo. This allows decryption of the `secret_vars.yaml` file, which also needs to be added separately. Then, to manually edit variables in the vault, use:
```
ansible-vault edit group_vars/all/secret_vars.yaml
```

* The `jmespath` package needs to be installed on the Controller in order to use some filters.
  * `dnf install python3-jmespath`
  * `apt install python3-jmespath`

---

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

---

### Usage

The included script will ensure all requirements are installed through `ansible-galaxy`, then run the main playbook.
```
./run.sh
```
---

### Role-Specific Usage

**Workstation**

- GNOME actions require an active display session (not locked) during processing to allow actions. Use the Caffeine extension once installed to support this. 

- `gdrive_obsidian` requires interactive authentication after installion. Run `rclone config reconnect gdrive-obsidian:` on the client after running the playbook.

**Media**

- For `podqueue`, the `.opml` file in `resources/` needs to be updated. The provided example only contains one podcast as a proof-of-concept to avoid taking unnecessary disk space on test VMs.

- Plex needs a one-time "claim code" made to authenticate the server with an account. These codes expire within 5 minutes of generation, so they're not suitable for use in long playbooks. Plex also only supports claiming over localhost, not the local network.
  - Forward local port with `ssh <username>@<ansible_client> -L 32400:<ansible_client>:32400 -N`
  - Generate a code at [plex.tv/claim](https://www.plex.tv/claim/)
  - `curl -X POST 'http://127.0.0.1:32400/myplex/claim?token=claim-xxx'`

---

### Todo

- Minecraft
  - containerise?
- Plex
  - *cough* helpers
  - DB backups
- ZFS
  - Sanoid
- rclone azure backups
- mail forwarding for servers
- youtube-dlp under [media]
