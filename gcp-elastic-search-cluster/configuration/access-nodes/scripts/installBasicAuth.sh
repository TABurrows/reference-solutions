#!/bin/bash


# Exit on error
set -e


USER="$1"
PASS="$2"


# password utils
sudo apt-get install apache2-utils -y

# Delete existing password file if exists
if [ -f /etc/nginx/htpasswd.users ]; then
    sudo rm /etc/nginx/htpasswd.users
fi

# INTERACTIVE: set the user password
sudo htpasswd -b -c /etc/nginx/htpasswd.users $USER $PASS





# Edit the nginx conf file adding:

        # auth_basic "Restricted Access";
        # auth_basic_user_file /etc/nginx/htpasswd.users;

# to the server -> location block

# check the config and then restart the service