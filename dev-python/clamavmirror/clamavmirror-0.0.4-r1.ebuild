# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

COMMIT="9b818460efbcec0cffd6abb586d9e2bdec529410"

DESCRIPTION="ClamAV Signature Mirroring Tool"
HOMEPAGE="https://github.com/akissa/clamavmirror https://pypi.org/project/clamavmirror/"
SRC_URI="https://github.com/akissa/clamavmirror/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"

RDEPEND="app-antivirus/clamav
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${COMMIT}"

python_install_all() {
	distutils-r1_python_install_all
}
