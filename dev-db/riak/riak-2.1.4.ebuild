# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit versionator eutils user multilib toolchain-funcs

# build time dependency
# fork of the google project with riak specific changes
# is used to build the eleveldb lib and gets removed before install
LEVELDB_PV="2.0.29"
LEVELDB_URI="https://github.com/basho/leveldb/archive/${LEVELDB_PV}.tar.gz"
LEVELDB_P="leveldb-${LEVELDB_PV}.tar.gz"
LEVELDB_WD="${WORKDIR}/leveldb-${LEVELDB_PV}"
LEVELDB_TARGET_LOCATION="${S}/deps/eleveldb/c_src/leveldb"

#bug, compile scripts call ld directory, not through gcc
LDFLAGS=""

DESCRIPTION="An open source, distributed database"
HOMEPAGE="http://www.basho.com/"
SRC_URI="http://s3.amazonaws.com/downloads.basho.com/${PN}/$(get_version_component_range 1-2)/${PV}/${P}.tar.gz
	${LEVELDB_URI} -> ${LEVELDB_P}
"

# prestripped files
# bootstrapped from existing dev-lang/erlang install
QA_PRESTRIPPED="
	/usr/lib.*/riak/lib/asn1-.*/priv/lib/asn1_erl_nif.so
	/usr/lib.*/riak/lib/asn1-.*/priv/lib/asn1rt_nif.so
	/usr/lib.*/riak/lib/crypto-.*/priv/lib/crypto.so
	/usr/lib.*/riak/lib/crypto-.*/priv/lib/crypto_callback.so
	/usr/lib.*/riak/lib/os_mon-.*/priv/bin/memsup
	/usr/lib.*/riak/lib/os_mon-.*/priv/bin/cpu_sup
	/usr/lib.*/riak/lib/runtime_tools-.*/priv/lib/dyntrace.so
	/usr/lib.*/riak/lib/runtime_tools-.*/priv/lib/trace_ip_drv.so
	/usr/lib.*/riak/lib/runtime_tools-.*/priv/lib/trace_file_drv.so
	/usr/lib.*/riak/erts-.*/bin/beam
	/usr/lib.*/riak/erts-.*/bin/beam.smp
	/usr/lib.*/riak/erts-.*/bin/child_setup
	/usr/lib.*/riak/erts-.*/bin/inet_gethost
	/usr/lib.*/riak/erts-.*/bin/heart
	/usr/lib.*/riak/erts-.*/bin/erlexec
	/usr/lib.*/riak/erts-.*/bin/erlc
	/usr/lib.*/riak/erts-.*/bin/escript
	/usr/lib.*/riak/erts-.*/bin/ct_run
	/usr/lib.*/riak/erts-.*/bin/run_erl
	/usr/lib.*/riak/erts-.*/bin/to_erl
	/usr/lib.*/riak/erts-.*/bin/epmd
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="mirror"
RDEPEND="
	<dev-lang/erlang-18[kpoll]
	dev-libs/openssl:0
	sys-libs/ncurses:0
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
"

pkg_setup() {
	ebegin "Creating riak user and group"
	local riak_home="/var/$(get_libdir)/riak"
	enewgroup riak
	enewuser riak -1 -1 $riak_home riak
	eend $?
}

src_prepare() {
#	# Avoid fetching deps via git that are already available
#	ln -s ${LEVELDB_WD} ${LEVELDB_TARGET_LOCATION} || die
#	mkdir -p "${S}"/deps/riaknostic/deps || die
#	ln -s "${S}"/deps/lager "${S}"/deps/riaknostic/deps || die
#	ln -s "${S}"/deps/meck "${S}"/deps/riaknostic/deps || die
#	ln -s "${S}"/deps/getopt "${S}"/deps/riaknostic/deps || die
	epatch "${FILESDIR}/${PV}-fix-directories.patch"
	eapply_user
}

src_compile() {
	# Upstream makefile fails at -j > 1.
	emake -j1 \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) \
		LD=$(tc-getLD) \
		RANLIB=$(tc-getRANLIB) \
		STRIP="" rel
}

src_install() {
	local lib_dir=$(get_libdir)
	local erts_version=$(find /usr/${lib_dir}/erlang/lib/ -maxdepth 1 -type d -name erts-* | cut -d'-' -f2)

	insinto /usr/${lib_dir}/riak
	doins -r rel/riak/lib \
		rel/riak/releases \
		rel/riak/erts-${erts_version}
	fperms -R 0755 /usr/${lib_dir}/riak/erts-${erts_version}/bin

	# TODO: refactor this.
	cd "${D}"
	find "usr/${lib_dir}/riak/lib/" -type f -path */priv/bin/* | xargs fperms 0755
	cd "${S}"

	dobin rel/riak/bin/*
	insinto /etc/riak
	doins rel/riak/etc/*

	keepdir /var/lib/riak/{bitcask,ring,leveldb} \
		/var/log/riak/sasl

	fowners -R riak:riak /var/lib/riak \
		/var/log/riak

	doman doc/man/man1/*
	use doc && dodoc doc/*.txt

	newinitd "${FILESDIR}/${PN}.initd" riak
	newconfd "${FILESDIR}/${PN}.confd" riak
	# TODO: Logrotate.
}
