# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Locale program for musl libc"
HOMEPAGE="https://gitlab.com/rilian-la-te/musl-locales"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/rilian-la-te/musl-locales.git"
fi

inherit cmake-utils

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="sys-libs/musl"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"
