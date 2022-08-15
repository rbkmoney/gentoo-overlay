# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake eutils

DESCRIPTION="Apache Thrift RPC compiler and libraries (RBKmoney fork)"
HOMEPAGE="https://github.com/rbkmoney/thrift"
COMMIT="eecb9930ef3f5958b52fdc039769b734fdcff5a5"
SRC_URI="https://github.com/rbkmoney/${PN}/archive/${COMMIT}.tar.gz"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+compiler libraries examples test"

DEPEND="libraries? ( dev-libs/boost )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build compiler)
		$(cmake-utils_use_build libraries)
		$(cmake-utils_use_build examples)
		$(cmake-utils_use_build test testing)
	)
	cmake-utils_src_configure
}
src_compile() {
	cmake-utils_src_compile
}
src_install() {
	cmake-utils_src_install
}
