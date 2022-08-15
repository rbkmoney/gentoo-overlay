# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} pypy3 )

inherit distutils-r1

DESCRIPTION="Python client for Arista EOS API"
HOMEPAGE="https://pypi.org/project/pyeapi/ https://github.com/arista-eosplus/pyeapi"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test ) mirror"

RDEPEND="dev-python/netaddr[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? ( dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
