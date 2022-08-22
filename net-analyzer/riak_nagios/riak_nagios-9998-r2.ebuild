# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Nagios Scripts for monitoring Riak"
HOMEPAGE="https://github.com/niku64/riak_nagios"
COMMIT="5f7cc3b51790eb3012a2f3c13aa366acc157a53d"
SRC_URI="https://github.com/niku64/${PN}/archive/${COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-lang/erlang"
RDEPEND="${DEPEND}"

# TODO: fetch erlang deps in ebuild;

src_compile() {
	emake escript || die "emake failed"
}

src_install() {
	exeinto "/usr/$(get_libdir)/nagios/plugins/riak"
	doexe check_node bin/* "${FILESDIR}/check_node_wrapper"
	dodoc README.md
}
