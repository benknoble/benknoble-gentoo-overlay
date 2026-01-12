# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Streaming JSON parser for Go"
HOMEPAGE="https://github.com/bcicen/jstream"
SRC_URI="https://github.com/bcicen/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -o jstream cmd/jstream/main.go
}

src_install() {
	dobin jstream
	default
}
