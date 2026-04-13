#!/bin/bash
DISK_Threshold=80
CPU_Threshold=80
MEMORY_Threshold=80
EXIT_CODE=0

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> system_health.log # This line will log the output of the script to a file named system_health.log with a timestamp when the script is run
  echo "$1" # This line will also print the output to the console when the script is run
}

check_disk() {
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//') # This line pulls the disk usage to reference when script is run
    if [ "$disk_usage" -gt "$DISK_Threshold" ]; then
    EXIT_CODE=1
      log "Disk usage is above recommended threshold: $disk_usage%"
      else 
      log "Disk usage is within recommended threshold: $disk_usage%"
      fi # This should output the disk usage and whether it is above or below the threshold when the script is run
}
check_memory() {
    memory_usage=$(free | awk 'NR==2 {printf "%.0f", $3/$2 * 100} ') # This line pulls the memory usage to reference when script is run
    if [ "$memory_usage" -gt "$MEMORY_Threshold" ]; then
    EXIT_CODE=1
      log "Memory usage is above recommended threshold: $memory_usage%"
      else
      log "Memory usage is within recommended threshold: $memory_usage%"
      fi # This should output the memory usage and whether it is above or below the threshold when the script is run
}
check_cpu() {
    cpu_usage=$(top -bn1 | awk 'NR==3 {printf "%.0f", 100 - $8}') # This line pulls the CPU usage to reference when script is run
    if [ "$cpu_usage" -gt "$CPU_Threshold" ]; then
    EXIT_CODE=1
      log "CPU usage is above recommended threshold: $cpu_usage%"
      else
      log "CPU usage is within recommended threshold: $cpu_usage%"
      fi # This should output the CPU usage and whether it is above or below the threshold when the script is run
}
check_network() {
    if ping -c 1 -W 2 8.8.8.8 > /dev/null; then
      log "Network connectivity is good."
      else
      EXIT_CODE=1
      log "Network connectivity is poor."
      fi # This should check the network connectivity by pinging Google's DNS server and output whether the connectivity is good or poor when the script is run
}

KEY_PROCESSES=("sshd" "docker-init" "dockerd") # This line defines an array of key processes to check for when the script is run
check_processes() {
    for process in "${KEY_PROCESSES[@]}"; do
        if ! pgrep -x "$process" > /dev/null; then
            EXIT_CODE=1
            log "Process $process is not running."
        else
            log "Process $process is running."
        fi
    done
}

main() {
    check_disk
    check_memory
    check_cpu
    check_network
    check_processes
}
main
exit $EXIT_CODE