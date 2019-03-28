# Copyright 2019 RBK.money
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3
DESCRIPTION="Open Distro for Elasticsearch Security"
HOMEPAGE="https://github.com/opendistro-for-elasticsearch/"

EGIT_REPO_URI="https://github.com/rbkmoney/opendistro-security"
EGIT_COMMIT="a31d1300897ab3f1939186bd7ea165fa21572241"

SECURITY_PARENT_REPO="https://github.com/rbkmoney/opendistro-security-parent"
SECURITY_PARENT_COMMIT="6b2407200ae8e5fc65635ccdc2774467751ea795"

SECURITY_SSL_REPO="https://github.com/rbkmoney/opendistro-security-ssl"
SECURITY_SSL_COMMIT="a2a014ae5355eecd494ddadb18b338802d2570a9"

SECURITY_ADVANCED_REPO="https://github.com/rbkmoney/opendistro-security-advanced-modules"
SECURITY_ADVANCED_COMMIT="292599f1a37abccd7191e0e6d722db50dcce2b7c"

INSTALL_PATH="/usr/share/elasticsearch/plugins_archive/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPS=""
DEPEND="
  dev-libs/openssl:0
  >=virtual/jdk-1.8
	dev-java/maven-bin
	${COMMON_DEPS}"
RDEPEND="
	${COMMON_DEPS}"

mvn_install_dep() {
  ebegin "Installing $1"
    git clone $1 "${WORKDIR}/dep"
    cd "${WORKDIR}/dep"
    git checkout $2
    mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true || die
    cd -
    rm -rf "${WORKDIR}/dep"
  eend
}

src_prepare() {
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
}

src_install() {
  insinto ${INSTALL_PATH}
	doins target/releases/opendistro_security-${PV}.zip
}

pkg_postinst() {
	elog
	elog "You may install plugin by executing command:"
	elog "/usr/share/elasticsearch/bin/elasticsearch-plugin install -b file://${INSTALL_PATH}opendistro_security-${PV}.zip"
  elog
}
