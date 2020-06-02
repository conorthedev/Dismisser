TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DismisserPrefs

DismisserPrefs_FILES = $(wildcard *.m) $(wildcard SkittyPrefs/*.m)
DismisserPrefs_FRAMEWORKS = UIKit
DismisserPrefs_PRIVATE_FRAMEWORKS = Preferences
DismisserPrefs_INSTALL_PATH = /Library/PreferenceBundles
DismisserPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
