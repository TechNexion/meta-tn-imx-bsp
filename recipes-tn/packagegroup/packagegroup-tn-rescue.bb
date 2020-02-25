# Copyright (C) 2012-2014, 2016 Freescale Semiconductor
# Copyright (C) 2015, 2016 O.S. Systems Software LTDA.
# Copyright (C) 2020, 2016 TechNexion Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Packagegroup used by TechNexion to provide a set of packages and utilities \
for rescue loader."
SUMMARY = "TechNexion packagroup - tools/rescue"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RESCUE_PACKAGES = " \
    rescue-loader \
"

PYTHON_PACKAGES = " \
    python-subprocess \
    python-datetime \
    python-json \
"

X11DEP_PACKAGES = " \
	qt4-embedded \
	python-pyqt \
"

RDEPENDS_${PN} = " \
    ${RESCUE_PACKAGES} \
    ${PYTHON_PACKAGES} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'weston-examples clutter-1.0-examples', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', "${X11DEP_PACKAGES}", '', d)} \
"

# FIXME: i.MX6SL cannot use mesa for Graphics and it lacks GL support,
#        so for now we skip it.
RDEPENDS_IMX_TO_REMOVE = ""
RDEPENDS_IMX_TO_REMOVE_imxgpu2d = "clutter-1.0-examples"
RDEPENDS_IMX_TO_REMOVE_imxgpu3d = ""

RDEPENDS_${PN}_remove = "${RDEPENDS_IMX_TO_REMOVE}"

