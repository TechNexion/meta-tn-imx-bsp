FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://wm8960-audio.conf;subdir=alsa-ucm-conf \
            file://wm8960audio-HiFi.conf;subdir=alsa-ucm-conf"

do_install:append() {
	install -d ${D}${datadir}/alsa/ucm2/conf.d/fsl-asoc-card
	install -m 0644 ${UNPACKDIR}/alsa-ucm-conf/wm8960-audio.conf ${D}${datadir}/alsa/ucm2/conf.d/fsl-asoc-card/wm8960-audio.conf

	install -d ${D}${datadir}/alsa/ucm2/NXP/iMX8/TechNexion
	install -m 0644 ${UNPACKDIR}/alsa-ucm-conf/wm8960audio-HiFi.conf ${D}${datadir}/alsa/ucm2/NXP/iMX8/TechNexion/wm8960audio-HiFi.conf
}
