# tquin/ansible

## Controller Setup

* A `.vault.key` file needs to be added to the root of the repo. This allows decryption of the `secret_vars.yaml` file, which also needs to be added separately. Then, to manually edit variables in the vault, use:
```
ansible-vault edit group_vars/all/secret_vars.yaml
```

* Generate an SSH key on the controller
  * `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/ansible -C <email>`

---

## Client Setup

The only steps needed to do manually on a new machine is to install from a fresh ISO, configure a user account with sudo, and add the SSH key to the Ansible controller. Everything after that, including SSH hardening, can be done via the playbook.

* Install OS from ISO
  * ✔ Ubuntu Noble 24.04
  * ✔ Debian Bookworm 12
  * ✔ Fedora 40
* Minimum specs for test VMs
  * 4GB RAM (mostly for Rust compiles)
  * 50+GB disk space
* Ensure your user has sudo privileges
  * `su -` to root
  * `usermod -aG sudo <username>`
  * Then reboot for the sudo to take effect
* If needed, install and start the SSH server
  * Check with:
    * Debian & Fedora: `systemctl status sshd.service`
    * Ubuntu 24.04: `systemctl status ssh.service`
  * Install:
    * `su -c 'apt install -y openssh-server'`
    * `su -c 'dnf install -y openssh-server'`
  * Then enable:
    * Debian & Fedora:`sudo systemctl enable --now sshd.service`
    * Ubuntu: `sudo systemctl enable --now ssh.service`
* Copy the controller SSH key to the ansible_client
  * `ssh-copy-id -i ~/.ssh/ansible <username>@<ansible_client>`
* Fill in the specific client hostname/IP details in the `inventory/` files on the controller
* Optionally add the hostname into other host groups if you like (eg: add to `[workstation]` if you want GUI apps installed)
* Test the key is working without requiring a password
  * `ansible all -m ping`

---

## Usage

The included script will ensure all requirements are installed through `ansible-galaxy`, the controller is configured correctly, and then run the main playbook.
```
./run.sh
```

Optionally, you can choose to re-download the latest version of each dependency with `-f` or `--upgrade`:
```
./run.sh --upgrade
```
---

## Role-Specific Usage

**Workstation**

- GNOME actions require an active display session (not locked) during processing to allow actions. Use the Caffeine extension once installed to support this. 

- `gdrive_obsidian` requires interactive authentication after installion. Run `rclone config reconnect gdrive-obsidian:` on the client after running the playbook.

**Media**

- Plex needs a one-time "claim code" made to authenticate the server with an account. These codes expire within 5 minutes of generation, so they're not suitable for use in automated playbooks. Plex also only supports claiming over localhost, not the local network.
  - Forward local port with `ssh <username>@<ansible_client> -L 32400:<ansible_client>:32400 -N`
  - Generate a code at [plex.tv/claim](https://www.plex.tv/claim/)
  - `curl -X POST 'http://127.0.0.1:32400/myplex/claim?token=claim-xxx'`

---

## Todo

- Plex
  - DB backups
- file share / samba
- pika config
- ubuntu 24.04 testing
- logrotate / rsnapshot for minecraft, to keep weeklies/monthlies/yearlies
