# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev desktop

DESCRIPTION="Flash and observe ZSA keyboards"
HOMEPAGE="https://www.zsa.io/flash"
SRC_URI="https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz -> ${P}.tar.gz"

LICENSE="unknown"
SLOT="0"

PROPERTIES=live

# The wiki [1] says webkit2gtk4.1 is desired, so explicitly request that slot.
# Same for gtk+ (v3).
#
# [1]: https://github.com/zsa/wally/wiki/Linux-install
DEPEND="
	acct-group/plugdev
	>=dev-libs/libusb-1.0.0
	net-libs/webkit-gtk:4.1/0
	>=x11-libs/gtk+-3.0.0:3
	virtual/udev
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	# The archive does not have a base directory; it directly contains files
	mkdir ${P}
	(pushd ${P} && unpack ${A})
}

src_install() {
	cat <<-EOF >50-zsa.rules
	# Rules for Oryx web flashing and live training
	KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
	KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

	# Legacy rules for live training over webusb (Not needed for firmware v21+)
	  # Rule for all ZSA keyboards
	  SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
	  # Rule for the Moonlander
	  SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
	  # Rule for the Ergodox EZ
	  SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
	  # Rule for the Planck EZ
	  SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

	# Wally Flashing rules for the Ergodox EZ
	ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
	ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
	SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
	KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

	# Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
	SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
	# Keymapp Flashing rules for the Voyager
	SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
	EOF

	udev_dorules 50-zsa.rules

	dobin keymapp
	newicon icon.png "${PN}.png"
}

pkg_postinst() {
	udev_reload

	elog "To use ${PN} you must be in the plugdev group"
}

pkg_postrm() {
	udev_reload
}
