# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Erlang build tool that makes it easy to compile and test Erlang applications and releases."
HOMEPAGE="http://rebar3.org/"
SRC_URI="https://github.com/erlang/rebar3/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND="dev-lang/erlang"
RDEPEND="${DEPEND}"

S="${WORKDIR}/rebar3-${PV}"

src_compile() {
	./bootstrap
}
src_install() {
	doexe rebar3
	dodoc README.md
}
