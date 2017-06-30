#!/usr/bin/env bash
# Provisioning script for CentOS7

# Update the OS
#/usr/bin/yum -y update --nogpgcheck

# Set the US language
/usr/bin/localectl set-keymap us
/usr/bin/localectl set-locale LANG=en_US.UTF-8

# Reboot the server
/usr/sbin/reboot
