# tquin/ansible

## Usage Requirements

* This is currently configured to run on apt-based distros only; I need to add pacman or dnf at a later stage.

* A `.vault.key` file needs to be added to the root of the repo. This allows decryption of the `secret_vars.yaml` file, which also needs to be added separately. Then, to manually edit variables in the vault, use:
```
ansible-vault edit group_vars/all/secret_vars.yaml
```

### Manual Client Setup

The only steps needed to do manually on a new machine is to install from a fresh ISO, configure a user account with a password, and add the SSH key to the Ansible controller. Everything after that, including SSH hardening, can be done via the playbook.

* Install OS from ISO
  * ✔ Ubuntu Jammy 22.04
  * ✔ Debian Bookworm 12
  * ⚒️ Fedora 38
* Minimum specs
  * 4GB RAM (mostly for Rust compiles)
* Ensure your user has sudo privileges on the ansible_client
  * `su` to root
  * `usermod -aG sudo <username>`
* If needed, install the SSH server on the ansible_client
  * `systemctl status sshd.service`
  * `sudo systemctl enable --now sshd.service`
  * `su -c 'apt install -y openssh-server'`
  * Then reboot for the sudo to take effect
* Generate an SSH key on the controller and copy it to the ansible_client
  * `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/ansible -C <email>`
  * `ssh-copy-id -i ~/.ssh/ansible <username>@<ansible_client>`
* Fill in the specific ansible_client hostname/IP details in the `hosts` file
  ```
  [home]
  <ansible_client> ansible_host=<client_ip> ansible_user="{{ username }}" ansible_connection=ssh ansible_ssh_private_key_file="/home/{{ username }}/.ssh/ansible"
  ```
* Optionally add the hostname into other host groups if you like (eg: add to [workstation] if you want GUI apps installed)
* Test the key is working without requiring a password
  * `ansible all -m ping`

### Usage

The included script will ensure all requirements are installed through `ansible-galaxy`, then run the main playbook.
```
./run.sh
```

### Todo

- Plex
  - *cough* helpers
  - DB backups
- ZFS
  - Sanoid
- ZSH
- Fedora
  - Nerdfonts alternative
  - Debops alternatives
- VPN
- Obsidian & drive sync
- Minecraft
  - BOMBE pub SSH key for backups
- rclone azure backups
- Gnome extension settings through dconf
  - dash to dock: auto hide behaviour
- Error mailing for servers
