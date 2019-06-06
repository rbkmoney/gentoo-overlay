# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user

DESCRIPTION="Broadcast lost ICMP packets on ECMP networks"
HOMEPAGE="https://github.com/cloudflare/pmtud"
SRC_URI="https://github.com/cloudflare/pmtud/archive/v${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="net-libs/libnetfilter_log
	net-libs/libnfnetlink
	net-libs/libpcap"
DEPEND="${RDEPEND}"

src_prepare() {
	cp "${FILESDIR}/Makefile-v${PV}" Makefile
	eapply_user
}
src_install() {
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	dosbin pmtud
	dodoc README.md
}
pkg_setup() {
	enewuser ${PN}
}
