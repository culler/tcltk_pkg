SHELL := /bin/bash
# Assume that Tcl has been installed from the TclTk_src
TCL_FRAMEWORK := /Library/Frameworks/Tcl.framework
TK_FRAMEWORK := /Library/Frameworks/Tk.framework
TCL_VERSION := $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
TK_VERSION := $(shell readlink ${TK_FRAMEWORK}/Versions/Current)
TCL := ${TCL_FRAMEWORK}/Versions/${TCL_VERSION}
TK := ${TK_FRAMEWORK}/Versions/${TK_VERSION}
TCLSH := ${TC}/tclsh${TCL_VERSION}
TKIMG_VERSION := 2.1.0
TKIMG_SRC := Img-${TKIMG_VERSION}
TKIMG_NAME := Img${TKIMG_VERSION}
URL := https://sourceforge.net/projects/tkimg/files/tkimg/2.1/tkimg%20${TKIMG_VERSION}
TARBALL := ${TKIMG_SRC}.tar.gz
PREFIX := $(shell pwd)
PACKAGE := lib/${TKIMG_NAME}
INSTALL_DIR := ${TK}/Resources/Scripts/tkimg
TKIMG_CFLAGS := -arch x86_64 -arch arm64 -mmacosx-version-min=10.13
DEV_ID := $(shell source ../IDs.sh; echo $$DEV_ID)
CODESIGN_OPTS := -v -s ${DEV_ID} --options runtime --force --timestamp \
	--entitlements ../entitlements.plist

.phony: clean

tkimg.pkg: ${PACKAGE}
	mkdir -p temp;
	source ../IDs.sh; \
	pkgbuild --root ${PACKAGE} \
	  --identifier core.tcl-lang.org-${TKIMG_NAME} \
	  --version ${TKIMG_VERSION} \
	  --install-location ${INSTALL_DIR} \
	  temp/tkimg.pkg; \
        productsign --sign $${DEV_ID} temp/tkimg.pkg tkimg.pkg

${PACKAGE}: ${TKIMG_SRC}
	source ../IDs.sh; \
	export CFLAGS="${TKIMG_CFLAGS}"; \
	cd ${TKIMG_SRC}; \
	./configure \
	  --with-tcl=${TCL} \
	  --with-tk=${TK} \
	  --prefix=${PREFIX} \
	  --exec-prefix=${PREFIX}; \
	make install-libraries
	codesign ${CODESIGN_OPTS} ${PACKAGE}/*.dylib

${TKIMG_SRC}: ${TARBALL}
	tar xfz ${TARBALL}

${TARBALL}:
	curl -L -o ${TARBALL} ${URL}

clean:
	rm -rf *.pkg
	rm -rf lib include
	make -C ${TKIMG_SRC} distclean || true

