FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Do not start the service during system boot up
INITSCRIPT_PARAMS_${PN} = "stop 20 0 1 6 ."

# Add patches for QCA modules with Qca6174 and Qca9377-3 chips
SRC_URI += " \
            file://0001-hciattach_rome-do-not-override-module-MAC-address.patch \
            file://0002-hciattach_rome-set-IBS-to-disable-and-PCM-to-slave-b.patch \
            file://0003-hciattach_rome-load-3.2-version-of-firmware-by-defau.patch \
"
