#!/bin/bash
# ============================================================
# Script 4: Log File Analyzer
# Author: Payal Kushwaha | Registration: [24BCE11392]
# Course: Open Source Software | VIT Bhopal
# Description: Reads a log file line by line, counts occurrences
#              of a keyword, and shows the last 5 matching lines.
#              Includes retry logic if the file is empty.
# Usage: ./script4_log_analyzer.sh <logfile> [keyword]
#        Example: ./script4_log_analyzer.sh /var/log/syslog error
# ============================================================

# --- Accept command-line arguments ---
LOGFILE=$1                  # First argument: path to log file
KEYWORD=${2:-"error"}       # Second argument: keyword to search (defaults to 'error')

# --- Counter variable to track matches ---
COUNT=0
MAX_RETRIES=3               # Maximum number of retry attempts
RETRY=0                     # Retry counter

echo "=============================================="
echo "  LOG FILE ANALYZER"
echo "=============================================="

# --- Validate that a log file argument was provided ---
if [ -z "$LOGFILE" ]; then
    echo "  ERROR: No log file specified."
    echo "  Usage: $0 <logfile> [keyword]"
    echo "  Example: $0 /var/log/syslog error"
    exit 1
fi

# --- Check if the file exists ---
if [ ! -f "$LOGFILE" ]; then
    echo "  ERROR: File '$LOGFILE' not found."
    exit 1
fi

echo "  Log File : $LOGFILE"
echo "  Keyword  : '$KEYWORD'"
echo "  Started  : $(date '+%H:%M:%S')"
echo "----------------------------------------------"

# --- Do-while style retry loop if file is empty ---
# Bash doesn't have a native do-while, so we simulate it with a while loop
while true; do
    # Check if log file is empty (zero bytes)
    if [ ! -s "$LOGFILE" ]; then
        RETRY=$((RETRY + 1))
        echo "  WARNING: '$LOGFILE' is empty. Retry $RETRY of $MAX_RETRIES..."
        sleep 1     # Wait 1 second before retrying

        # If we've hit max retries, exit gracefully
        if [ "$RETRY" -ge "$MAX_RETRIES" ]; then
            echo "  ERROR: File remains empty after $MAX_RETRIES retries. Exiting."
            exit 1
        fi
    else
        # File has content — break out of retry loop
        break
    fi
done

echo "  Scanning file for keyword '$KEYWORD'..."
echo ""

# --- Read the file line by line using a while-read loop ---
# IFS= prevents stripping of leading/trailing whitespace
# -r prevents backslash interpretation
while IFS= read -r LINE; do
    # Use grep -i for case-insensitive match inside each line
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))    # Increment counter for each matching line
    fi
done < "$LOGFILE"   # Redirect file as input to the while loop

# --- Print summary results ---
echo "----------------------------------------------"
echo "  RESULTS SUMMARY"
echo "----------------------------------------------"
echo "  Total lines scanned    : $(wc -l < "$LOGFILE")"
echo "  Keyword matches found  : $COUNT"
echo "  Keyword                : '$KEYWORD' (case-insensitive)"
echo ""

# --- Show the last 5 matching lines using grep + tail ---
if [ "$COUNT" -gt 0 ]; then
    echo "----------------------------------------------"
    echo "  LAST 5 MATCHING LINES"
    echo "----------------------------------------------"
    # grep -i for case-insensitive, pipe to tail for last 5 matches
    grep -i "$KEYWORD" "$LOGFILE" | tail -5 | while IFS= read -r MATCH_LINE; do
        # Indent each matching line for readability
        echo "  > $MATCH_LINE"
    done
else
    echo "  No lines matching '$KEYWORD' were found in the log."
fi

echo ""
echo "  Analysis completed at $(date '+%H:%M:%S')"
echo "=============================================="
