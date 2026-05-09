# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="A git subcommand for analyzing dependencies"
HOMEPAGE="https://git-pkgs.dev/"
SRC_URI="https://github.com/git-pkgs/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.25.7"

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
		-X github.com/git-pkgs/git-pkgs/cmd.commit=85f49073e99bce1087786b24c279c0db29b93bf9
		-X github.com/git-pkgs/git-pkgs/cmd.date="$(date --rfc-3339=seconds -u | sed 's/ /T/;s/+00:00/Z/')"
	)

	CGO_ENABLED=0 ego build -o git-pkgs -ldflags="${ldflags[*]}" .
	einfo generating completions
	./git-pkgs completion bash >bash-completions
	./git-pkgs completion fish >fish-completions
	./git-pkgs completion zsh >zsh-completions
}

src_install() {
	dobin git-pkgs

	dodoc -r docs
	if use doc; then
		doman man/*
	fi

	newbashcomp bash-completions "${PN}"
	newfishcomp fish-completions "${PN}".fish
	newzshcomp zsh-completions "${PN}"

	default
}
