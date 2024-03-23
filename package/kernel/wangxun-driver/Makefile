# Wangxun 

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=wangxun-driver
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define KernelPackage/wangxun-driver
  SUBMENU:=Network Devices
  TITLE:= Wangxun 10Gb Ethernet driver
  FILES:=$(PKG_BUILD_DIR)/ngbe.ko
  AUTOLOAD:=$(call AutoProbe,ngbe)
  KCONFIG:=
  DEPENDS:=+kmod-libphy
endef

define KernelPackage/wangxun-driver/description
	Driver for Wangxun 10Gb Ethernet Network Cards.
endef

define Build/Compile
	$(KERNEL_MAKE) M=$(PKG_BUILD_DIR) modules
endef

$(eval $(call KernelPackage,wangxun-driver))
