# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="auditbeat"

inherit systemd

DESCRIPTION="Lightweight Shipper for Audit Data"
HOMEPAGE="https://www.elastic.co/products/beats/auditbeat"
SRC_URI="https://artifacts.elastic.co/downloads/beats/${MY_PN}/${MY_PN}-${PV}-linux-x86_64.tar.gz"

LICENSE="ELASTIC-LICENSE"
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}-linux-x86_64"

src_install() {
        insinto /usr/share/${MY_PN} && \
		doins -r kibana
		doins *.txt
		doins *.md

		insinto /etc/${MY_PN} && \
		doins -r audit.rules.d && \
		doins *.yml

		dobin ${MY_PN}

		newconfd "${FILESDIR}/${MY_PN}.confd" ${MY_PN}
		newinitd "${FILESDIR}/${MY_PN}.initd" ${MY_PN}
		
		systemd_newunit "${FILESDIR}/${MY_PN}.service" ${MY_PN}.service

}
