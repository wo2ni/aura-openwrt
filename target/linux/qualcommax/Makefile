include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=qualcommax
BOARDNAME:=Qualcomm Atheros 802.11ax WiSoC-s
FEATURES:=squashfs ramdisk fpu nand rtc emmc
KERNELNAME:=Image dtbs
CPU_TYPE:=cortex-a53
SUBTARGETS:=ipq807x

KERNEL_PATCHVER:=6.1

include $(INCLUDE_DIR)/target.mk
DEFAULT_PACKAGES += \
	kmod-usb3 kmod-usb-dwc3 kmod-usb-dwc3-qcom \
	kmod-leds-gpio kmod-gpio-button-hotplug \
        autocore-arm wpad-openssl zram-swap \
	ath11k-firmware-ipq8074 kmod-qca-nss-dp \
	kmod-ath11k-ahb kmod-qca-nss-drv-64 \
	kmod-qca-nss-drv-pppoe-64 kmod-qca-nss-ecm-64 \
	nss-firmware-ipq8074 wpad-basic-mbedtls uboot-envtools \
	e2fsprogs kmod-fs-ext4 losetup

$(eval $(call BuildTarget))
