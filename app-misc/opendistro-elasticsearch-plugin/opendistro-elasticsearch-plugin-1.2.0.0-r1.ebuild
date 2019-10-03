# Copyright 2019 RBK.money
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3
DESCRIPTION="Open Distro for Elasticsearch Security"
HOMEPAGE="https://github.com/opendistro-for-elasticsearch/"

declare -A my_dep_repo=(
	[security]="https://github.com/opendistro-for-elasticsearch/security"
	[security_parent]="https://github.com/opendistro-for-elasticsearch/security-parent"
	[security_advanced]="https://github.com/opendistro-for-elasticsearch/security-advanced-modules"
)
declare -A my_dep_ref=(
	[security]="refs/tags/v${PV}"
	[security_parent]="refs/tags/v${PV}"
	[security_advanced]="refs/tags/v${PV}"
)
S="${WORKDIR}/security"
INSTALL_PATH="/usr/share/elasticsearch/plugins_archive/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPS="dev-libs/openssl:0
	virtual/jdk:11"
RDEPEND="${COMMON_DEPS}
	=app-misc/elasticsearch-7.2.0"
DEPEND="${COMMON_DEPS}
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
	for name in security security_parent security_advanced; do
		my_fetch_dep "${name}"
	done
}
src_prepare() {
	mkdir -p "${WORKDIR}"/.m2/repository
	eapply_user
}
src_compile() {
	for name in security_parent security security_advanced; do
		my_compile_dep "${name}"
	done
	# Package security and security-advanced as plugin
	mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true -P advanced || die
}
src_install() {
	dodir "/usr/share/elasticsearch/plugins/${PN}"
	unzip "target/releases/opendistro_security-${PV}.zip" -d "${D}/usr/share/elasticsearch/plugins/${PN}" || die
}
