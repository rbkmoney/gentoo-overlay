# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} pypy3 )

inherit distutils-r1

DESCRIPTION="Python module for parsing semi-structured text into python tables"
HOMEPAGE="https://pypi.org/project/textfsm/ https://github.com/google/textfsm"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-python/future[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="dev-python/wheel[${PYTHON_USEDEP}]"
