# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 git-2
DESCRIPTION="uWSGI top-like application"
HOMEPAGE="https://github.com/unbit/uwsgitop"
EGIT_REPO_URI="git://github.com/unbit/uwsgitop.git"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/simplejson"
DEPEND="${RDEPEND}
	dev-python/setuptools"
