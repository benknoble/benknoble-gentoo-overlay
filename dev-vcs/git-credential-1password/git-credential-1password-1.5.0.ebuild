# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Use the 1Password CLI to authenticate Git connections"
HOMEPAGE="https://github.com/ethrgeist/git-credential-1password"
SRC_URI="https://github.com/ethrgeist/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=app-admin/op-cli-bin-2.32.0"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.26.0"

inherit go-module

src_compile() {
	ego build
}

src_install() {
	dobin git-credential-1password
	default
}
