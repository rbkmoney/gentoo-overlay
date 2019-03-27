# Copyright 2019 RBK.money

EAPI=5x

inherit git-r3
DESCRIPTION="Open Distro for Elasticsearch Security"
HOMEPAGE="https://opendistro.github.io/for-elasticsearch/"

EGIT_REPO_URI="https://github.com/opendistro-for-elasticsearch/security.git"
EGIT_COMMIT="75af4ce47f8e50031db0cbfa234dda458b295858"

SECURITY_PARENT_REPO="https://github.com/opendistro-for-elasticsearch/security-parent.git"
SECURITY_PARENT_COMMIT="545e63e006cd7321412042fba9700198f7c7dc5b"

SECURITY_SSL_REPO="https://github.com/opendistro-for-elasticsearch/security-ssl"
SECURITY_SSL_COMMIT="54c2f094c9b40d2396c6d62b84dbdadf2a482265"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

COMMON_DEPS=""
DEPEND="
	>=virtual/jdk-1.8.0-r3
	dev-java/maven-bin:*
  dev-java/netty-tcnative
	${COMMON_DEPS}"
RDEPEND="
  dev-java/netty-tcnative
	${COMMON_DEPS}"

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
  mvn dependency:copy-dependencies -Dmaven.repo.local="${WORKDIR}"/.m2/repository
  cd -
  mvn package -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true || die
  mvn dependency:copy-dependencies -Dmaven.repo.local="${WORKDIR}"/.m2/repository
}

src_install() {
  zip -r opendistro-security.zip plugin-descriptor.properties plugin-security.policy \
    tools securityconfig
  zip -j opendistro-security.zip target/opendistro_security-${PV}.jar target/dependency/* \
    "${WORKDIR}"/security-ssl/target/dependency/*
  /usr/share/elasticsearch/bin/elasticsearch-plugin install -b file://${PWD}/opendistro-security.zip || die
}
