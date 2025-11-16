#!/bin/bash
# Install updates
yum update -y || apt update -y

# Install NGINX (Amazon Linux / RHEL / Ubuntu compatibility)
if command -v yum >/dev/null 2>&1; then
    yum install -y nginx
    systemctl enable nginx
    systemctl start nginx
elif command -v apt >/dev/null 2>&1; then
    apt update -y
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
fi

# Create a simple test page
cat <<EOF > /usr/share/nginx/html/index.html
<html>
<head>
<title>ALB Test</title>
</head>
<body>
<h1>NGINX is running behind your ALB!</h1>
<p>Instance hostname: $(hostname)</p>
<p>Served at: $(date)</p>
</body>
</html>
EOF

# Open HTTP port if needed (Amazon Linux 2023 uses firewalld disabled by default)
if command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --add-service=http --permanent
    firewall-cmd --reload
fi
