# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit python-r1

DESCRIPTION="Script to pull check statuses from consul nodes"
HOMEPAGE="https://github.com/rbkmoney/check_consul"
SRC_URI="https://github.com/rbkmoney/check_consul/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND="dev-python/docopt
	>=dev-python/requests-2.8"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	dodoc README.org
	exeinto /usr/lib/nagios/plugins
	doexe check_consul
}
