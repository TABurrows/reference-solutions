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
    01-add-nginx.yml


ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --ssh-common-args "$ANSIBLE_SSH_COMMON_ARGS" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    -e "tls_domain=$TLS_DOMAIN" \
    -e "tls_email=$TLS_EMAIL" \
    02-add-certificate.yml


ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --ssh-common-args "$ANSIBLE_SSH_COMMON_ARGS" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    -e "basic_user=$BASIC_USER" \
    -e "basic_pass=$BASIC_PASS" \
    03-add-basic-auth.yml


ansible-playbook -vvv -i $INSTANCE_IP, \
    -u "$ANSIBLE_USER" \
    --ssh-common-args "$ANSIBLE_SSH_COMMON_ARGS" \
    --private-key "$ANSIBLE_SSH_PRIVATE_KEY_FILE" \
    -e "master_node=$ES_MASTER_NODE_NAME" \
    -e "public_ip=$INSTANCE_IP" \
    04-add-kibana.yml