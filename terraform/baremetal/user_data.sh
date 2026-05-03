#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx

mkdir -p /var/www/healthpulse

cat > /var/www/healthpulse/index.html <<'HTML'
<!DOCTYPE html>
<html>
<head>
  <title>HealthPulse Portal</title>
</head>
<body>
  <h1>HealthPulse Portal</h1>
  <p>Bare-metal Nginx deployment is running successfully.</p>
</body>
</html>
HTML

cat > /etc/nginx/sites-available/healthpulse <<'NGINX'
server {
    listen 80;
    server_name _;

    root /var/www/healthpulse;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /health {
        default_type application/json;
        return 200 '{"status":"healthy","deploy":"baremetal"}';
    }
}
NGINX

ln -sf /etc/nginx/sites-available/healthpulse /etc/nginx/sites-enabled/healthpulse
rm -f /etc/nginx/sites-enabled/default

nginx -t
systemctl enable nginx
systemctl restart nginx
