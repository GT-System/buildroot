################################################################################
#
# Open-AVB
#
################################################################################

OPEN_AVB_VERSION = v1.1-gcs
OPEN_AVB_SOURCE = open-avb-$(OPEN_AVB_VERSION).tar.gz
#OPEN_AVB_SITE = $(call github,GT-System,Open-AVB,$(OPEN_AVB_VERSION))
OPEN_AVB_SITE = https://github.com/GT-System/Open-AVB
OPEN_AVB_SITE_METHOD = git
OPEN_AVB_LICENSE = GPLv2+
OPEN_AVB_LICENSE_FILES =
OPEN_AVB_GIT_SUBMODULES = YES
OPEN_AVB_DEPENDENCIES += linux pciutils libpcap alsa-lib jack2 gstreamer gst-plugins-base

# KERNEL MODULE
OPEN_AVB_MODULE_SUBDIRS = kmod/igb
OPEN_AVB_MODULE_MAKE_OPTS = KVERSION=$(LINUX_VERSION_PROBED)
OPEN_AVB_MODULE_MAKE_OPTS += KSRC=$(LINUX_DIR)

# USE C99 Specific Features
OPEN_AVB_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=c99"

# USER MODE
define OPEN_AVB_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) lib CC=$(TARGET_CC) AR=$(TARGET_AR) RANLIB=$(TARGET_RANLIB) CROSS=$(TARGET_CROSS) EXTRA_CFLAGS="-D__UCLIBC__" -C $(@D)
	$(TARGET_MAKE_ENV) $(MAKE) daemons_all CC=$(TARGET_CC) CXX=$(TARGET_CXX) CROSS=$(TARGET_CROSS) EXTRA_CFLAGS="-D__UCLIBC__" -C $(@D)
	$(TARGET_MAKE_ENV) $(MAKE) examples_all CC=$(TARGET_CC) CXX=$(TARGET_CXX) CROSS=$(TARGET_CROSS) EXTRA_CFLAGS="-D__UCLIBC__" -C $(@D)
	$(TARGET_MAKE_ENV) $(MAKE) avtp_pipeline CC=$(TARGET_CC) CXX=$(TARGET_CXX) CROSS=$(TARGET_CROSS) EXTRA_CFLAGS="-D__UCLIBC__" -C $(@D)
endef

# INSTALL_TARGET
define OPEN_AVB_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/daemons/gptp/linux/build/obj/daemon_cl $(TARGET_DIR)/usr/bin/daemon_cl
	$(INSTALL) -D -m 0755 $(@D)/daemons/mrpd/mrpd $(TARGET_DIR)/usr/bin/mrpd
	$(INSTALL) -D -m 0755 $(@D)/daemons/maap/linux/maap_daemon $(TARGET_DIR)/usr/bin/maap_daemon
	$(INSTALL) -D -m 0755 $(@D)/lib/avtp_pipeline/build/bin/openavb_host $(TARGET_DIR)/usr/bin/openavb_host
	$(INSTALL) -D -m 0755 $(@D)/examples/simple_talker/simple_talker $(TARGET_DIR)/usr/bin/simple_talker
endef

$(eval $(kernel-module))
$(eval $(generic-package))
