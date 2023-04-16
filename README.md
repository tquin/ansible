# tquin/ansible

## Requirements

* This is currently configured to run on apt-based distros only; I need to add pacman or dnf at a later stage.

* A `vault.key` file needs to be added to the root of the repo. This allows decryption of the `secrets.yaml` file.

* Run the below to install all of the third-party dependencies from Galaxy:
```
ansible-galaxy install -r requirements.yaml
```

### Manual Setup

The only steps needed to do manually on a new machine is to install from a fresh ISO, configure a user account with a password, and add the SSH key to the Ansible controller. Everything after that, including SSH hardening, can be done via the playbook.

* Install OS from ISO
  * ✔ Ubuntu Jammy 22.04
  * 🛠 Deb Bullseye 11
* If needed, install the SSH server on the ansible_client
  * `su -c 'usermod -Ag sudo <username>'`
  * `su -c 'apt install -y openssh-server'`
  * Then reboot for the sudo to take effect
* Generate an SSH key on the controller and copy it to the ansible_client
  * `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/ansible -C <email>`
  * `ssh-copy-id -i ~/.ssh/ansible <username>@<ansible_client>`
* Ensure your user has sudo privileges on the ansible_client
  * `su` to root
  * `sudo usermod -aG sudo <username>`
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

- Fix starship on Debian
- Plex
- ZFS
- ZSH
- Gnome extensions
- Fedora
- VPN
- Unattended upgrades
