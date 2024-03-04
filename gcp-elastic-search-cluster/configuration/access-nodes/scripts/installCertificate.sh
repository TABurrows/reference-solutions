#!/bin/bash


# Set the variables
TLS_DOMAIN="$1"
TLS_EMAIL="$2"


# Exit on error
set -e

# Install packages
sudo apt-get update && apt-get install -y certbot

# Make the .well-known directory
sudo mkdir -p /var/www/letsencrypt/.well-known/acme-challenge/

# Create an ok file
sudo echo OK > /var/www/letsencrypt/.well-known/acme-challenge/ok.txt


# Ensure the .well-know directory is available over http
# eg.
# server {
#     listen 80;
#     server_name mydomain.com; 
    
#     location / {
#         return 301 https://$host$request_uri;
#     }
    
#     location /.well-known/acme-challenge/ {
#         root /var/www/letsencrypt/;
#     }
# }


# Make cert request non-interactively
sudo certbot certonly --noninteractive --agree-tos \
    --cert-name letsenc \
    -d $TLS_DOMAIN \
    -m $TLS_EMAIL \
    --webroot -w /var/www/letsencrypt


# Generate the dhparams file
sudo curl https://ssl-config.mozilla.org/ffdhe2048.txt > /etc/nginx/snippets/dhparams


# Generate the sslparams
sudo bash -c "cat > /etc/nginx/snippets/sslparams" <<EOF
ssl_session_timeout 1d;
ssl_session_cache shared:MozSSL:10m;  # about 40000 sessions
ssl_session_tickets off;

# curl https://ssl-config.mozilla.org/ffdhe2048.txt > /etc/nginx/snippets/dhparams
ssl_dhparam /etc/nginx/snippets/dhparams;

# modern configuration
ssl_protocols TLSv1.3;
ssl_prefer_server_ciphers off;

# HSTS (ngx_http_headers_module is required) (63072000 seconds)
add_header Strict-Transport-Security "max-age=63072000" always;

# OCSP stapling
ssl_stapling on;
ssl_stapling_verify on;	
EOF





# Possible https config
    # server {
    #     listen 443 ssl http2;
        
    #     # SSL configuration
    #     ssl_certificate  /etc/letsencrypt/live/mydomain.com/fullchain.pem; 
    #     ssl_certificate_key /etc/letsencrypt/live/mydomain.com/privkey.pem; 
    #     ssl_trusted_certificate /etc/letsencrypt/live/mydomain.com/fullchain.pem; 
    #     include snippets/sslparams;
        
    #     # Put here you domain
    #     #
    #     server_name mydomain.com;
        
    #     # Max file size useful for file uploading 
    #     # 
    #     client_max_body_size 8M;
    # ...   
        
