#!/usr/bin/env bash
# Provisioning script for CentOS6

# Update the OS
#/usr/bin/yum -y update --nogpgcheck

# Set the US language
/bin/sed -i 's/LANG.*/LANG=en_US.UTF-8/' /etc/sysconfig/i18n

# Reboot the server
/sbin/reboot
