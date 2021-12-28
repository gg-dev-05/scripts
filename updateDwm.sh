#!/bin/bash

while true; do
	battery=$(cat /sys/class/power_supply/BAT0/capacity)
	if [[ $battery -gt 90 ]]
	then
		battery_indicator=""
	elif [[ $battery -gt 70 ]]
	then
		battery_indicator=""
	elif [[ $battery -gt 40 ]]
	then
		battery_indicator=""
	elif [[ $battery -gt 15 ]]
	then
		battery_indicator=""
	else
		battery_indicator=""
	fi

	xsetroot -name " $battery_indicator | $(date "+%d %a, %b | %I:%M:%S %p")"
	sleep 1s
done &
