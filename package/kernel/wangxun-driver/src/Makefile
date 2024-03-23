################################################################################
#
# WangXun GbE PCI Express Linux Network Driver
# Copyright(c) 2015 - 2017 Beijing WangXun Technology Co., Ltd.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms and conditions of the GNU General Public License,
# version 2, as published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# The full GNU General Public License is included in this distribution in
# the file called "COPYING".
#
################################################################################

ifneq ($(KERNELRELEASE),)
# kbuild part of makefile
#
# Makefile for the WangXun(R) GbE PCI Express Linux Network Driver
#
CONFIG_NGBE=m
obj-$(CONFIG_NGBE) += ngbe.o

define ngbe-y
	ngbe_main.o
	ngbe_ethtool.o
	ngbe_lib.o
	ngbe_mbx.o
	ngbe_sriov.o
	ngbe_param.o
	ngbe_phy.o
	ngbe_procfs.o
	ngbe_hw.o
	ngbe_pcierr.o
endef
ngbe-y := $(strip ${ngbe-y})

ngbe-${CONFIG_DEBUG_FS} += ngbe_debugfs.o

ngbe-$(CONFIG_PTP_1588_CLOCK:m=y) += ngbe_ptp.o

ngbe-${CONFIG_SYSFS} += ngbe_sysfs.o

ngbe-y += kcompat.o

else	# ifneq($(KERNELRELEASE),)
# normal makefile

DRIVER := ngbe

include configure

ifeq (,$(wildcard common.mk))
  $(error Cannot find common.mk build rules)
else
  include common.mk
endif

# Check that kernel version is at least 2.6.0, since we don't support 2.4.x
# kernels with the ngbe driver. We can't use minimum_kver_check since SLES 10
# SP4's Make has a bug which causes $(eval) inside an ifeq conditional to error
# out. This was fixed in Make 3.81, but SLES 10 SP4 does not have a fix for
# this yet.
ifeq (0,$(shell [ ${KVER_CODE} -lt $(call get_kvercode,2,6,0) ]; echo "$?"))
  $(warning *** Aborting the build.)
  $(error This driver is not supported on kernel versions older than 2.6.0)
endif

######################
# Kernel Build Macro #
######################

# customized kernelbuild function
#
# ${1} is the kernel build target
# ${2} may contain extra rules to pass to kernelbuild macro
#
# We customize the kernelbuild target in order to provide our hack to disable
# CONFIG_PTP_1588_CLOCK support should -DNO_PTP_SUPPORT be defined in the extra
# cflags given on the command line.
devkernelbuild = $(call kernelbuild,$(if $(filter -DNO_PTP_SUPPORT,${EXTRA_CFLAGS}),CONFIG_PTP_1588_CLOCK=n) ${2},${1})

# Command to update initramfs or display a warning message
ifeq (${cmd_initrd},)
define cmd_initramfs
@echo "Unable to update initramfs. You may need to do this manually."
endef
else
define cmd_initramfs
@echo "Updating initramfs..."
-@$(call cmd_initrd)
endef
endif

###############
# Build rules #
###############


# Standard compilation, with regular output
default:
	@+$(call devkernelbuild,modules)

# Noisy output, for extra debugging
noisy:
	@+$(call devkernelbuild,modules,V=1)

# Silence any output generated
silent:
	@+$(call devkernelbuild,modules,>/dev/null)

# Enable higher warning level
checkwarnings: clean
	@+$(call devkernelbuild,modules,W=1)

# Run sparse static analyzer
sparse: clean
	@+$(call devkernelbuild,modules,C=2 CF="-D__CHECK_ENDIAN__ -Wbitwise -Wcontext")

# Run coccicheck static analyzer
ccc: clean
	@+$(call devkernelbuild,modules,coccicheck MODE=report))

# Build manfiles
manfile:
	@gzip -c ../${DRIVER}.${MANSECTION} > ${DRIVER}.${MANSECTION}.gz

# Clean the module subdirectories
clean:
	@+$(call devkernelbuild,clean)
	@-rm -rf *.${MANSECTION}.gz *.ko


# Install the modules and manpage
mandocs_install: manfile
	@echo "Copying manpages..."
	@install -D -m 644 ${DRIVER}.${MANSECTION}.gz ${INSTALL_MOD_PATH}${MANDIR}/man${MANSECTION}/${DRIVER}.${MANSECTION}.gz

