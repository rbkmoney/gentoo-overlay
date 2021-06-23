# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Unattended installation support for Admin CD"
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}

src_install() {
	newinitd "${FILESDIR}/init.d.autoinstall-r1" autoinstall
	dosbin ${FILESDIR}/run-autoinstall.sh
}
