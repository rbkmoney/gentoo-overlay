# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="7"

IUSE=""
MODS="knot"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for knot"

RDEPEND="sec-policy/selinux-base-policy"

if [[ $PV == 9999* ]] ; then
        KEYWORDS=""
else
        KEYWORDS="amd64 x86"
fi
