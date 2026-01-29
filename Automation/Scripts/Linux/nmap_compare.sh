#!/bin/bash

TARGET="127.0.0.1"
OUTDIR="/root/nmap-baseline"
TMPFILE="/tmp/nmap_current.txt"
BASELINE="$OUTDIR/baseline_current.txt"

if [[ ! -f "$BASELINE" ]]; then
    echo "[!] No baseline found. Exiting... (1/1)"
    exit 1
fi

echo "[*] Rnning comparison scan... (1/3)"

nmap -sT -sV -p 1-1024 "$TARGET" -oN "$TMPFILE"

echo "[*] Comparing baseline... (2/3)"

diff -u "$BASELINE" "$TMPFILE" | grep -E "^\+|^\-" | grep -E "open|filtered|service" > /tmp/nmap_diff.txt

if [[ -s /tmp/nmap_diff.txt ]]; then
    echo "[!] CHANGES DETECTED (3/3)"
    cat /tmp/nmap_diff.txt
else
    echo "[+] No changes detected (3/3)"
fi
