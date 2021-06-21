# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson systemd

DESCRIPTION="Clevis is a plugable framework for automated decryption"
HOMEPAGE="https://latchset.github.io/"
SRC_URI="https://github.com/latchset/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion dracut systemd tpm udisks"

REQUIRED_USE="dracut? ( systemd )"

BDEPEND="app-misc/jq
	app-text/asciidoc"
DEPEND="tpm? ( >=app-crypt/tpm2-tools-4.0 )
	>=sys-fs/luksmeta-8
	|| (
		dev-libs/openssl:0=
		dev-libs/libressl:0=
	)
	systemd? ( sys-apps/systemd )
	net-misc/curl
	>=dev-libs/jansson-2.10
	>=dev-libs/jose-8
	>=sys-fs/cryptsetup-2.0.4[pwquality]
	dracut?	(
		sys-kernel/dracut
		net-analyzer/nmap[ncat]
	)
	udisks? ( sys-fs/udisks:2 )
	bash-completion? ( app-shells/bash-completion )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/clevis-tpm2-tools-5.patch
	"${FILESDIR}"/0001-Fixes-build-failure-with-musl-libc-pid_t-require-sys.patch
)
