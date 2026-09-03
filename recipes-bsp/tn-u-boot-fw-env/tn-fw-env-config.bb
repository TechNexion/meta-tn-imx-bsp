SUMMARY = "U-Boot environment configuration"
LICENSE = "CLOSED"

inherit allarch

do_install[depends] += "u-boot-tn-imx:do_deploy"

do_install() {
    install -d ${D}${sysconfdir}

    if [ ! -f "${DEPLOY_DIR_IMAGE}/fw_env.config" ]; then
        bbfatal "Cannot find ${DEPLOY_DIR_IMAGE}/fw_env.config"
    fi

    install -m 0644 \
        ${DEPLOY_DIR_IMAGE}/fw_env.config \
        ${D}${sysconfdir}/fw_env.config
}

FILES:${PN} += "${sysconfdir}/fw_env.config"