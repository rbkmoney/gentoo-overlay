# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/goharbor"
GOLANG_PKG_VERSION="${PV}"
GOLANG_PKG_HAVE_TEST=1
GOLANG_PKG_BUILDPATH="/src/core /src/jobservice /src/registryctl"
GOLANG_PKG_HAVE_TEST=1

inherit user golang-single

DESCRIPTION="An open source trusted cloud native registry project that stores, signs, and scans content."
HOMEPAGE="https://goharbor.io/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+adminserver +ui +jobservice +registryctl"

DEPEND="dev-lang/go
		net-libs/nodejs
		<dev-python/pyyaml-4"
RDEPEND=""
BDEPEND=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /usr/share/${PN} ${PN}
}

src_compile() {
		golang-single_src_compile
		cd ${S}/src/portal
		python2 -c 'import sys, yaml, json; y=yaml.load(sys.stdin.read()); print json.dumps(y)' < ../../docs/swagger.yaml > swagger.json
		npm config set prefix "${PWD}/usr"
		npm install
		npm run build_lib
		npm run link_lib
		node --max_old_space_size=8192 'node_modules/@angular/cli/bin/ng' build --prod
}

src_install() {
		newbin ${GOBIN}/core ${PN}-core
		newbin ${GOBIN}/jobservice ${PN}-jobservice
		newbin ${GOBIN}/registryctl ${PN}-registryctl

		insinto /usr/share/${PN}/static
		doins -r ${S}/src/portal/dist/*
		doins ${S}/docs/swagger.yaml
		doins ${S}/src/portal/swagger.json
		doins ${S}/src/portal/lib/LICENSE
}
