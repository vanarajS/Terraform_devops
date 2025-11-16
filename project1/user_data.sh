#!/bin/bash
# Update system
yum update -y

# Install Apache
yum install -y nginx

# Enable and start Apache
systemctl enable nginx
systemctl start nginx

# Fetch instance metadata
HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create test page
cat <<EOF > /var/www/html/index.html
<html>
  <head>
    <title>ALB Test Server</title>
  </head>
  <body style="font-family: Arial; text-align: center; margin-top: 50px;">
    <h1 style="color: #3366ff;">ALB Test Server</h1>
    <h2>Host: $HOSTNAME</h2>
    <h3>Private IP: $PRIVATE_IP</h3>
    <h3>Availability Zone: $AZ</h3>
    <p>This instance is behind an AWS ALB.</p>
  </body>
</html>
EOF

# Allow Apache through firewall if needed
if command -v firewall-cmd &> /dev/null; then
    firewall-cmd --permanent --add-service=http
    firewall-cmd --reload
fi
