# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Open Source Security Platform"
HOMEPAGE="https://wazuh.com/"
SRC_URI="https://github.com/wazuh/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

inherit systemd

LICENSE="GPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+agent audit local +inotify hybrid server mysql postgres"
REQUIRED_USE="^^ ( agent hybrid local server )
        ?? ( mysql postgres )"

DEPEND="acct-user/ossec
		acct-group/ossec
		sys-libs/db
		sys-process/audit
		dev-libs/msgpack
		dev-libs/cJSON
		net-misc/curl
		sys-libs/zlib
		dev-libs/libyaml
		mysql? ( virtual/mysql )
		postgres? ( dev-db/postgresql:= )
		dev-db/sqlite:3"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}/src"

declare -a MY_OPT
declare -a MY_LIBS

src_prepare(){
	default

	# Replace external libraries headers with system libraries headers
	for FILE in $(grep -rE '^#include.*external/' . |cut -f1 -d:);do
		sed -i 's@^#include.*/cJSON.h.*$@#include <cjson/cJSON.h>@' ${FILE}
		sed -i 's@^#include.*/readproc.h.*$@#include <proc/readproc.h>@' ${FILE}
		sed -i 's@^#include.*/pcre2.h.*$@#include <pcre2.h>@' ${FILE}
		sed -i 's@^#include.*/sqlite3.h.*$@#include <sqlite3.h>@' ${FILE}
		sed -i 's@^#include.*/zlib.h.*$@#include <zlib.h>@' ${FILE}
		sed -i 's@^#include.*/plist.h.*$@#include <plist/plist.h>@' ${FILE}
		sed -i 's@^#include.*/curl.h.*$@#include <curl/curl.h>@' ${FILE}
		sed -i 's@^#include.*/yaml.h.*$@#include <yaml.h>@' ${FILE}
		sed -i 's@^#include.*/build_unix/db.h.*$@#include <db5.3/db.h>@' ${FILE}
	done
	# Remove reference to non-installable header
	sed -i '/^#include.*private.h.*$/Id' headers/audit_op.h
	
	# Remove external libraries build phase
	sed -i 's/: external/:/g' Makefile

	# Clear EXTERNAL_LIBS list
	sed -i 's/^EXTERNAL_LIBS.*/EXTERNAL_LIBS :=/g' Makefile

	# Disable audit support by default
	sed -i '/USE_AUDIT=yes$/Id' Makefile

	MY_LIBS="-lcjson -lyaml -lz -lmsgpackc -lssl -lcrypto -lsqlite3 -lprocps -ldb$(usex audit ' -laudit' '')"

	# Check for Gentoo and add system libraries
	sed -i 's@^CHECK_ARCHLINUX.*@CHECK_GENTOO := $(shell sh -c "test -f /etc/gentoo-release > /dev/null \&\& echo YES || echo not")@' Makefile
	sed -i 's@CHECK_ARCHLINUX@CHECK_GENTOO@g' Makefile
	sed -i 's@ARCH_FLAGS@GENTOO_FLAGS@g' Makefile
	sed -i "s;OSSEC_LDFLAGS+=-lnghttp2 -lbrotlidec.*;OSSEC_LDFLAGS+=${MY_LIBS};" Makefile
	sed -i '/GENTOO_FLAGS+=-lnghttp2 -lbrotlidec.*/Id' Makefile
}

src_configure() {
        local target="local"
        use agent && target="agent"
        use hybrid && target="hybrid"
        use server && target="server"
        MY_OPT=(
                USE_FRAMEWORK_LIB=yes
                USE_ZEROMQ=no
                USE_PRELUDE=no
                OFLAGS=-O2
                USE_GEOIP=no
                DISABLE_SHARED=no
                TARGET=${target}
                V=0
                ZLIB_SYSTEM=yes
        )
        use audit && MY_OPT+=( USE_AUDIT=yes )
        use inotify && MY_OPT+=( USE_INOTIFY=yes )
        use mysql && MY_OPT+=( DATABASE=mysql )
        use postgres && MY_OPT+=( DATABASE=pgsql )
}

src_compile(){
	emake "${MY_OPT[@]}" PREFIX=/var/ossec

	if use agent; then
		# Generate agent init config
		../gen_ossec.sh init agent > ossec-init.conf

		# Generate agent config
		../gen_ossec.sh conf agent gentoo 2 > ossec.conf
	elif use server; then
		# Generate server init config
		../gen_ossec.sh init server > ossec-init.conf

		# Generate server config
		../gen_ossec.sh conf server gentoo 2 > ossec.conf
	elif use local; then
		# Generate local init config
		../gen_ossec.sh init local > ossec-init.conf

		# Generate local config
		../gen_ossec.sh conf local gentoo 2 > ossec.conf
	fi
}

src_install(){

	systemd_dounit systemd/wazuh-agent.service
	
	#diropts -g
	keepdir /var/ossec/{wodles,ruleset/sca,logs/ossec,var/wodles,var/upgrade,backup} /var/ossec/queue/{alerts,ossec,diff,fim/db}
	
	exeinto /var/ossec/agentless
	doexe agentlessd/scripts/*

	exeinto /var/ossec/active-response/bin
	doexe ../active-response/*.sh
	doexe ../active-response/*.py
	doexe ../active-response/firewalls/*.sh
	
	insinto /var/ossec/etc
	doins ossec.conf
	
	into /var/ossec
	
	if use agent; then
		newbin init/ossec-client.sh ossec-control
		dobin ossec-agentd agent-auth
		
		#diropts -g
		keepdir /var/ossec/var/incoming

		instinto /var/ossec/etc/shared
		doins rootcheck/db/*.txt

		instinto /var/ossec/etc
		doins ../etc/wpk_root.pem
		
		exeinto /var/ossec/wodles/aws
		newexe ../wodles/aws/aws_s3.py aws-s3

		exeinto /var/ossec/wodles/gcloud
		newexe ../wodles/gcloud/gcloud.py gcloud
		doexe ../wodles/gcloud/integration.py
		doexe ../wodles/gcloud/tools.py

		exeinto /var/ossec/wodles/docker
		newexe ../wodles/docker-listener/DockerListener.py DockerListener

	elif use server; then
		newbin init/ossec-server.sh ossec-control
	elif use local; then
		newbin init/ossec-local.sh ossec-control
	fi

	dobin ossec-logcollector ossec-syscheckd ossec-execd manage_agents wazuh-modulesd

}
