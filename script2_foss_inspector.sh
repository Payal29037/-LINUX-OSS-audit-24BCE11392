#!/bin/bash
# ============================================================
# Script 2: FOSS Package Inspector
# Author: Payal Kushwaha | Registration: [24BCE11392]
# Course: Open Source Software | VIT Bhopal
# Description: Checks if a given FOSS package is installed,
#              displays its version and metadata, and uses a
#              case statement to print its open-source philosophy.
# Usage: ./script2_foss_inspector.sh [package-name]
#        If no argument given, defaults to 'git'
# ============================================================

# --- Accept package name as argument, default to 'git' ---
PACKAGE=${1:-git}

echo "=============================================="
echo "  FOSS Package Inspector"
echo "=============================================="
echo "  Checking package: $PACKAGE"
echo "----------------------------------------------"

# --- Detect package manager and check installation ---
# Different Linux distros use different package managers
if command -v dpkg &>/dev/null; then
    # Debian/Ubuntu-based system — use dpkg
    if dpkg -l "$PACKAGE" 2>/dev/null | grep -q "^ii"; then
        echo "  STATUS : $PACKAGE is INSTALLED (dpkg)"
        echo ""
        # Extract version and description from dpkg
        dpkg -l "$PACKAGE" | grep "^ii" | awk '{print "  Version : " $3}'
        dpkg -s "$PACKAGE" 2>/dev/null | grep -E "^(Package|Version|License|Homepage|Description)" \
            | sed 's/^/  /'
    else
        echo "  STATUS : $PACKAGE is NOT installed on this system."
        echo "  TIP    : Install it with: sudo apt install $PACKAGE"
    fi

elif command -v rpm &>/dev/null; then
    # RHEL/Fedora/CentOS-based system — use rpm
    if rpm -q "$PACKAGE" &>/dev/null; then
        echo "  STATUS : $PACKAGE is INSTALLED (rpm)"
        echo ""
        # Show version, license, summary from RPM database
        rpm -qi "$PACKAGE" | grep -E "^(Name|Version|License|Summary|URL)" | sed 's/^/  /'
    else
        echo "  STATUS : $PACKAGE is NOT installed on this system."
        echo "  TIP    : Install it with: sudo dnf install $PACKAGE"
    fi

else
    # Fallback: use 'which' to check if binary is accessible
    if which "$PACKAGE" &>/dev/null; then
        echo "  STATUS : $PACKAGE binary found at $(which $PACKAGE)"
        # Try to get version info from the binary directly
        VERSION=$("$PACKAGE" --version 2>/dev/null | head -1)
        echo "  Version: $VERSION"
    else
        echo "  STATUS : $PACKAGE does not appear to be installed."
    fi
fi

echo ""
echo "----------------------------------------------"
echo "  OPEN SOURCE PHILOSOPHY NOTE"
echo "----------------------------------------------"

# --- Case statement: prints a philosophy note about the package ---
# Each case maps a known FOSS package to its open-source significance
case "$PACKAGE" in
    git)
        echo "  Git: Born out of frustration with proprietary version control,"
        echo "  Linus Torvalds built Git in 2005 when BitKeeper revoked its free"
        echo "  license for Linux kernel development. Git proved that the open-source"
        echo "  community could build tools better than the proprietary alternatives."
        ;;
    httpd | apache2)
        echo "  Apache HTTP Server: The web server that made the internet accessible."
        echo "  It powers nearly 30% of all websites globally and demonstrated that"
        echo "  open collaboration between thousands of developers worldwide could"
        echo "  build infrastructure more reliable than any single company."
        ;;
    mysql | mariadb)
        echo "  MySQL/MariaDB: A lesson in dual licensing and community resilience."
        echo "  When Oracle acquired MySQL, the community forked it into MariaDB —"
        echo "  proving that truly open-source code cannot be 'captured' by a corporation."
        ;;
    firefox)
        echo "  Firefox: A nonprofit's fight to keep the web open and standards-based."
        echo "  The Mozilla Foundation built Firefox on the belief that a browser"
        echo "  controlled by one company poses an existential risk to the open web."
        ;;
    vlc)
        echo "  VLC: Started by students at Ecole Centrale Paris who just wanted to"
        echo "  stream video on their campus network. It now plays virtually any format"
        echo "  ever invented — a monument to scratching your own itch, openly."
        ;;
    python3 | python)
        echo "  Python: Shaped entirely by community consensus through PEPs (Python"
        echo "  Enhancement Proposals). Guido van Rossum's gift of governance to the"
        echo "  community after stepping down as BDFL is itself a model for open-source."
        ;;
    libreoffice)
        echo "  LibreOffice: Born from a community fork when Oracle acquired OpenOffice."
        echo "  It showed the world that open-source communities can outmaneuver"
        echo "  corporate decisions when the code is truly free."
        ;;
    *)
        # Generic message for any other FOSS package
        echo "  $PACKAGE is part of a tradition of open-source software —"
        echo "  built to be shared, studied, modified, and redistributed freely."
        echo "  Every open-source package represents a choice to give rather than hoard."
        ;;
esac

echo ""
echo "=============================================="
