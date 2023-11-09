#!/bin/sh
ansible-galaxy install -r requirements.yaml
sudo ansible-playbook setup.yaml
ansible-playbook run.yaml
