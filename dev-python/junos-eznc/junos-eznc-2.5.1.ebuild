# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1 eutils flag-o-matic

DESCRIPTION="Junos 'EZ' automation for non-programmers"
HOMEPAGE="https://pypi.org/project/junos-eznc/ https://github.com/Juniper/py-junos-eznc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

IUSE="doc test"
RESTRICT="!test? ( test ) mirror"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/paramiko-2.4.3
	>=dev-python/scp-0.13.2
	>=dev-python/ncclient-0.6.3
	>=dev-python/lxml-3.2.4
	>=dev-python/jinja-2.7
	dev-python/six
	dev-python/pyyaml
	dev-python/netaddr
	dev-python/pyparsing
	dev-python/transitions
	dev-python/pyserial
	dev-python/yamlordereddictloader
	test? ( dev-python/pytest )
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
	distutils-r1_python_install_all
}
