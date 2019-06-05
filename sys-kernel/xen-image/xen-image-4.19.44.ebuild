# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MINOR_VER="-xen"

inherit readme.gentoo mount-boot

DESCRIPTION="Precompiled hardened kernel image with modules"
HOMEPAGE="http://www.gentoo.org/proj/en/hardened/"
SRC_URI="https://localhost/linux-${PVR}-gentoo${MINOR_VER}.tar.xz"

LICENSE="GPL-2"
SLOT="${PVR}"
KEYWORDS="amd64 -*"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

RESTRICT="splitdebug installsources mirror collision-detect protect-owned"

pkg_pretend() {
        mount-boot_pkg_pretend
}

pkg_preinst() {
        mount-boot_pkg_preinst
}

pkg_preinst() {
        mount-boot_pkg_preinst
}

pkg_prerm() {
        mount-boot_pkg_prerm
}

pkg_postrm() {
        mount-boot_pkg_postrm
}

src_configure() { :; }

src_compile() { :; }

src_install() {
        insinto /lib/modules
        doins -r build/linux-${PVR}-gentoo-xen/lib/modules/${PVR}-gentoo${MINOR_VER}

        insinto /boot
        doins build/linux-${PVR}-gentoo-xen/*-${PVR}-gentoo${MINOR_VER}

        readme.gentoo_create_doc
}

pkg_postinst() {
        mount-boot_pkg_postinst

                readme.gentoo_create_doc
                readme.gentoo_print_elog
}

DOC_CONTENTS="Please configure your bootloader to boot new kernel version"
