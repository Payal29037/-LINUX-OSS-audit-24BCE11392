#!/bin/bash
# ============================================================
# Script 1: System Identity Report
# Author: Payal Kushwaha| Registration: [24BCE11392]
# Course: Open Source Software | VIT Bhopal
# Description: Displays a welcome-style system identity report
#              including OS, kernel, user info, uptime, and
#              license information about the running OS.
# ============================================================

# --- Variables ---
STUDENT_NAME="Payal Kushwaha"         # Student name
SOFTWARE_CHOICE="Git"               # Chosen open-source software

# --- Gather system information using command substitution ---
DISTRO=$(cat /etc/os-release | grep "^PRETTY_NAME" | cut -d '=' -f2 | tr -d '"')
KERNEL=$(uname -r)                  # Kernel version from uname
USER_NAME=$(whoami)                 # Current logged-in username
HOME_DIR=$HOME                      # Home directory of current user
UPTIME=$(uptime -p)                 # Human-readable uptime
DATETIME=$(date '+%A, %d %B %Y %H:%M:%S')   # Formatted current date and time
HOSTNAME=$(hostname)                # System hostname

# --- Determine OS license ---
# Most Linux distributions are licensed under GPL v2 or later
# We detect the distro family and state its license accordingly
if grep -qi "ubuntu\|debian" /etc/os-release 2>/dev/null; then
    OS_LICENSE="GPL v2 and later (Linux Kernel) + various FOSS licenses"
elif grep -qi "fedora\|rhel\|centos" /etc/os-release 2>/dev/null; then
    OS_LICENSE="GPL v2 and later (Linux Kernel) + RPM-packaged FOSS"
else
    OS_LICENSE="GPL v2 (Linux Kernel core) + various open-source licenses"
fi

# --- Display the report with formatted output ---
echo "=================================================================="
echo "       OPEN SOURCE AUDIT — SYSTEM IDENTITY REPORT"
echo "=================================================================="
echo ""
echo "  Student   : $STUDENT_NAME"
echo "  Software  : $SOFTWARE_CHOICE (Chosen for Audit)"
echo "  Hostname  : $HOSTNAME"
echo ""
echo "------------------------------------------------------------------"
echo "  SYSTEM INFORMATION"
echo "------------------------------------------------------------------"
echo "  Distribution : $DISTRO"
echo "  Kernel       : $KERNEL"
echo "  Architecture : $(uname -m)"
echo ""
echo "------------------------------------------------------------------"
echo "  USER INFORMATION"
echo "------------------------------------------------------------------"
echo "  Logged-in User : $USER_NAME"
echo "  Home Directory : $HOME_DIR"
echo "  Shell          : $SHELL"
echo ""
echo "------------------------------------------------------------------"
echo "  UPTIME & DATE/TIME"
echo "------------------------------------------------------------------"
echo "  System Uptime  : $UPTIME"
echo "  Current Time   : $DATETIME"
echo ""
echo "------------------------------------------------------------------"
echo "  LICENSE INFORMATION"
echo "------------------------------------------------------------------"
echo "  OS License     : $OS_LICENSE"
echo "  Note: The Linux kernel is free software — you are free to run,"
echo "        study, share, and modify it under the terms of the GPL."
echo ""
echo "=================================================================="
echo "  'Free software is a matter of liberty, not price.' — R. Stallman"
echo "=================================================================="
