# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$((${PV##*.}+4))
HARDENED_PATCH_VER="${PV}-hardened1"
GENPATCHES_EXCLUDE="1500_XATTR_USER_PREFIX.patch
	1510_fs-enable-link-security-restrictions-by-default.patch
	2900_dev-root-proc-mount-fix.patch
	4200_fbcondecor.patch
	4400_alpha-sysctl-uac.patch
	4567_distro-Gentoo-Kconfig.patch"


DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/anthraxx/linux-hardened/releases/download/${HARDENED_PATCH_VER}/linux-hardened-${HARDENED_PATCH_VER}.patch"

S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="debug extra-hardened"

REQUIRED_USE="extra-hardened? ( !debug )"

RESTRICT="strip"

BDEPEND="
	!initramfs? ( sys-kernel/initramfs-image )
	app-crypt/sbsigntools
	debug? ( dev-util/dwarves )"
RDEPEND="
	!sys-kernel/gentoo-kernel:${SLOT}
	!sys-kernel/gentoo-kernel-bin:${SLOT}
	!sys-kernel/vanilla-kernel:${SLOT}
	!sys-kernel/vanilla-kernel-bin:${SLOT}"

src_prepare() {
	# remove some genpatches causes conflicts with linux-hardened patch
	for patch in ${GENPATCHES_EXCLUDE}; do
		rm -f ${WORKDIR}/${patch}
	done
	# include linux-hardened patch with priority
	cp ${DISTDIR}/linux-hardened-${HARDENED_PATCH_VER}.patch ${WORKDIR}/1199_linux-hardened-${HARDENED_PATCH_VER}.patch
	# copy Clear Linux patches
	if [ -d "${FILESDIR}"/${MY_P} ]; then
		cp "${FILESDIR}"/${MY_P}/*.patch ${WORKDIR}/
	fi

	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	default

	# prepare the default config
	case ${ARCH} in
		amd64)
			cp "${FILESDIR}"/${MY_P}.amd64.config .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	local config_tweaks=(
		# shove arch under the carpet!
		-e 's:^CONFIG_DEFAULT_HOSTNAME=:&"gentoo":'
		# disable compression to allow stripping
		-e '/CONFIG_MODULE_COMPRESS/d'
	)
	use debug || config_tweaks+=(
		-e '/CONFIG_DEBUG_INFO/d'
	)
	use extra-hardened || config_tweaks+=(
        # disable signatures
        -e '/CONFIG_MODULE_SIG/d'
        -e '/CONFIG_SECURITY_LOCKDOWN/d'
        # Reqired to be disabled for out of tree kernel modules
        -e '/CONFIG_TRIM_UNUSED_KSYMS/d'
	)
	sed -i "${config_tweaks[@]}" .config || die
}

src_install() {
	kernel-build_src_install

	if [[ -n "${UEFI_SB_KEY}" && -n "${UEFI_SB_CRT}" ]] ;then
		sbsign --key ${UEFI_SB_KEY} --cert ${UEFI_SB_CRT} --output ${D}/usr/src/linux-${PV}/arch/x86/boot/bzImage.signed \
		  ${D}/usr/src/linux-${PV}/arch/x86/boot/bzImage && \
		mv ${D}/usr/src/linux-${PV}/arch/x86/boot/bzImage.signed ${D}/usr/src/linux-${PV}/arch/x86/boot/bzImage
	fi
}
