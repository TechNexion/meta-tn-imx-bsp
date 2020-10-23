# Copyright (C) 2020 Wig Cheng <wig.cheng@technexion.com>
# Released under the MIT license (see COPYING.MIT for the terms)
SUMMARY = "libqmi is a library for talking to WWAN devices by QMI protocol"
DESCRIPTION = "libqmi is a glib-based library for talking to WWAN modems and \
               devices which speak the Qualcomm MSM Interface (QMI) protocol"
HOMEPAGE = "http://www.freedesktop.org/wiki/Software/libqmi"
LICENSE = "GPLv2 & LGPLv2.1"
LIC_FILES_CHKSUM = " \
    file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://COPYING.LIB;md5=4fbd65380cdd255951079008b364516c \
"

DEPENDS = "glib-2.0 glib-2.0-native"

inherit autotools pkgconfig bash-completion gobject-introspection

SRC_URI = "git://gitlab.freedesktop.org/carlyin/libqmi.git;protocol=https;branch=nr5g"
SRCREV = "5b90285d98c1512b504e7833845be474f78ffa3b"
S = "${WORKDIR}/git"

PACKAGECONFIG ??= "udev mbim"
PACKAGECONFIG[udev] = ",--without-udev,libgudev"
PACKAGECONFIG[mbim] = "--enable-mbim-qmux,--disable-mbim-qmux,libmbim"

EXTRA_AUTORECONF = ""
DEBUG_BUILD = "1"
CFLAGS += "-O2 -D_FORTIFY_SOURCE=2"
