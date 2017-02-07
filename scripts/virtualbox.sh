#!/bin/sh

. /root/.profile

pkg install -y virtualbox-ose-additions-nox11

cat <<'EOF' >> /etc/rc.conf

# VirtualBox configuration
vboxguest_enable="YES"
vboxnet_enable="YES"
vboxservice_enable="YES"
EOF

cat <<'EOF' >> /boot/loader.conf
autoboot_delay="2"
if_vtnet_load="YES"
vboxdrv_load="YES"
virtio_balloon_load="YES"
virtio_blk_load="YES"
virtio_scsi_load="YES"
EOF

exit
