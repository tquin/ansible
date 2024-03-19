#!/bin/bash
set -e

for ARGUMENT in "$@"; do
    if [[ "$ARGUMENT" = "--upgrade" || "$ARGUMENT" = "--force" || "$ARGUMENT" = "-f" ]]; then
        # -f (force) will re-download latest collections/roles
        GALAXY_REQS_ARGS="-f"
    fi

    if [[ "$ARGUMENT" = "--verbose" || "$ARGUMENT" = "-v" ]]; then
        PLAYBOOK_VERBOSE_LEVEL="-v"
    else
        PLAYBOOK_VERBOSE_LEVEL=""
    fi
done

echo "PLAYBOOK_VERBOSE_LEVEL: $PLAYBOOK_VERBOSE_LEVEL"

ansible-galaxy install -r requirements.yaml $GALAXY_REQS_ARGS
sudo ansible-playbook setup.yaml
ansible-playbook $PLAYBOOK_VERBOSE_LEVEL run.yaml
