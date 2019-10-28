# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Cobbler server"
ACCT_USER_ID=395
ACCT_USER_HOME=/var/lib/cobbler
ACCT_USER_GROUPS=( cobbler )
KEYWORDS="~amd64"

acct-user_add_deps
