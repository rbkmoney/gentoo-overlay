# Copyright 2019 RBK.money
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3
DESCRIPTION="Open Distro for Elasticsearch Security"
HOMEPAGE="https://github.com/opendistro-for-elasticsearch/"
EGIT_BRANCH_OPENDISTRO_FOR_ELASTICSEARCH_SECURITY_KIBANA_PLUGIN="opendistro-1.2"

declare -A my_dep_repo=(
	[security_kibana_plugin]="https://github.com/opendistro-for-elasticsearch/security-kibana-plugin"
	[security_parent]="https://github.com/opendistro-for-elasticsearch/security-parent"
)
declare -A my_dep_ref=(
	[security_kibana_plugin]="refs/tags/v${PV}"
	[security_parent]="refs/tags/v1.2.0.0"
)
S="${WORKDIR}/security_kibana_plugin"
INSTALL_PATH="/usr/share/elasticsearch/plugins_archive/"
PLUGIN_NAME="opendistro_security_kibana_plugin-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="virtual/jdk:11
	>=net-libs/nodejs-10.16
	dev-java/maven-bin"

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
	my_compile_dep security_parent
	npm install --prefix="${D}" || die
	PLUGIN_DEST="build/kibana/${PLUGIN_NAME}"
	mkdir -p "${PLUGIN_DEST}"
	cp -a "index.js" "${PLUGIN_DEST}"
	cp -a "package.json" "${PLUGIN_DEST}"
	cp -a "lib" "${PLUGIN_DEST}"
	cp -a "node_modules" "${PLUGIN_DEST}"
	cp -a "public" "${PLUGIN_DEST}"
	my_compile_dep security_kibana_plugin
}

src_install() {
	insinto ${INSTALL_PATH}
	doins target/releases/${PLUGIN_NAME}.zip
}

pkg_postinst() {
	elog "You may install plugin by executing command:"
	elog "/usr/share/elasticsearch/bin/elasticsearch-plugin install -b file://${INSTALL_PATH}${PLUGIN_NAME}.zip"
}
