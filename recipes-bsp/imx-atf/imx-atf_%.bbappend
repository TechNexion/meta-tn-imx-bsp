FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_axon-imx8mm = " file://0001-imx8mm-rdc-assign-uart4-to-a53-domain.patch"

COMPATIBLE_MACHINE_axon-imx8mm = "axon-imx8mm"

SRCREV_mx8mq = "e2584c3bd06633f509b69fa8d7bb0c48d436175c"
COMPATIBLE_MACHINE_mx8mq = "mx8mq"
