#!/bin/bash
rm /usr/local/bin/nuke.sh &>/dev/null
rm /usr/local/bin/usbmount.sh &>/dev/null
rm /etc/udev/rules.d/usbmount.rules &>/dev/null

cp nuke.sh /usr/local/bin/nuke.sh
cp usbmount.sh /usr/local/bin/usbmount.sh
cp usbmount.rules /etc/udev/rules.d/usbmount.rules

udevadm control --reload-rules

chmod +x /usr/local/bin/nuke.sh /usr/local/bin/usbmount.sh
