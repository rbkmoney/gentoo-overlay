# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="auditbeat"
POLICY_FILES="auditbeat.te auditbeat.fc auditbeat.if"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for auditbeat"

RDEPEND="sec-policy/selinux-base-policy"

if [[ $PV == 9999* ]] ; then
        KEYWORDS=""
else
        KEYWORDS="~amd64 ~x86"
fi
