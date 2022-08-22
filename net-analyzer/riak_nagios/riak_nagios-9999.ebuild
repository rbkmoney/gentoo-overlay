# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="Nagios Scripts for monitoring Riak"
HOMEPAGE="https://github.com/niku64/riak_nagios"
SRC_URI=""
EGIT_REPO_URI="https://github.com/niku64/riak_nagios.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
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
	doexe check_node bin/*
	dodoc README.md
}
