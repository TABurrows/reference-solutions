#!/bin/bash

set -a;
source .env;
set +a;


ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    add-prometheus-targets.yml
