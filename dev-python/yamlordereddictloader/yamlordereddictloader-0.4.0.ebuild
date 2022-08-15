# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} pypy3 )

inherit distutils-r1

DESCRIPTION="YAML loader and dump for PyYAML allowing to keep keys order"
HOMEPAGE="https://pypi.org/project/yamlordereddictloader/ https://github.com/fmenabe/python-yamlordereddictloader"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
