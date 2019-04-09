# Copyright 2019 RBK.money
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3
DESCRIPTION="Open Distro for Elasticsearch Security"
HOMEPAGE="https://github.com/opendistro-for-elasticsearch/"

declare -A my_dep_repo=(
	[security]="https://github.com/rbkmoney/opendistro-security"
	[security_parent]="https://github.com/rbkmoney/opendistro-security-parent"
	[security_ssl]="https://github.com/rbkmoney/opendistro-security-ssl"
	[security_advanced]="https://github.com/rbkmoney/opendistro-security-advanced-modules"
)
declare -A my_dep_ref=(
	[security]="dcab69a0d5e32723ac1b182e3924fb0abc512130"
	[security_parent]="b3ddd5c012904f00c8765194790fb4558ca8da36"
	[security_ssl]="e684e6004d96f5a611b0ca176d87039d03220ddd"
	[security_advanced]="35d2daf52b9f71c193092bab53af600b7f4c9bf7"
)
S="${WORKDIR}/security"
INSTALL_PATH="/usr/share/elasticsearch/plugins_archive/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/openssl:0
	>=virtual/jdk-1.8:*"
DEPEND="${RDEPEND}
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
	for name in security security_parent security_ssl security_advanced; do
		my_fetch_dep "${name}"
	done
}
src_prepare() {
	mkdir -p "${WORKDIR}"/.m2/repository
	eapply_user
}
src_compile() {
	for name in security_parent security_ssl security security_advanced; do
		my_compile_dep "${name}"
	done
	# Package security and security-advanced as plugin
	mvn install -Dmaven.repo.local="${WORKDIR}"/.m2/repository -DskipTests=true -P advanced || die
}
src_install() {
	insinto ${INSTALL_PATH}
	doins target/releases/opendistro_security-${PV}-rbkmoney.zip
}

pkg_postinst() {
	elog "You may install plugin by executing command:"
	elog "/usr/share/elasticsearch/bin/elasticsearch-plugin install -b file://${INSTALL_PATH}opendistro_security-${PV}-rbkmoney.zip"
}
