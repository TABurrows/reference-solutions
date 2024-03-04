 #!/bin/bash

set -a;
source .env;
set +a;

echo $ANSIBLE_SSH_COMMON_ARGS

ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --ssh-common-args "$ANSIBLE_SSH_COMMON_ARGS" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    00-add-node-exporter.yml


ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --ssh-common-args "$ANSIBLE_SSH_COMMON_ARGS" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    01-add-logstash.yml


ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --ssh-common-args "$ANSIBLE_SSH_COMMON_ARGS" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    02-add-logstash-plugin.yml