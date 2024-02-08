#!/bin/bash
set -e

for ARGUMENT in "$@"; do
    if [[ "$ARGUMENT" = "--upgrade" || "$ARGUMENT" = "-f" ]]; then
        # -f (force) will re-download latest collections/roles
        GALAXY_REQS_ARGS="-f" 
    fi
done

ansible-galaxy install -r requirements.yaml $GALAXY_REQS_ARGS
sudo ansible-playbook setup.yaml
ansible-playbook run.yaml
