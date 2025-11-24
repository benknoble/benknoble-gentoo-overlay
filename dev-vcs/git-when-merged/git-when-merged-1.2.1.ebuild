# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..14} )
DISTUTILS_USE_PEP517=setuptools
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

inherit distutils-r1

DESCRIPTION="Determine when a particular commit was merged into a git branch"
HOMEPAGE="https://github.com/mhagger/git-when-merged"
SRC_URI="https://github.com/mhagger/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	${DEPEND}
"
BDEPEND="${RDEPEND}"
