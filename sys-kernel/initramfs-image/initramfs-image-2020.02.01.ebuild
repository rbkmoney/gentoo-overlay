# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Initramfs image for including in a kernel at compile"
HOMEPAGE="https://github.com/alexminder/"
SRC_URI="https://localhost/initramfs.cpio -> ${P}.cpio"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/initramfs-image
	newins ${DISTDIR}/${P}.cpio initramfs.cpio
}
