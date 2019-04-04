# Copyright 2019 RBK.money
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3
DESCRIPTION="Open Distro for Elasticsearch Security"
HOMEPAGE="https://github.com/opendistro-for-elasticsearch/"

EGIT_REPO_URI="https://github.com/rbkmoney/opendistro-security-kibana-plugin"
EGIT_COMMIT="b102040d0c4442cbd9bf96a8b5fe709f64e057d2"

SECURITY_PARENT_REPO="https://github.com/rbkmoney/opendistro-security-parent"
SECURITY_PARENT_COMMIT="b3ddd5c012904f00c8765194790fb4558ca8da36"

PLUGIN_NAME="opendistro_security_kibana_plugin-${PV}-rbkmoney"
INSTALL_PATH="/usr/share/elasticsearch/plugins_archive/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND=">=virtual/jdk-1.8:*
	=net-libs/nodejs-10.15.2
	dev-java/maven-bin"

mvn_install_dep() {
	ebegin "Installing $1"
	git clone $1 "${WORKDIR}/dep" || die
	cd "${WORKDIR}/dep" || die
	git checkout $2 || die
	mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true || die
	cd - || die
	rm -rf "${WORKDIR}/dep"
	eend
}

src_install() {
	# Prepare temp maven repo
	mkdir -p "${WORKDIR}"/.m2/repository
	# Load and install deps
	mvn_install_dep ${SECURITY_PARENT_REPO} ${SECURITY_PARENT_COMMIT}
	./clean.sh
	# Install node modules
	cd ${S}
	npm install || die
	PLUGIN_DEST="build/kibana/${PLUGIN_NAME}"
	mkdir -p "${PLUGIN_DEST}"
	cp -a "index.js" "${PLUGIN_DEST}"
	cp -a "package.json" "${PLUGIN_DEST}"
	cp -a "lib" "${PLUGIN_DEST}"
	cp -a "node_modules" "${PLUGIN_DEST}"
	cp -a "public" "${PLUGIN_DEST}"
	# Package plugin
	mvn clean install -Dmaven.repo.local="${WORKDIR}"/.m2/repository || die
	insinto ${INSTALL_PATH}
	doins target/releases/${PLUGIN_NAME}.zip
}

pkg_postinst() {
	elog "You may install plugin by executing command:"
	elog "/usr/share/elasticsearch/bin/elasticsearch-plugin install -b file://${INSTALL_PATH}${PLUGIN_NAME}.zip"
}
