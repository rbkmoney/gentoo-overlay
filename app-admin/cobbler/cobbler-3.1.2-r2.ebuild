# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{9,10} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Network Boot and Update Server"
HOMEPAGE="https://cobbler.github.io https://github.com/cobbler"
SRC_URI="https://github.com/cobbler/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
IUSE="man"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="mirror"
RDEPEND="${PYTHON_DEPS}
	dev-python/future
	dev-python/coverage
	dev-python/netaddr
	dev-python/distro
	dev-python/django
	dev-python/simplejson
	dev-python/pyyaml
	dev-python/cheetah3
	dev-python/urllib3
	acct-user/cobbler
	acct-group/cobbler"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/cobblerd.patch"
	"${FILESDIR}/utils.patch"
	"${FILESDIR}/tftpgen.patch"
	"${FILESDIR}/0001-Disable-cache-2387.patch"
)

src_prepare() {
	default

	# Disablie installation of some files and all chown calls
	sed -i \
		-e '/"%s" % webconfig,/d' -e 's|self.change_owner(path, http_user)|pass|g' \
		-e 's|"build/config/apache/cobbler.conf",||g' \
		-e 's|"build/config/apache/cobbler_web.conf",||g' \
		-e 's|"build/config/service/cobblerd.service",||g' \
		-e 's|"build/config/cobbler/settings"||g' \
		setup.py || die

	if ! use man; then
		sed -i '/docs\//Id' setup.py
	fi
}

src_install() {
	distutils-r1_src_install

	# insinto /etc/${PN}
	# doins conf/*
	dodoc config/apache/*
	dodoc config/cobbler/settings
	dodoc "${FILESDIR}/cobbler.nginx.conf"
	dodoc "${FILESDIR}/cobbler-web.uwsgi.ini"
	dodoc "${FILESDIR}/cobbler-svc.uwsgi.ini"

	keepdir /var/{lib,log,www}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	fperms 0750 /var/{lib,log}/${PN}
	# Ugly hack to keep cobbler directory structure in var
	for _d in $(find "${D}"/var/{lib,log,www}/"${PN}" -type d -empty | sed -e "s|${D}||g"); do
		keepdir "${_d}"
		fowners ${PN}:${PN} "${_d}"
	done

	newinitd "${FILESDIR}"/${PN}d.initd ${PN}d
}
