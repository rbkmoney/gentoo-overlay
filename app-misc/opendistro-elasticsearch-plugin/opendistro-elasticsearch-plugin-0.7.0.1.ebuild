# Copyright 2019 RBK.money
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3
DESCRIPTION="Open Distro for Elasticsearch Security"
HOMEPAGE="https://github.com/opendistro-for-elasticsearch/"

EGIT_REPO_URI="https://github.com/rbkmoney/opendistro-security"
EGIT_COMMIT="dcab69a0d5e32723ac1b182e3924fb0abc512130"

SECURITY_PARENT_REPO="https://github.com/rbkmoney/opendistro-security-parent"
SECURITY_PARENT_COMMIT="b3ddd5c012904f00c8765194790fb4558ca8da36"

SECURITY_SSL_REPO="https://github.com/rbkmoney/opendistro-security-ssl"
SECURITY_SSL_COMMIT="e684e6004d96f5a611b0ca176d87039d03220ddd"

SECURITY_ADVANCED_REPO="https://github.com/rbkmoney/opendistro-security-advanced-modules"
SECURITY_ADVANCED_COMMIT="35d2daf52b9f71c193092bab53af600b7f4c9bf7"

INSTALL_PATH="/usr/share/elasticsearch/plugins_archive/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/openssl:0
	>=virtual/jdk-1.8:*"
DEPEND="${RDEPEND}
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
	mvn_install_dep ${SECURITY_SSL_REPO} ${SECURITY_SSL_COMMIT}
	# Install security (required by security-advanced)
	mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true || die
	# Build security-advanced
	mvn_install_dep ${SECURITY_ADVANCED_REPO} ${SECURITY_ADVANCED_COMMIT}
	# Package security and security-advanced as plugin
	mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true -P advanced || die
	insinto ${INSTALL_PATH}
	doins target/releases/opendistro_security-${PV}-rbkmoney.zip
}

pkg_postinst() {
	elog "You may install plugin by executing command:"
	elog "/usr/share/elasticsearch/bin/elasticsearch-plugin install -b file://${INSTALL_PATH}opendistro_security-${PV}-rbkmoney.zip"
}
