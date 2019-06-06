# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

MY_TAG_PREFIX="upstream"
SRC_URI="https://github.com/ninech/nagios-plugins-bird/archive/${MY_TAG_PREFIX}/${PV}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Nagios plugin for monitoring the BIRD"
HOMEPAGE="https://github.com/ninech/nagios-plugins-bird"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="dev-perl/Monitoring-Plugin
	dev-perl/Carp-Clan
	dev-perl/Params-Validate"
DEPEND=""
# Fix this if you want rename this ebuild
S="${WORKDIR}/nagios-plugins-bird-${MY_TAG_PREFIX}-${PV}"

src_compile() {
	true # Nothing to compile here, and make clean is the default target
}

src_install() {
	dodir "/usr/$(get_libdir)/nagios/plugins/${PN}"
	exeinto "/usr/$(get_libdir)/nagios/plugins/${PN}"
	doexe src/plugins/check_bird

	dodir "/usr/$(get_libdir)/perl5/vendor_perl/"
	insinto "/usr/$(get_libdir)/perl5/vendor_perl/"
	doins src/lib/birdctl.pm

	dodoc README.md
}
