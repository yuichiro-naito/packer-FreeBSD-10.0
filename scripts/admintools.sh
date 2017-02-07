#!/bin/sh

pkg install -y sudo lv

patch -d /usr/local/etc <<__EOS__
--- sudoers.org 2016-06-01 14:53:51.336859624 +0900
+++ sudoers     2016-06-01 14:54:12.886877184 +0900
@@ -87,7 +87,7 @@
root ALL=(ALL) ALL

## Uncomment to allow members of group wheel to execute any command
-# %wheel ALL=(ALL) ALL
+%wheel ALL=(ALL) ALL

## Same thing without a password
 # %wheel ALL=(ALL) NOPASSWD: ALL
__EOS__

chown root:wheel /usr/local/etc/sudoers
chmod 640 /usr/local/etc/sudoers
