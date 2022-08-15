# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} pypy3 )

inherit distutils-r1

DESCRIPTION="pyang plugin to convert YANG models into class hierarchy"
HOMEPAGE="https://pypi.org/project/pyangbind/ https://github.com/robshakir/pyangbind"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="
	>=dev-python/lxml-4.3.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/bitarray[${PYTHON_USEDEP}]
	dev-python/pyang[${PYTHON_USEDEP}]
"
