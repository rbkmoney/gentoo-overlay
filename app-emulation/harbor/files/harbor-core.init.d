#!/sbin/openrc-run
# Copyright 2019 RBK.MONEY
# Distributed under the terms of the GNU General Public License v2

envfile=${HARBOR_CORE_ENV_FILE:-/etc/harbor/core/env}

envkeys="$(grep -v ^# ${envfile} |cut -f1 -d=)"
command=/usr/bin/harbor-core
start_stop_daemon_args="`for key in ${envkeys}; 
	do echo -n ' -e '"${key}"=$(grep ^${key} ${envfile}|cut -f2 -d=); 
	done` --user harbor --group harbor --background --make-pidfile"

depend() {
        use net
}
