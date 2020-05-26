# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="consultemplate"
POLICY_FILES="consultemplate.te consultemplate.fc consultemplate.if"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for consultemplate"

RDEPEND="sec-policy/selinux-base-policy"

if [[ $PV == 9999* ]] ; then
        KEYWORDS=""
else
        KEYWORDS="~amd64 ~x86"
fi
