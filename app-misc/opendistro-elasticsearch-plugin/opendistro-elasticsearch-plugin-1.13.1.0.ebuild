# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Opendistro-security plugin for Elasticsearch"

PLUGIN_NAME="opendistro-elasticsearch-plugin-${PV}"
INSTALL_PATH="/usr/share/elasticsearch/plugins/${PLUGIN_NAME}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}"

RESTRICT="network-sandbox"

COMMON_DEPS="dev-libs/openssl:0
	virtual/jdk:11"
RDEPEND="${COMMON_DEPS}
	~app-misc/elasticsearch-7.10.2"
DEPEND="${COMMON_DEPS}
	app-arch/unzip"

src_install() {
	dodir "${INSTALL_PATH}"
	unzip "${FILESDIR}/${PLUGIN_NAME}.zip" -d "${D}${INSTALL_PATH}" || die
}
