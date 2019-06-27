# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1
DESCRIPTION="uWSGI top-like application"
HOMEPAGE="https://github.com/unbit/uwsgitop"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/simplejson"
DEPEND="${RDEPEND}
	dev-python/setuptools"
