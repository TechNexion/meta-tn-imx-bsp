inherit image_types_fsl

#
# Generate the boot image with the boot scripts and required Device Tree
# files
#
# Override _generate_boot_image()
#
_generate_boot_image() {
	local boot_part=$1

	# Create boot partition image
	BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDCARD} unit b print \
	                  | awk "/ $boot_part / { print substr(\$4, 1, length(\$4 -1)) / 1024 }")

	# mkdosfs will sometimes use FAT16 when it is not appropriate,
	# resulting in a boot failure from SYSLINUX. Use FAT32 for
	# images larger than 512MB, otherwise let mkdosfs decide.
	if [ $(expr $BOOT_BLOCKS / 1024) -gt 512 ]; then
		FATSIZE="-F 32"
	fi

	rm -f ${WORKDIR}/boot.img
	mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 ${FATSIZE} -C ${WORKDIR}/boot.img $BOOT_BLOCKS

	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin ::/${KERNEL_IMAGETYPE}

	# Copy boot scripts
	for item in ${BOOT_SCRIPTS}; do
		src=`echo $item | awk -F':' '{ print $1 }'`
		dst=`echo $item | awk -F':' '{ print $2 }'`

		mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/$src ::/$dst
	done

	# Copy u-boot.img to first FAT partition
	if [ -n "${SPL_BINARY}" ]; then
		mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX_SDCARD} ::/u-boot.img
	fi

	# Copy device tree file
	if test -n "${KERNEL_DEVICETREE}"; then
		for DTS_FILE in ${KERNEL_DEVICETREE}; do
			DTS_BASE_NAME=`basename ${DTS_FILE} | awk -F "." '{print $1}'`
			if [ -e "${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${DTS_BASE_NAME}.dtb" ]; then
				kernel_bin="`readlink ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin`"
				kernel_bin_for_dtb="`readlink ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${DTS_BASE_NAME}.dtb | sed "s,$DTS_BASE_NAME,${MACHINE},g;s,\.dtb$,.bin,g"`"
				if [ $kernel_bin = $kernel_bin_for_dtb ]; then
					mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${DTS_BASE_NAME}.dtb ::/${DTS_BASE_NAME}.dtb
				fi
			else
				bbfatal "${DTS_FILE} does not exist."
			fi
		done
	fi

	# Copy extlinux.conf to images that have U-Boot Extlinux support.
	if [ "${UBOOT_EXTLINUX}" = "1" ]; then
		mmd -i ${WORKDIR}/boot.img ::/extlinux
		mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/extlinux.conf ::/extlinux/extlinux.conf
	fi

        # Copy additional files to boot partition: such as m4 images and firmwares
        if [ -n "${IMAGE_BOOTFILES}" ]; then
            for IMAGE_FILE in ${IMAGE_BOOTFILES}; do
                if [ -e "${DEPLOY_DIR_IMAGE}/${IMAGE_FILE}" ]; then
                    mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${IMAGE_FILE} ::/${IMAGE_FILE}
                else
                    bbfatal "${IMAGE_FILE} does not exist."
                fi
            done
        fi

    # add tee to boot image
    if ${@bb.utils.contains('COMBINED_FEATURES', 'optee', 'true', 'false', d)}; then
        for UTEE_FILE_PATH in `find ${DEPLOY_DIR_IMAGE} -maxdepth 1 -type f -name 'uTee-*' -print -quit`; do
            UTEE_FILE=`basename ${UTEE_FILE_PATH}`
            mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${UTEE_FILE} ::/${UTEE_FILE}
        done
    fi

}

#
# Create an image that can by written onto a SD card using dd for use
# with i.MX SoC family
#
# External variables needed:
#   ${SDCARD_ROOTFS}    - the rootfs image to incorporate
#   ${IMAGE_BOOTLOADER} - bootloader to use {u-boot, barebox}
#
# The disk layout used is:
#
#    0                      -> IMAGE_ROOTFS_ALIGNMENT         - reserved to bootloader (not partitioned)
#    IMAGE_ROOTFS_ALIGNMENT -> BOOT_SPACE                     - kernel and other data
#    BOOT_SPACE             -> SDIMG_SIZE                     - rootfs
#
#                                                     Default Free space = 1.3x
#                                                     Use IMAGE_OVERHEAD_FACTOR to add more space
#                                                     <--------->
#            4MiB               8MiB           SDIMG_ROOTFS                    4MiB
# <-----------------------> <----------> <----------------------> <------------------------------>
#  ------------------------ ------------ ------------------------ -------------------------------
# | IMAGE_ROOTFS_ALIGNMENT | BOOT_SPACE | ROOTFS_SIZE            |     IMAGE_ROOTFS_ALIGNMENT    |
#  ------------------------ ------------ ------------------------ -------------------------------
# ^                        ^            ^                        ^                               ^
# |                        |            |                        |                               |
# 0                      4096     4MiB +  8MiB       4MiB +  8Mib + SDIMG_ROOTFS   4MiB +  8MiB + SDIMG_ROOTFS + 4MiB
generate_imx_sdcard () {
	# Create partition table
	parted -s ${SDCARD} mklabel msdos
	parted -s ${SDCARD} unit KiB mkpart primary fat32 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED})
	parted -s ${SDCARD} unit KiB mkpart primary $(expr  ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED}) $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ $ROOTFS_SIZE)
	parted ${SDCARD} print

	# Burn bootloader
	case "${IMAGE_BOOTLOADER}" in
		imx-bootlets)
			bberror "The imx-bootlets is not supported for i.MX based machines"
			exit 1
		;;
		imx-boot)
			dd if=${DEPLOY_DIR_IMAGE}/imx-boot-${MACHINE}-${UBOOT_CONFIG}.bin of=${SDCARD} conv=notrunc seek=${IMX_BOOT_SEEK} bs=1K
		;;
        u-boot)
		if [ -n "${SPL_BINARY}" ]; then
			if [ -n "${SPL_SEEK}" ]; then
				dd if=${DEPLOY_DIR_IMAGE}/${SPL_BINARY} of=${SDCARD} conv=notrunc seek=${SPL_SEEK} bs=1K
				#dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX_SDCARD} of=${SDCARD} conv=notrunc seek=${UBOOT_SEEK} bs=1K
			else
				dd if=${DEPLOY_DIR_IMAGE}/${SPL_BINARY} of=${SDCARD} conv=notrunc seek=2 bs=512
				#dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX_SDCARD} of=${SDCARD} conv=notrunc seek=69 bs=1K
			fi
		else
			dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX_SDCARD} of=${SDCARD} conv=notrunc seek=2 bs=512
		fi
		;;
		barebox)
			dd if=${DEPLOY_DIR_IMAGE}/barebox-${MACHINE}.bin of=${SDCARD} conv=notrunc seek=1 skip=1 bs=512
			dd if=${DEPLOY_DIR_IMAGE}/bareboxenv-${MACHINE}.bin of=${SDCARD} conv=notrunc seek=1 bs=512k
		;;
		"")
		;;
		*)
			bberror "Unknown IMAGE_BOOTLOADER value"
			exit 1
		;;
	esac

	_generate_boot_image 1

	# Burn Partition
	dd if=${WORKDIR}/boot.img of=${SDCARD} conv=notrunc,fsync seek=1 bs=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)
	dd if=${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc,fsync seek=1 bs=$(expr ${BOOT_SPACE_ALIGNED} \* 1024 + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)

	# md5 checksum the disk image
	md5sum ${SDCARD} > ${SDCARD}.md5.txt
}

