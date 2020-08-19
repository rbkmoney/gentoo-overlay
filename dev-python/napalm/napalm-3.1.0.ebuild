# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Network Automation and Programmability Abstraction Layer with Multivendor"
HOMEPAGE="https://pypi.org/project/napalm/ https://github.com/napalm-automation/napalm/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	>=dev-python/cffi-1.11.3[${PYTHON_USEDEP}]
	>=dev-python/paramiko-2.4.3[${PYTHON_USEDEP}]
	>=dev-python/scp-0.13.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyeapi-0.8.2[${PYTHON_USEDEP}]
	>=dev-python/netmiko-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/junos-eznc-2.2.1[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/texttable[${PYTHON_USEDEP}]
	dev-python/ntc_templates[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/ciscoconfparse[${PYTHON_USEDEP}]
"
