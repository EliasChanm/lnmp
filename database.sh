#!/bin/bash

# install mariadb
sudo su -
yum -y install mariadb mariadb-server mariadb-devel
systemctl enable mariadb --now

# configure mariadb
mysql -u root <<'EOF'
UPDATE mysql.user SET password=password('AWSsourceEnv2022') WHERE user='root';
flush privileges;
CREATE USER 'wordpress-user' IDENTIFIED BY 'AWSRocksSince2006';
CREATE DATABASE `wordpress-db`;
GRANT ALL PRIVILEGES ON `wordpress-db`.* TO "wordpress-user";
FLUSH PRIVILEGES;
EOF

mysql -uroot -p'AWSsourceEnv2022' <<'EOF'
CREATE DATABASE bbs;
GRANT ALL ON bbs.* TO 'bbs_admin'@'%' IDENTIFIED BY 'admin123';
EOF
