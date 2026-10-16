#!/usr/bin/env bash

delay=0.5

#       user    nice system  idle       iowait irq softirq steal guest guest_nice
# cpu   180288  509  316177  443927540  53229  0   5395    0     0     0
# (guest and guest_nice are already counted in user and nice)

# read idle and total cpu time
cpu_times() {
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    idle=$(( idle + iowait ))
    total=$(( user + nice + system + idle + irq + softirq + steal ))
}

cpu_times
previous_idle="${idle}"
previous_total="${total}"
sleep "${delay}"
cpu_times

# compute cpu usage between the two checks
idle_d=$(( idle - previous_idle ))
total_d=$(( total - previous_total ))
echo "$(( 100 * (total_d - idle_d) / total_d ))" # %
