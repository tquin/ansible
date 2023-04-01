# tquin/ansible

## Requirements

* This is currently configured to run on apt-based distros only; I need to add pacman or dnf at a later stage.

* A `vault.key` file needs to be added to the root of the repo. This allows decryption of the `secrets.yaml` file.

* Run the below to install all of the third-party dependencies from Galaxy:
```
ansible-galaxy install -r requirements.yaml
```

### Manual Client Setup

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
* Fill in the specific ansible_client hostname/IP details in the `hosts` file
  ```
  [home]
  <ansible_client> ansible_host=<client_ip> ansible_user="{{ username }}" ansible_connection=ssh ansible_ssh_private_key_file="/home/{{ username }}/.ssh/ansible"
  ```
* Test the key is working without requiring a password
  * `ansible all -m ping`

### Usage

Just run the main playbook:
```
ansible-playbook playbooks/run.yaml
```

### Todo

- Plex
- ZFS
- ZSH
- Gnome extensions
- Fedora
- VPN
- Unattended upgrades
