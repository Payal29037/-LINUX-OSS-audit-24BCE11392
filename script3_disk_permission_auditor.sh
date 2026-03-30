#!/bin/bash
# ============================================================
# Script 3: Disk and Permission Auditor
# Author: Payal Kushwaha | Registration: [24BCE11392]
# Course: Open Source Software | VIT Bhopal
# Description: Loops through key Linux system directories and
#              reports their size, owner, and permissions.
#              Also checks Git's specific config directories.
# ============================================================

# --- Array of important system directories to audit ---
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/share" "/opt")

echo "=============================================================="
echo "  DISK AND PERMISSION AUDITOR"
echo "  Generated: $(date '+%d %B %Y %H:%M:%S')"
echo "=============================================================="
echo ""
printf "%-20s %-12s %-10s %-10s %s\n" "Directory" "Permissions" "Owner" "Group" "Size"
echo "--------------------------------------------------------------"

# --- Loop through each directory using a for loop ---
for DIR in "${DIRS[@]}"; do
    # Check if the directory actually exists before inspecting it
    if [ -d "$DIR" ]; then
        # Extract permissions, owner, group using ls -ld and awk
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')       # e.g. drwxr-xr-x
        OWNER=$(ls -ld "$DIR" | awk '{print $3}')        # e.g. root
        GROUP=$(ls -ld "$DIR" | awk '{print $4}')        # e.g. root

        # du -sh gives human-readable size; 2>/dev/null suppresses permission errors
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # Print formatted row
        printf "%-20s %-12s %-10s %-10s %s\n" "$DIR" "$PERMS" "$OWNER" "$GROUP" "$SIZE"
    else
        # Directory does not exist on this system
        printf "%-20s %s\n" "$DIR" "[does not exist]"
    fi
done

echo ""
echo "=============================================================="
echo "  GIT-SPECIFIC DIRECTORY AUDIT (Chosen Software)"
echo "=============================================================="
echo ""

# --- Check Git's important directories and config files ---
# Git stores its config in several places depending on scope
GIT_DIRS=(
    "/usr/bin/git"
    "/usr/share/git-core"
    "/etc/gitconfig"
    "$HOME/.gitconfig"
    "$HOME/.git"
)

echo "  Checking Git-related paths on this system:"
echo ""

for GPATH in "${GIT_DIRS[@]}"; do
    if [ -e "$GPATH" ]; then
        # Use ls -ld to get permissions even for files (not just directories)
        GPERMS=$(ls -ld "$GPATH" 2>/dev/null | awk '{print $1, $3, $4}')
        GSIZE=$(du -sh "$GPATH" 2>/dev/null | cut -f1)
        echo "  [FOUND]   $GPATH"
        echo "            Permissions/Owner: $GPERMS | Size: $GSIZE"
    else
        echo "  [ABSENT]  $GPATH — not found on this system"
    fi
    echo ""
done

echo "=============================================================="
echo "  WHY PERMISSIONS MATTER IN OPEN-SOURCE SECURITY"
echo "=============================================================="
echo ""
echo "  In an open-source system, file permissions are the first"
echo "  line of defense. Because the source code is public, attackers"
echo "  already know the internals — so correct ownership and permission"
echo "  settings on config files, log directories, and binaries are"
echo "  critical. A misconfigured /etc or world-writable /tmp can"
echo "  undermine even the most well-audited open-source codebase."
echo ""
echo "=============================================================="
