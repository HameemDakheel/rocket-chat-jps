# # Dockerfile to build an updated custom MongoDB image for Jelastic
# # BASE IMAGE
# FROM centos:7

# # === 1. DEFINE VERSIONS ===
# # Set the target versions for MongoDB, Node.js, and mongo-express
# ENV STACK_VERSION=6.0.14
# ENV MONGO_MAJOR_VERSION=6.0
# ENV NODE_MAJOR_VERSION=16
# ENV MONGO_EXPRESS_VERSION=0.54.0


# # === 2. SYSTEM & JELASTIC PREPARATION ===
# # Install core utilities and configure the system environment
# LABEL maintainer="Hameem Dakheel"
# # (This is the new, corrected block)
# RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
#     sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
#     yum -y update && \
#     yum -y install epel-release && \
#     yum -y install --setopt=skip_missing_names_on_install=False \
#     acl http://repository.jelastic.com/pub/autofs-5.1.6-1j.el7.x86_64.rpm bind-utils bzip2 cronie \
#     curl e2fsprogs expect file gawk gettext git glibc-common iptables-services less libgudev1 logrotate \
#     lynx mc nano net-snmp-libs net-tools nfs-utils nscd openssh openssh-clients openssh-server \
#     openssl patch policycoreutils pv pwgen rpcbind rsyslog screen sed sendmail strace systemd \
#     tar unzip vim wget zip && \
#     yum clean all && \
#     sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config && \
#     sed -i 's/PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
#     sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config && \
#     sed -i -re '/^[\#]?ClientAliveInterval/cClientAliveInterval 30' /etc/ssh/sshd_config && \
#     sed -i -re '/^[\#]?ClientAliveCountMax/cClientAliveCountMax 50' /etc/ssh/sshd_config && \
#     sed -i '/^override_install_langs=/d' /etc/yum.conf  && \
#     sed -i 's/IPTABLES_MODULES_UNLOAD=.*/IPTABLES_MODULES_UNLOAD=“no”/' /etc/sysconfig/iptables-config && \
#     sed -i 's/#UseDNS/UseDNS/g' /etc/ssh/sshd_config && \
#     sed -i 's/UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config && \
#     sed -ri '/^[[:blank:]]*enable[-]cache[[:blank:]]+(passwd|netgroup)[[:blank:]]/s/yes/no/' /etc/nscd.conf && \
#     sed -ri '/^[[:blank:]]*positive[-]time[-]to[-]live[[:blank:]]+hosts[[:blank:]]/s/3600/60/' /etc/nscd.conf && \
#     sed -i 's/#SystemMaxUse=/SystemMaxUse=50M/g' /etc/systemd/journald.conf && \
#     mkdir -p /etc/jelastic/ && \
#     echo centos7jelastic `date "+%F %T"` >> /etc/jelastic/jinfo.ini

# # === 3. MONGODB REPOSITORY & INSTALLATION ===
# # Add the official yum repository for the new MongoDB version
# RUN printf "[mongodb-org-${MONGO_MAJOR_VERSION}]\n\
# name=MongoDB Repository\n\
# baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/${MONGO_MAJOR_VERSION}/x86_64/\n\
# gpgcheck=1\n\
# enabled=1\n\
# gpgkey=https://www.mongodb.org/static/pgp/server-${MONGO_MAJOR_VERSION}.asc" > /etc/yum.repos.d/mongodb-org.repo

# # Install Node.js, the new MongoDB version, and an updated mongo-express
# # (This is the new, corrected block)
# RUN curl --silent --location https://rpm.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - && \
#     yum install -y --setopt=skip_missing_names_on_install=False \
#     mongodb-org-${STACK_VERSION} \
#     nodejs jq moreutils && \
#     yum clean all && \
#     mkdir -p /home/jelastic/ && npm install -g mongo-express@${MONGO_EXPRESS_VERSION}