# Install kernel module files. This target is called by the RPM specfile
# when generating binary RPMs, and is not expected to modify files outside
# of the build root. Thus, it must not update initramfs, or run depmod.
modules_install: default
	@echo "Installing modules..."
	@+$(call devkernelbuild,modules_install)
	@echo "Running depmod manually..."
	$(call cmd_depmod)

# After installing all the files, perform necessary work to ensure the
# system will use the new modules. This includes running depmod to update
# module dependencies and updating the initramfs image in case the module is
# loaded during early boot.
install: modules_install mandocs_install
	$(call cmd_initramfs)

mandocs_uninstall:
	@echo "Removing manpages..."
	if [ -e ${INSTALL_MOD_PATH}${MANDIR}/man${MANSECTION}/${DRIVER}.${MANSECTION}.gz ] ; then \
		rm -f ${INSTALL_MOD_PATH}${MANDIR}/man${MANSECTION}/${DRIVER}.${MANSECTION}.gz ; \
	fi;

# Remove installed module files. This target is called by the RPM specfile
# when generating binary RPMs, and is not expected to modify files outside
# of the build root. Thus, it must not update the initramfs image or run
# depmod.
modules_uninstall:
	@echo "Uninstalling modules..."
	rm -f ${INSTALL_MOD_PATH}/lib/modules/${KVER}/${INSTALL_MOD_DIR}/${DRIVER}.ko;
	@echo "Running depmod manually..."
	$(call cmd_depmod)

# After uninstalling all the files, perform necessary work to restore the
# system back to using the default kernel modules. This includes running
# depmod to update module dependencies and updating the initramfs image.
uninstall: modules_uninstall mandocs_uninstall
	$(call cmd_initramfs)

# Target used by rpmbuild spec file
rpm: default manfile
	@install -D -m 644 ${DRIVER}.${MANSECTION}.gz ${INSTALL_MOD_PATH}${MANDIR}/man${MANSECTION}/${DRIVER}.${MANSECTION}.gz
	@install -D -m 644 ${DRIVER}.ko ${INSTALL_MOD_PATH}/lib/modules/${KVER}/${INSTALL_MOD_DIR}/${DRIVER}.ko

########
# Help #
########
help:
	@echo 'Build targets:'
	@echo '  default             - Build module(s) with standard verbosity'
	@echo '  noisy               - Build module(s) with V=1 verbosity -- very noisy'
	@echo '  silent              - Build module(s), squelching all output'
	@echo ''
	@echo 'Static Analysis:'
	@echo '  checkwarnings       - Clean, then build module(s) with W=1 warnings enabled'
	@echo '  sparse              - Clean, then check module(s) using sparse'
	@echo '  ccc                 - Clean, then check module(s) using coccicheck'
	@echo ''
	@echo 'Cleaning targets:'
	@echo '  clean               - Clean files generated by kernel module build'
	@echo ''
	@echo 'Other targets:'
	@echo '  manfile             - Generate a gzipped manpage'
	@echo '  modules_install     - Install the module(s) only'
	@echo '  mandocs_install     - Install the manpage only'
	@echo '  install             - Build then install the module(s) and manpage, and update initramfs'
	@echo '  modules_uninstall   - Uninstall the module(s) only'
	@echo '  mandocs_uninstall   - Uninstall the manpage only'
	@echo '  uninstall           - Uninstall the module(s) and manpage, and update initramfs'
	@echo '  help                - Display this help message'
	@echo ''
	@echo 'Variables:'
	@echo '  LINUX_VERSION       - Debug tool to force kernel LINUX_VERSION_CODE. Use at your own risk.'
	@echo '  W=N                 - Kernel variable for setting warning levels'
	@echo '  V=N                 - Kernel variable for setting output verbosity'
	@echo '  INSTALL_MOD_PATH    - Add prefix for the module and manpage installation path'
	@echo '  INSTALL_MOD_DIR     - Use module directory other than updates/drivers/net/ethernet/wangxun/${DRIVER}'
	@echo '  CHNOS               - SELECT CHN OS [UOS, KYLIN, EULER]'
	@echo ' Other variables may be available for tuning make process, see'
	@echo ' Kernel Kbuild documentation for more information'

.PHONY: default noisy clean manfile silent sparse ccc modules_install mandocs_install install modules_install mandocs_install uninstall help kylin kylin_install

endif	# ifneq($(KERNELRELEASE),)
