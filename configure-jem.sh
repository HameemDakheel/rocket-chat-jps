#!/bin/bash

mkdir -p /etc/jelastic/ /var/lib/jelastic/vcs;
chown mongod:mongod /var/spool/cron/mongod /home/jelastic/;
chmod 755 /home/jelastic;
chmod 600 /var/spool/cron/mongod;

echo -e "# This file is considered only during container creation. To modify the list of items at Favorites panel,\n\
# please make the required changes within image initial settings and rebuild it.\n\
\n\
[directories]\n\
$HOME_DIR\n\
/var/spool/cron\n\
/var/lib/jelastic/keys\n\
/var/lib/mongo\n\
/usr/lib/node_modules/mongo-express\n\
/var/lib/jelastic/backup\n\
[files]\n\
/etc/mongod.conf\n\
/var/lib/jelastic/bin/backup_script.sh\n\
" >> /etc/jelastic/favourites.conf

echo -e "COMPUTE_TYPE=mongodb\n\
COMPUTE_TYPE_VERSION=${STACK_VERSION%%.*}\n\
COMPUTE_TYPE_FULL_VERSION=${STACK_VERSION%.*}\n\
PLATFORM_TECHMAIL_RECEPIENT=admin@nonexistentdomainxxx.com\n\
CERTIFIED_VERSION=2\n\
" >> /etc/jelastic/metainf.conf

echo -e "# This file stores links to custom configuration files or folders that will be kept during container redeploy.\n\
\n\
/etc/jelastic/redeploy.conf\n\
/etc/sysconfig/iptables-custom\n\
/etc/sysconfig/ip6tables-custom\n\
/home/jelastic/.ssh\n\
/home/jelastic/.bash_profile\n\
/home/jelastic/adminMongo/config\n\
/var/spool/cron/$STACK_USER\n\
/var/lib/jelastic/keys\n\
/var/lib/jelastic/backup\n\
/var/lib/mongo\n\
/etc/mongod.conf\n\
/etc/locale.conf\n\
/home/jelastic/mongodb.key\n\
/usr/lib/node_modules/mongo-express/config.default.js\n\
/usr/lib/locale\n" >> /etc/jelastic/redeploy.conf