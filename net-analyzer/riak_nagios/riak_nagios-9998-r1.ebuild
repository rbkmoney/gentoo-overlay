# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Nagios Scripts for monitoring Riak"
HOMEPAGE="https://github.com/basho-labs/riak_nagios"
COMMIT="9cc200e8cec7d6f71f445df5a7bd195f7a772e8a"
SRC_URI="https://github.com/basho-labs/${PN}/archive/${COMMIT}.tar.gz"
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
