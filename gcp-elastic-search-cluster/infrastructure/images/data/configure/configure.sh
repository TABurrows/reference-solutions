#!/bin/bash

set -a;
source .env;
set +a;


ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --ssh-common-args "$ANSIBLE_SSH_COMMON_ARGS" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    00-add-node-exporter.yml


ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --ssh-common-args "$ANSIBLE_SSH_COMMON_ARGS" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    -e "es_discovery_seed_hosts=$ES_DISCOVERY_SEED_HOSTS" \
    01-add-elastic-search.yml


ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --ssh-common-args "$ANSIBLE_SSH_COMMON_ARGS" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    02-imaging-prep.yml

