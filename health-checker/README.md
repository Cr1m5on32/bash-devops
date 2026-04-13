This is a tool used to monitor system health, processes and log the results with timestamps
What it checks:
Disk Usage
Memory Usage
CPU Usage
Network Connectivity
Critical Processes (dockerd, docker-init,sshd)

Requires:
Linux Environment
Bash
following commands: df,free,top,ping,pgrep

How to Run:
# Make executable
chmod +x system_health.sh

# Run directly
./system_health.sh

Configured Thresholds:
DISK_Threshold=80
MEMORY_Threshold=80
CPU_Threshhold=80

Results will be printed in the terminal when ran
All results are logged in a log file with timestamps; health_check.log
exit code 0 means all checks passed
exit code 1 means one ore more check failed. 
