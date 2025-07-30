#!/bin/bash
set -e
set -o pipefail

for ARGUMENT in "$@"; do
    case $ARGUMENT in
        --upgrade|--force)
            GALAXY_UPGRADE_ARG="-f"
            ;;
        --verbose|-v)
            PLAYBOOK_VERBOSE_ARG="-v"
            ;;
        --hosts=*|-h=*)
            PLAYBOOK_TARGET_HOSTS="${ARGUMENT#*=}"
            ;;
        --hosts|-h)
            if [[ -n $2 && $2 != -* ]]; then
                PLAYBOOK_TARGET_HOSTS="$2"
                shift 2  # Skip both the flag and its value
            else
                echo "Error: $1 requires a value" >&2
                exit 1
            fi
            ;;
        *)
    esac
done

echo "GALAXY_UPGRADE_ARG: ${GALAXY_UPGRADE_ARG:-""}"
echo "PLAYBOOK_VERBOSE_ARG: ${PLAYBOOK_VERBOSE_ARG:-""}"
echo "PLAYBOOK_TARGET_HOSTS: ${PLAYBOOK_TARGET_HOSTS:-"test"}"

ansible-galaxy install -r requirements.yaml $GALAXY_UPGRADE_ARG

sudo ansible-playbook $PLAYBOOK_VERBOSE_ARG setup.yaml
# sudo above makes root the owner of this file
sudo chown "$USER:$USER" .fact_cache/localhost

ansible-playbook $PLAYBOOK_VERBOSE_ARG --limit "${PLAYBOOK_TARGET_HOSTS:-"test"}" run.yaml
