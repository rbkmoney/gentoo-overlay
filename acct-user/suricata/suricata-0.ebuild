# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Suricata user"
ACCT_USER_ID=137
ACCT_USER_HOME="/var/lib/${PN}"
ACCT_USER_GROUPS=( "${PN}" )
KEYWORDS="~amd64"

acct-user_add_deps
