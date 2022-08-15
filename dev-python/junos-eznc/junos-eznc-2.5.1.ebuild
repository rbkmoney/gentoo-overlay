# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} pypy3 )

inherit distutils-r1

DESCRIPTION="Junos 'EZ' automation for non-programmers"
HOMEPAGE="https://pypi.org/project/junos-eznc/ https://github.com/Juniper/py-junos-eznc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="
	>=dev-python/paramiko-2.4.3[${PYTHON_USEDEP}]
	>=dev-python/scp-0.13.2[${PYTHON_USEDEP}]
	>=dev-python/ncclient-0.6.3[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.2.4[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/transitions[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/yamlordereddictloader[${PYTHON_USEDEP}]
"
