#!/usr/bin/env bash
# bash: script install and configure Nginx web server; App Server; Reverse Proxy
# and redirects traffic and serves error pages:

sudo apt-get update -y
sudo apt-get install -y nginx

# configure Nginx
sudo sed -i 's/80 default_server/80/' /etc/nginx/sites-available/default

# create index.html file served out by server:
# & configure the redirection and return error pages
echo 'Hello World!' > /etc/nginx/html/index.html
echo "Ceci n'est pas une page" > /etc/nginx/html/404.html

printf %s "server {
    listen 80;
    listen [::]:80 default_server;
    root   /etc/nginx/html;
    index  index.html index.htm;

    # proxy to gunicorn using nginx:
    location /airbnb-onepage {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
    }

    location /redirect_me {
        return 301 https://stackoverflow.com/;
    }

    error_page 404 /404.html;
    location = /404.html {
        root /etc/nginx/html;
        internal;
    }
}" > /etc/nginx/sites-available/default

sudo service nginx restart
