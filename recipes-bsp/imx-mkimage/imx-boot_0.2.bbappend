SRCBRANCH = "imx_4.14.78_1.0.0_ga"
SRCREV = "2cf091c075ea1950afa22a56e224dc4e448db542"

DEPENDS_remove = "optee-os-imx"
DEPENDS_append = " optee-os-imx-tn"

do_compile () {
    if [ "${SOC_TARGET}" = "iMX8M" ]; then
        echo 8MQ boot binary build
        for ddr_firmware in ${DDR_FIRMWARE_NAME}; do
            echo "Copy ddr_firmware: ${ddr_firmware} from ${DEPLOY_DIR_IMAGE} -> ${S}/${SOC_TARGET} "
            cp ${DEPLOY_DIR_IMAGE}/${ddr_firmware}               ${S}/${SOC_TARGET}/
        done
        cp ${DEPLOY_DIR_IMAGE}/signed_hdmi_imx8m.bin             ${S}/${SOC_TARGET}/
        cp ${DEPLOY_DIR_IMAGE}/u-boot-spl.bin-${MACHINE}-${UBOOT_CONFIG} ${S}/${SOC_TARGET}/u-boot-spl.bin
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME}   ${S}/${SOC_TARGET}/
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/u-boot-nodtb.bin    ${S}/${SOC_TARGET}/
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/mkimage_uboot       ${S}/${SOC_TARGET}/

        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${ATF_MACHINE_NAME} ${S}/${SOC_TARGET}/bl31.bin
        cp ${DEPLOY_DIR_IMAGE}/${UBOOT_NAME}                     ${S}/${SOC_TARGET}/u-boot.bin

    elif [ "${SOC_TARGET}" = "iMX8QM" ]; then
        echo 8QM boot binary build
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${SC_FIRMWARE_NAME} ${S}/${SOC_TARGET}/scfw_tcm.bin
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${ATF_MACHINE_NAME} ${S}/${SOC_TARGET}/bl31.bin
        cp ${DEPLOY_DIR_IMAGE}/${UBOOT_NAME}                     ${S}/${SOC_TARGET}/u-boot.bin

        cp ${DEPLOY_DIR_IMAGE}/imx8qm_m4_0_TCM_rpmsg_lite_pingpong_rtos_linux_remote.bin ${S}/${SOC_TARGET}/m40_tcm.bin
        cp ${DEPLOY_DIR_IMAGE}/imx8qm_m4_1_TCM_rpmsg_lite_pingpong_rtos_linux_remote.bin ${S}/${SOC_TARGET}/m41_tcm.bin

    else
        echo 8QX boot binary build
        cp ${DEPLOY_DIR_IMAGE}/imx8qx_m4_TCM_rpmsg_lite_pingpong_rtos_linux_remote.bin ${S}/${SOC_TARGET}/m40_tcm.bin
        cp ${DEPLOY_DIR_IMAGE}/imx8qx_m4_TCM_rpmsg_lite_pingpong_rtos_linux_remote.bin ${S}/${SOC_TARGET}/CM4.bin
        cp ${DEPLOY_DIR_IMAGE}/ahab-container.img ${S}/${SOC_TARGET}/
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${SC_FIRMWARE_NAME} ${S}/${SOC_TARGET}/scfw_tcm.bin
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${ATF_MACHINE_NAME} ${S}/${SOC_TARGET}/bl31.bin
        cp ${DEPLOY_DIR_IMAGE}/${UBOOT_NAME}                     ${S}/${SOC_TARGET}/u-boot.bin
    fi

    # Copy TEE binary to SoC target folder to mkimage
    if ${DEPLOY_OPTEE}; then
        cp ${DEPLOY_DIR_IMAGE}/tee.bin             ${S}/${SOC_TARGET}/
    fi

    # mkimage for i.MX8
    for target in ${IMXBOOT_TARGETS}; do
        echo "building ${SOC_TARGET} - ${target}"
        make SOC=${SOC_TARGET} dtbs=${UBOOT_DTB_NAME} ${target}
        if [ -e "${S}/${SOC_TARGET}/flash.bin" ]; then
            cp ${S}/${SOC_TARGET}/flash.bin ${S}/${BOOT_CONFIG_MACHINE}-${target}
        fi
    done
}