# # === 4. POST-INSTALL & PERMISSIONS ===
# # Configure permissions, ownership, and other system settings for MongoDB
# RUN setcap 'cap_net_bind_service=+ep' $(which node) && \
#     mkdir -p /var/lib/jelastic/{keys,backup} && \
#     chown -R mongod:mongod /var/lib/jelastic/keys /var/lib/jelastic/bin && \
#     sed -i 's/bindIp/#bindip/' /etc/mongod.conf && \
#     echo "/var/log/mongodb  /var/lib/jelastic/log none  bind 0 0" >> /etc/fstab && \
#     groupmod -g 700 mongod && usermod -ou 700 -g 700 mongod && \
#     chown -R mongod:mongod /home/jelastic/ /etc/mongorc.js && usermod -d /home/jelastic/ mongod && \
#     chown -R mongod:mongod /var/lib/jelastic/keys /var/lib/jelastic/bin /var/lib/mongo /var/lib/jelastic /usr/local/sbin/jcm /usr/lib/node_modules/mongo-express /usr/bin/bsondump /usr/bin/mongo* && \
#     chmod +x /var/lib/jelastic/bin/backup_script.sh /usr/local/sbin/jcm && \
#     rm -f /usr/lib/systemd/system/mongod.service /etc/systemd/system/multi-user.target.wants/mongod.service && \
#     getent group apache >/dev/null || /usr/sbin/groupadd -g 48 -r apache 2> /dev/null && \
#     getent passwd apache >/dev/null || /usr/sbin/useradd -c "Apache" -u 48 -g apache -s /sbin/nologin -r -d /usr/share/httpd apache 2> /dev/null && \
#     rm -rf /var/cache/httpd /etc/yum.repos.d/mongodb* && \
#     echo "mongod     soft    nproc     262145" >> /etc/security/limits.d/20-nproc.conf && \
#     chmod 0644 /etc/logrotate.d/mongo-express /etc/logrotate.d/mongoreset;

# # === 5. JELASTIC CONFIGURATION & FINALIZATION ===
# # Copy and run the Jelastic environment script
# COPY configure-jem.sh /tmp/configure-jem.sh
# RUN chmod +x /tmp/configure-jem.sh && /tmp/configure-jem.sh

# # Expose required ports
# EXPOSE 21 22 25 27017 7979 80

# # Set the final command to start systemd, matching the original image
# CMD ["/usr/lib/systemd/systemd"]
# Use the original, working Jelastic image as our foundation
FROM jelastic/mongo:5.0.2

# Set Environment Variables for the upgrade
ENV STACK_VERSION=8.0.1
ENV MONGO_MAJOR_VERSION=8.0
ENV NODE_MAJOR_VERSION=16
ENV MONGO_EXPRESS_VERSION=0.54.0

# --- Upgrade Steps ---
RUN \
    # 1. Fix CentOS 7 EOL Repositories
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* && \
    \
    # 2. Uninstall old MongoDB and remove the old repo file
    yum remove -y mongodb-org* && \
    rm -f /etc/yum.repos.d/mongodb-org-5.0.repo && \
    \
    # 3. Add the new MongoDB 8.0 repo file
    printf "[mongodb-org-${MONGO_MAJOR_VERSION}]\n\
name=MongoDB Repository\n\
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/${MONGO_MAJOR_VERSION}/x86_64/\n\
gpgcheck=1\n\
enabled=1\n\
gpgkey=https://www.mongodb.org/static/pgp/server-${MONGO_MAJOR_VERSION}.asc" > /etc/yum.repos.d/mongodb-org.repo && \
    \
    # 4. Setup new Node.js version and install new MongoDB + mongo-express
    curl --silent --location https://rpm.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - && \
    yum install -y --setopt=skip_missing_names_on_install=False mongodb-org-${STACK_VERSION} nodejs jq moreutils && \
    npm install -g mongo-express@${MONGO_EXPRESS_VERSION} && \
    \
    # 5. Clean up
    yum clean all && rm -rf /var/cache/yum

# Reset the CMD to ensure it uses the original image's entrypoint
CMD ["/usr/lib/systemd/systemd"]