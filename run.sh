#!/bin/zsh
ansible-galaxy install -r requirements.yaml
ansible-playbook playbooks/run.yaml
