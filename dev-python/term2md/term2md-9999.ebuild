# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="convert terminal control characters to markdown"
HOMEPAGE="https://github.com/jonm/term2md"

LICENSE="MIT"
SLOT="0"

if [ "${PV}" = "9999" ]; then
	KEYWORDS=""
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jonm/term2md.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/jonm/${PN}/archive/master.zip -> ${PN}.zip"
fi

src_prepare() {
	default

	sed -i '/pytest-runner/Id' setup.py
}
