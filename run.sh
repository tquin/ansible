#!/bin/bash
ansible-galaxy install -r requirements.yaml
ansible-playbook run.yaml
