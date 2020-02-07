# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KEYWORDS="~amd64"

GOLANG_PKG_IMPORTPATH="github.com/quay"
GOLANG_PKG_ARCHIVEPREFIX="v"
GOLANG_PKG_VERSION="${PV}"
GOLANG_PKG_HAVE_TEST=1
GOLANG_PKG_BUILDPATH="/cmd/${PN}"

GOLANG_PKG_DEPENDENCIES=(
    "github.com/pborman/uuid:8b1b929"
    "github.com/prometheus/client_golang:c5b7fcc"
    "github.com/sirupsen/logrus:839c75f"
    "github.com/stretchr/testify:221dbe5"
	"github.com/beorn7/perks:37c8de3"
	"github.com/cespare/xxhash:d7df741"
	"github.com/golang/protobuf:d23c512"
	"github.com/google/uuid:0cd6bf5"
	"github.com/prometheus/client_model:fa8ad6f"
	"github.com/prometheus/common:c8ea520"
	"github.com/prometheus/procfs:abf152e"
	"github.com/golang/sys:d101bd2 -> golang.org/x"
	"github.com/go-yaml/yaml:53403b5 -> gopkg.in/yaml.v2"
	"github.com/coreos/pkg:97fdf19"
	"github.com/matttproud/golang_protobuf_extensions:c12348c"
	"github.com/guregu/null:80515d4"
	"github.com/tylerb/graceful:4654dfb"
	"github.com/julienschmidt/httprouter:4eec211"
	"github.com/hashicorp/golang-lru:14eae34"
	"github.com/lib/pq:9927457"
	"github.com/remind101/migrate:52c1edf"
	"github.com/fernet/fernet-go:eff2850"
)

inherit user golang-single

DESCRIPTION="Vulnerability Static Analysis for Containers"
HOMEPAGE="https://github.com/quay/clair"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="app-arch/rpm
	app-arch/xz-utils
	dev-vcs/git
	!!sci-visualization/xd3d" # File collision (Bug #621044)

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_install() {
	golang-single_src_install

	cd ../../
	pushd ${S} || die
	dodoc {README,ROADMAP,CONTRIBUTING}.md
	insinto /etc/${PN}
	doins config.example.yaml
	popd || die

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
