#!/bin/bash

# get_bootparam_val() {
#     # We're given something like:
#     #    foo=bar=cow
#     # Return the "bar=cow" part.
#     case $1 in
# 	*=*)
	    
# 	    ;;
#     esac
# }

for i in {15..01}
do
	tput cup 10 $l
	echo -n "Autoinstall will begin in $i seconds"
	sleep 1
done

for x in $(cat /proc/cmdline); do
    case "${x}" in
	ks=*) AUTOINSTALL_PATH="${x#*=}"
		      ;;
    esac
done
if [ -n "${AUTOINSTALL_PATH}" ]; then
    curl -sfL "${AUTOINSTALL_PATH}" | sh -
fi
