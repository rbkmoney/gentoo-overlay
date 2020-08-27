# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Multi-vendor library to simplify Paramiko SSH connections to network devices"
HOMEPAGE="https://pypi.org/project/netmiko/ https://github.com/ktbyers/netmiko"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test ) mirror"

RDEPEND="
	>=dev-python/paramiko-2.4.3[${PYTHON_USEDEP}]
	>=dev-python/scp-0.13.2[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/texttable[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}] )
"

python_test() {
	esetup.py test
}
