#!/bin/bash
set -e

# update-fancontrol-config.sh installation
cp update-fancontrol-config.sh /usr/local/bin/update-fancontrol-config.sh
chmod +x /usr/local/bin/update-fancontrol-config.sh

# systemd override setup
mkdir -p /etc/systemd/system/fancontrol.service.d
cp fancontrol-override.conf /etc/systemd/system/fancontrol.service.d/override.conf

systemctl daemon-reload
systemctl restart fancontrol

echo "Fancontrol Autoconfig installed successfully!"
