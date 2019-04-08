# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

DESCRIPTION="Erlang build tool that makes it easy to compile and test Erlang applications"
HOMEPAGE="http://rebar3.org/"
MY_PV="$(replace_version_separator _ -)"
MY_P="${PN}-${MY_PV}"
SRC_URI="https://github.com/erlang/rebar3/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND="<dev-lang/erlang-22"
RDEPEND="${DEPEND}"

S="${WORKDIR}/rebar3-${MY_PV}"

src_compile() {
	./bootstrap || die "Rebar bootstrap failed!"
}
src_install() {
	exeinto /usr/bin
	doexe rebar3
	dodoc README.md
}
