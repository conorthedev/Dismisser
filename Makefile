TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard
GO_EASY_ON_ME=1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Dismisser

Dismisser_FILES = Tweak.x
Dismisser_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
