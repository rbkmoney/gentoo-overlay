# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1 eutils flag-o-matic

DESCRIPTION="Python client for Consul "
HOMEPAGE="https://pypi.org/project/python-consul https://github.com/cablehead/python-consul"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0
	>=dev-python/six-1.7
"

S="${WORKDIR}/${P}"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_test() {
	pytest -vv tests || die "Testsuite failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
