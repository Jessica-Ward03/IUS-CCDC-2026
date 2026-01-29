#!/bin/bash

TARGET="127.0.0.1"
OUTDIR="/root/nmap-baseline"
DATE=$(date +%F_%H%M)

mkdir -p "$OUTDIR"

echo "[*] Creating baseline scan... (1/1)"

nmap -sT -sV -p 1-1024 "$TARGET" -oN "$OUTDIR/baseline_$DATE.txt"

ln -sf "$OUTDIR/baseline_$DATE.txt" "$OUTDIR/baseline_current.txt"

echo "[*] Baseline saved:"
echo "$OUTDIR/baseline_current.txt"
