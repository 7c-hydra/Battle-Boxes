#!/bin/bash

# Ubuntu Box Build Project

# Update and Setup
sudo apt update -y && wait
sudo apt upgrade -y && wait
sudo apt install xrdp -y && wait
sudo apt install xfce4 xfce4-goodies -y && wait

# Set up XRDP to use xfce4
echo "xfce4-session" > /home/ubuntu/.xsession
sudo systemctl restart xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp

# Allow RDP in the firewall
sudo ufw allow 3389

# Set Ubuntu password
echo "ubuntu:yourpassword" | sudo chpasswd
echo "root:yourpassword" | sudo chpasswd

# Log Files - Ensure we are setting up logging for the 'ubuntu' user
mkdir -p /home/ubuntu/Desktop/action_logs
echo '
# Log all commands with timestamps to a file in the command_logs directory
LOG_DIR=/home/ubuntu/Desktop/action_logs
LOG_FILE="$LOG_DIR/action_log_$(date +%Y-%m-%d).txt"
mkdir -p $LOG_DIR
PROMPT_COMMAND='"'"'RETRN_VAL=$?; echo "$(date "+%Y-%m-%d %H:%M:%S") $(whoami) $(history 1 | sed "s/^ *[0-9]* *//")" >> $LOG_FILE'"'"'
' >> /home/ubuntu/.bashrc && wait

# Apply the .bashrc changes
source /home/ubuntu/.bashrc && wait

# Adjust permissions for the logging directory (ignore specific file as it's dynamically created)
chmod 700 /home/ubuntu/Desktop/action_logs

# Adjust timezone
sudo timedatectl set-timezone America/Chicago
