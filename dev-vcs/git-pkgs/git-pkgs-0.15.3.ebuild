# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A git subcommand for analyzing dependencies"
HOMEPAGE="https://git-pkgs.dev/"
SRC_URI="https://github.com/git-pkgs/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="+doc"

# This is a lie, and is only to avoid packaging a bunch of go modules
PROPERTIES=live

src_unpack() {
	default
	GOMODCACHE="${S}/go-mod"
	pushd "${S}" || die
	ego mod download
	popd || die
}

src_compile() {
	if use doc; then
		ego run scripts/generate-man/main.go
		ego run scripts/generate-docs/main.go
	fi

	local ldflags=(
		-s -w
		-X github.com/git-pkgs/git-pkgs/cmd.version="${PV}"
		-X github.com/git-pkgs/git-pkgs/cmd.commit=c97590e192f0504c7a34dc21bbc026d1e4148397
		-X github.com/git-pkgs/git-pkgs/cmd.date="$(date --rfc-3339=seconds -u | sed 's/ /T/;s/+00:00/Z/')"
	)

	CGO_ENABLED=0 ego build -o git-pkgs -ldflags="${ldflags[*]}" .
}

src_install() {
	dobin git-pkgs
	dodoc -r docs
	if use doc; then
		doman man/*
	fi
	default
}
