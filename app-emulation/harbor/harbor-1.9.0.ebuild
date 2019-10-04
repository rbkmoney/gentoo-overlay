# Copyright 2019 RBK.MONEY
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/goharbor"
GOLANG_PKG_VERSION="${PV}"
GOLANG_PKG_HAVE_TEST=1
GOLANG_PKG_BUILDPATH="/src/core /src/jobservice /src/registryctl"
GOLANG_PKG_HAVE_TEST=1

WEBAPP_OPTIONAL="yes"

inherit user golang-single webapp

DESCRIPTION="An open source trusted cloud native registry project that stores, signs, and scans content."
HOMEPAGE="https://goharbor.io/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+core jobservice portal registryctl"
REQUIRED_USE="|| ( core jobservice portal registryctl )"

DEPEND="dev-lang/go
		portal? ( net-libs/nodejs
		<dev-python/pyyaml-4 )"
RDEPEND="portal? ( app-admin/webapp-config )"
BDEPEND=""

WEBAPP_MANUAL_SLOT="yes"

pkg_setup() {

	if use core || use jobservice || use registryctl; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /usr/share/${PN} ${PN}
	fi

	use portal && webapp_pkg_setup
}

src_compile() {
	if use core || use jobservice || use registryctl; then
		golang-single_src_compile
	fi
	if use portal; then
		cd ${S}/src/portal
		python2 -c 'import sys, yaml, json; y=yaml.load(sys.stdin.read()); print json.dumps(y)' < ../../docs/swagger.yaml > swagger.json
		npm config set prefix "${PWD}/usr"
		npm install
		npm run build_lib
		npm run link_lib
		node --max_old_space_size=8192 'node_modules/@angular/cli/bin/ng' build --prod
	fi
}

src_install() {
	use core && newbin ${GOBIN}/core ${PN}-core && newinitd ${FILESDIR}/harbor-core.initd harbor-core
	use jobservice && newbin ${GOBIN}/jobservice ${PN}-jobservice
	use registryctl && newbin ${GOBIN}/registryctl ${PN}-registryctl

	if use portal; then

		webapp_src_preinst

		insinto "${MY_HTDOCSDIR}"
		doins -r ${S}/src/portal/dist/*
		doins ${S}/docs/swagger.yaml
		doins ${S}/src/portal/swagger.json
		doins ${S}/src/portal/lib/LICENSE

		webapp_src_install

	fi
}
