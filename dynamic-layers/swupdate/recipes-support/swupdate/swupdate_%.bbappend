FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
		file://09-swupdate-args \
		file://hwrevision \
		file://swupdate.cfg \
		file://swu_public.pem \
"

DEPENDS += "u-boot-tn-imx"

SWU_HW_REV ?= "1.0"
SWU_TARGETID ?= "default"
SWU_SERVER ?= "https://www.technexion.com:8080"
SWU_TARGETTOKEN ?= "f0f605b5e37bcae5a7549b9c89352161"

do_install:append () {
	install -d ${D}/${sysconfdir}
	install -m 644 ${UNPACKDIR}/hwrevision ${D}${sysconfdir}
	install -m 644 ${UNPACKDIR}/swupdate.cfg ${D}/${sysconfdir}
	install -m 644 ${UNPACKDIR}/swu_public.pem ${D}/${sysconfdir}
	install -m 644 ${DEPLOY_DIR_IMAGE}/u-boot-tn-imx-initial-env-sd ${D}/${sysconfdir}/u-boot-tn-imx-initial-env
	install -d ${D}${libdir}/swupdate/conf.d
	install -m 644 ${UNPACKDIR}/09-swupdate-args ${D}${libdir}/swupdate/conf.d/

	sed -i -e 's,@MACHINE@,'${MACHINE}',g' ${D}${sysconfdir}/hwrevision
	sed -i -e 's,@HW_REV@,'${SWU_HW_REV}',g' ${D}${sysconfdir}/hwrevision

	sed -i -e 's,@TARGETID@,'${SWU_TARGETID}',g' ${D}${sysconfdir}/swupdate.cfg
	sed -i -e 's,@SERVERURL@,'${SWU_SERVER}',g' ${D}${sysconfdir}/swupdate.cfg
	sed -i -e 's,@TARGETTOKEN@,'${SWU_TARGETTOKEN}',g' ${D}${sysconfdir}/swupdate.cfg
}
