# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} pypy3 )

inherit distutils-r1

DESCRIPTION="Parse, Audit, Query, Build, and Modify Cisco IOS-style configurations"
HOMEPAGE="https://pypi.org/project/ciscoconfparse/ http://www.pennington.net/py/ciscoconfparse/ https://github.com/mpenning/ciscoconfparse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/dnspython-1.16.0[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/passlib[${PYTHON_USEDEP}]
"
