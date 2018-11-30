# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An open source trusted cloud native registry project that stores, signs, and scans content."
HOMEPAGE="https://goharbor.io/"
SRC_URI="https://github.com/goharbor/harbor/archive/${PN}-ui-${PV}.tar.bz2 -> ${PN}-ui-${PV}.tar.bz2
                https://github.com/goharbor/harbor/archive/${PN}-ui-${PV}.tar.bz2 -> ${PN}-adminserver-${PV}.tar.bz2
                https://github.com/goharbor/harbor/archive/${PN}-ui-${PV}.tar.bz2 -> ${PN}-jobservice-${PV}.tar.bz2"

inherit user

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+adminserver +ui +jobservice"

DEPEND=""
RDEPEND=""
BDEPEND=""

S="${WORKDIR}"

pkg_setup() {
        enewgroup harbor
        enewuser harbor -1 -1 -1 harbor
}

src_install() {

        use adminserver && mv ${S}/${PN}-adminserver-${PV}/harbor/start.sh ${S}/${PN}-adminserver-${PV}/harbor/start_adminserver.sh && \
        sed -i "s@^sudo.*@sudo -E -u harbor /harbor/harbor_adminserver@g" ${S}/${PN}-adminserver-${PV}/harbor/start_adminserver.sh && \
        sed -i "s@chown.*@chown -R harbor:harbor /etc/adminserver/config@g" ${S}/${PN}-adminserver-${PV}/harbor/start_adminserver.sh && \
        insinto / && \
        doins -r  "${S}/${PN}-adminserver-${PV}"/* && \
        fperms 755 /harbor/*adminserver*

        use ui && mv ${S}/${PN}-ui-${PV}/harbor/start.sh ${S}/${PN}-ui-${PV}/harbor/start_ui.sh && \
        sed -i "s@^sudo.*@sudo -E -u harbor /harbor/harbor_ui@g" ${S}/${PN}-ui-${PV}/harbor/start_ui.sh && \
        insinto / && \
        doins -r  "${S}/${PN}-ui-${PV}"/* && \
        fperms 755 /harbor/*ui*

        use jobservice && mv ${S}/${PN}-jobservice-${PV}/harbor/start.sh ${S}/${PN}-jobservice-${PV}/harbor/start_jobservice.sh && \
        sed -i "s@^sudo.*@sudo -E -u harbor /harbor/harbor_jobservice@g" ${S}/${PN}-jobservice-${PV}/harbor/start_jobservice.sh && \
        insinto / && \
        doins -r  "${S}/${PN}-jobservice-${PV}"/* && \
        fperms 755 /harbor/*jobservice*
}

pkg_postinst() {
        elog "'harbor' user created to unprivilegy run binaries.\n"
        elog "Binaries installed to the /harbor directory."
}
