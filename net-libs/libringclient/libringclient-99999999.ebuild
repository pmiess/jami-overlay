# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *99999999* ]]; then
	inherit eutils git-r3 cmake-utils

	EGIT_REPO_URI="https://git.jami.net/savoirfairelinux/ring-lrc.git"
	SRC_URI=""

	KEYWORDS=""
else
	inherit eutils cmake-utils

	COMMIT_HASH=""
	MY_SRC_P="ring_${PV}.${COMMIT_HASH}"
	SRC_URI="https://dl.ring.cx/ring-release/tarballs/${MY_SRC_P}.tar.gz"

	KEYWORDS="~amd64"

	S=${WORKDIR}/ring-project/lrc/
fi

DESCRIPTION="libringclient is the common interface for Jami (formerly Ring) applications"
HOMEPAGE="https://jami.net/"

LICENSE="GPL-3"

SLOT="0"

IUSE="doc +dbus +video static-libs"

DEPEND="dbus? ( ~net-voip/ring-daemon-${PVR}[dbus,video] )
	!dbus? ( ~net-voip/ring-daemon-${PVR}[video] )
	>=dev-qt/qtdbus-5
	>=dev-qt/qtsql-5"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_VIDEO="$(usex video true false)"
		-DENABLE_STATIC="$(usex static-libs true false)"
		-DENABLE_LIBWRAP="$(usex !dbus true false)"
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	use !doc && rm README.md
	cmake-utils_src_install
}
