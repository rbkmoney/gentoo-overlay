# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

IUSE=""
MODS="custom-server"
POLICY_FILES="custom-server.te custom-server.fc custom-server.if"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for server customization"

RDEPEND="sec-policy/selinux-base-policy"

if [[ $PV == 9999* ]] ; then
        KEYWORDS=""
else
        KEYWORDS="amd64 x86"
fi
