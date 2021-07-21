# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1 eutils flag-o-matic

MY_PN="patroni"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PostgreSQL customized high-availability solution"
HOMEPAGE="https://github.com/zalando/patroni"
SRC_URI="https://github.com/zalando/${MY_PN}/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="doc test consul etcd zookeeper"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-python/urllib3-1.19.1
	!=dev-python/urllib3-1.21-r0
	dev-python/boto[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/six-1.7
	>=dev-python/click-4.1
	>=dev-python/prettytable-0.7
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/psutil-2.0.0
	dev-util/cdiff[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.8.3
	dev-python/flake8[${PYTHON_USEDEP}]
	consul? (
		>=dev-python/python-consul-0.7.1
	)
	etcd? (
		>=dev-python/python-etcd-0.4.3
		<dev-python/python-etcd-0.5
	)
	zookeeper? (
		>=dev-python/kazoo-1.3.1
	)
	"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
	"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_test() {
	pytest -vv tests || die "Testsuite failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
	newinitd "${FILESDIR}/patroni-cluster.initd" "patroni-cluster"
}
