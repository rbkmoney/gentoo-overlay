# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3
DESCRIPTION="Open Distro security Kibana plugin"
HOMEPAGE="https://github.com/opendistro-for-elasticsearch/"

declare -A my_dep_repo=(
	[security_kibana_plugin]="https://github.com/opendistro-for-elasticsearch/security-kibana-plugin"
	[security_parent]="https://github.com/opendistro-for-elasticsearch/security-parent"
)
declare -A my_dep_ref=(
	[security_kibana_plugin]="refs/tags/v${PV}"
	[security_parent]="refs/tags/v0.10.0.1"
)
S="${WORKDIR}/security_kibana_plugin"
PLUGIN_NAME="opendistro_security_kibana_plugin-${PV}"
INSTALL_PATH="/var/lib/kibana/plugins/${PLUGIN_NAME}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=net-libs/nodejs-10.16
	~www-apps/kibana-bin-6.8.1"
DEPEND="${RDEPEND}
	virtual/jdk:11
	dev-java/maven-bin
	app-arch/unzip"

my_fetch_dep() {
	local name="${1}"
	local repo="${my_dep_repo[${name}]}" ref="${my_dep_ref[${name}]}"
	git-r3_fetch "${repo}" "${ref}"
	git-r3_checkout "${repo}" "${WORKDIR}/${name}"
}
my_compile_dep() {
	local name="${1}"
	einfo "Compiling ${name}"
	cd "${WORKDIR}/${name}" || die
	mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true || die
	cd "${S}" || die
}
src_unpack() {
	for name in security_kibana_plugin security_parent; do
		my_fetch_dep "${name}"
	done
}
src_prepare() {
	mkdir -p "${WORKDIR}"/.m2/repository
	eapply_user
}
src_compile() {
	local PLUGIN_DEST="build/kibana/${PLUGIN_NAME}"
	my_compile_dep security_parent
	npm install || die
	mkdir -p "${PLUGIN_DEST}" || die
	cp -a "index.js" "package.json" "node_modules" "lib" "public" \
	   "${PLUGIN_DEST}" || die
	my_compile_dep security_kibana_plugin
}

src_install() {
	mkdir temp || die
	unzip "target/releases/${PLUGIN_NAME}.zip" -d temp || die
	dodir "${INSTALL_PATH}"
	mv "temp/kibana/${PLUGIN_NAME}/"* "${D}${INSTALL_PATH}/" || die
}
