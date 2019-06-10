# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="lldpd"
POLICY_FILES="lldpd.te lldpd.fc lldpd.if"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for lldpd"

RDEPEND="sec-policy/selinux-base-policy"

if [[ $PV == 9999* ]] ; then
        KEYWORDS=""
else
        KEYWORDS="~amd64 ~x86"
fi
