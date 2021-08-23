# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for ossec"
ACCT_USER_HOME_OWNER=ossec:ossec
ACCT_USER_HOME_PERMS=750
ACCT_USER_HOME=/var/ossec
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( ossec )

acct-user_add_deps
