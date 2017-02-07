PARTITIONS=ada0
DISTRIBUTIONS="base.txz kernel.txz lib32.txz"

#!/bin/sh
echo 'WITHOUT_X11="YES"' >> /etc/make.conf
echo "nameserver $NAME_SERVER" >> /etc/resolv.conf
cat >> /etc/rc.conf <<EOF
ifconfig_em0="DHCP"
sshd_enable="YES"
dumpdev="AUTO"
rpcbind_enable="YES"
nfs_server_enable="YES"
mountd_flags="-r"
EOF

export ASSUME_ALWAYS_YES=yes
pkg bootstrap
pkg update
pkg install -y sudo
pkg install -y bash
pkg install -y ca_root_nss

ln -sf /usr/local/share/certs/ca-root-nss.crt /etc/ssl/cert.pem

echo -n 'vagrant' | pw usermod root -h 0
pw groupadd -n vagrant -g 1000
echo -n 'vagrant' | pw useradd -n vagrant -u 1000 -s /usr/local/bin/bash -m -d /home/vagrant/ -G vagrant -h 0
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /usr/local/etc/sudoers

if [ X$HTTP_PROXY != X ]; then
    echo "export HTTP_PROXY='${HTTP_PROXY}'" >> /home/vagrant/.bash_profile
    echo "setenv HTTP_PROXY '${HTTP_PROXY}'" >> /root/.cshrc
    echo "HTTP_PROXY='${HTTP_PROXY}'" >> /root/.profile
    echo "export HTTP_PROXY" >> /root/.profile
fi
if [ X$HTTPS_PROXY != X ]; then
    echo "export HTTPS_PROXY='${HTTPS_PROXY}'" >> /home/vagrant/.bash_profile
    echo "setenv HTTPS_PROXY '${HTTPS_PROXY}'" >> /root/.cshrc
    echo "HTTPS_PROXY='${HTTPS_PROXY}'" >> /root/.profile
    echo "export HTTPS_PROXY" >> /root/.profile
fi
if [ X$NO_PROXY != X ]; then
    echo "export NO_PROXY='${NO_PROXY}'" >> /home/vagrant/.bash_profile
    echo "setenv NO_PROXY '${NO_PROXY}'" >> /root/.cshrc
    echo "NO_PROXY='${NO_PROXY}'" >> /root/.profile
    echo "export NO_PROXY" >> /root/.profile
fi

if [ -f /home/vagrant/.bash_profile ]; then
    chown vagrant:vagrant /home/vagrant/.bash_profile
fi

reboot
