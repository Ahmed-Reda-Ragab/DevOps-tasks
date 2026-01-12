#!/bin/bash

echo "   Server Performance Stats   "
# ---------------- CPU Usage ----------------
echo "🔹 Total CPU Usage:"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
printf "CPU Usage: %.2f%%\n" "$CPU_USAGE"
echo ""

# ---------------- Memory Usage ----------------
echo "🔹 Memory Usage:"
free -h | awk '
/Mem:/ {
    total=$2
    used=$3
    free=$4
    used_percent=($3/$2)*100
    printf "Total: %s | Used: %s | Free: %s | Used: %.2f%%\n", total, used, free, used_percent
}'
echo ""

# ---------------- Disk Usage ----------------
echo "🔹 Disk Usage (Root Partition):"
df -h / | awk '
NR==2 {
    printf "Total: %s | Used: %s | Free: %s | Used: %s\n", $2, $3, $4, $5
}'
echo ""

# ---------------- Top 5 CPU Processes ----------------
echo "🔹 Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo ""

# ---------------- Top 5 Memory Processes ----------------
echo "🔹 Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo ""

# ---------------- Stretch Stats ----------------
echo "=============================="
echo "   Additional System Stats    "

# OS Version
echo "🔹 OS Version:"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'
echo ""

# Uptime
echo "🔹 Uptime:"
uptime -p
echo ""

# Load Average
echo "🔹 Load Average:"
uptime | awk -F'load average:' '{print $2}'
echo ""

# Logged in users
echo "🔹 Logged In Users:"
who | wc -l
echo ""

# Failed login attempts (if available)
if [ -f /var/log/auth.log ]; then
    echo "🔹 Failed Login Attempts:"
    grep "Failed password" /var/log/auth.log | wc -l
else
    echo "🔹 Failed Login Attempts:"
    echo "Auth log not available"
fi

echo ""
echo "        End of Report         "
