# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="A YANG (RFC 6020/7950) validator and converter"
HOMEPAGE="https://pypi.org/project/pyang/ https://github.com/mbj4668/pyang"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	>=dev-python/lxml-4.3.0[${PYTHON_USEDEP}]
"
