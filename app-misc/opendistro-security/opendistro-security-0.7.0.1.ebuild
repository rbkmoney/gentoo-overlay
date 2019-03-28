# Copyright 2019 RBK.money

EAPI=5

inherit git-r3
DESCRIPTION="Open Distro for Elasticsearch Security"
HOMEPAGE="https://github.com/opendistro-for-elasticsearch/"

EGIT_REPO_URI="https://github.com/rbkmoney/opendistro-security.git"
EGIT_COMMIT="a31d1300897ab3f1939186bd7ea165fa21572241"

SECURITY_PARENT_REPO="https://github.com/rbkmoney/opendistro-security-parent.git"
SECURITY_PARENT_COMMIT="6b2407200ae8e5fc65635ccdc2774467751ea795"

SECURITY_SSL_REPO="https://github.com/rbkmoney/opendistro-security-ssl"
SECURITY_SSL_COMMIT="a2a014ae5355eecd494ddadb18b338802d2570a9"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPS=""
DEPEND="
  dev-libs/openssl
	~virtual/jdk-1.8.0
	dev-java/maven-bin
  dev-java/netty-tcnative
  dev-java/netty-transport
  app-arch/zip
	${COMMON_DEPS}"
RDEPEND="
	${COMMON_DEPS}"

copy_mvn_deps() {
  mvn dependency:copy-dependencies -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DincludeScope=provided
  mvn dependency:copy-dependencies -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DincludeScope=runtime
  mvn dependency:copy-dependencies -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DincludeScope=compile
  mvn dependency:copy-dependencies -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DincludeScope=system
}

src_prepare() {
  # Prepare temp maven repo
  mkdir -p "${WORKDIR}"/.m2/repository
  # Load and install deps
  git clone ${SECURITY_PARENT_REPO} "${WORKDIR}/security-parent"
  cd "${WORKDIR}/security-parent"
  git checkout ${SECURITY_PARENT_COMMIT}
  mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository || die
  mvn dependency:copy-dependencies -Dmaven.repo.local="${WORKDIR}"/.m2/repository
  cd -
  git clone ${SECURITY_SSL_REPO} "${WORKDIR}/security-ssl"
  cd "${WORKDIR}/security-ssl"
  git checkout ${SECURITY_SSL_COMMIT}
  mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true || die
  copy_mvn_deps
  cd -
  mvn package -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true || die
  mvn dependency:copy-dependencies -Dmaven.repo.local="${WORKDIR}"/.m2/repository
  copy_mvn_deps
}

src_install() {
  zip -r opendistro-security.zip plugin-descriptor.properties plugin-security.policy \
    tools securityconfig
  zip -j opendistro-security.zip target/opendistro_security-${PV}.jar target/dependency/*
  zip -j opendistro-security.zip "${WORKDIR}"/security-ssl/target/dependency/*
  /usr/share/elasticsearch/bin/elasticsearch-plugin install -b file://${PWD}/opendistro-security.zip || die
}
