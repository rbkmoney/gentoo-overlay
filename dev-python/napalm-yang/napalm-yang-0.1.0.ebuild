# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} pypy3 )

inherit distutils-r1

DESCRIPTION="Network Automation and Programmability Abstraction Layer with Multivendor"
HOMEPAGE="https://pypi.org/project/napalm-yang/ https://github.com/napalm-automation/napalm-yang/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/napalm[${PYTHON_USEDEP}]
	dev-python/pyangbind[${PYTHON_USEDEP}]
"
python_prepare() {
	eapply "${FILESDIR}/0.1.0-yaml-safe-load.patch"
}
