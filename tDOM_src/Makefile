SHELL := /bin/bash
# Assume that Tcl has been installed from TclTk_src
TCL_FRAMEWORK := /Library/Frameworks/Tcl.framework
TK_FRAMEWORK := /Library/Frameworks/Tk.framework
TCL_VERSION := $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
TK_VERSION := $(shell readlink ${TK_FRAMEWORK}/Versions/Current)
TCL := ${TCL_FRAMEWORK}/Versions/${TCL_VERSION}
TK := ${TK_FRAMEWORK}/Versions/${TK_VERSION}
TDOM_VERSION := 0.9.6
TDOM_SRC := tdom-${TDOM_VERSION}-src
TARBALL := ${TDOM_SRC}.tgz
TDOM_URL := https://tdom.org/downloads/${TARBALL}
PACKAGE := lib/tdom${TDOM_VERSION}
INSTALL_DIR := ${TCL}/Resources/Scripts/tdom
TDOM_CFLAGS := -arch x86_64 -arch arm64 -mmacosx-version-min=10.13
PREFIX := $(shell pwd)
DEV_ID := $(shell source ../IDs.sh; echo $$DEV_ID)
CODESIGN_OPTS := -v -s ${DEV_ID} --options runtime --force --timestamp \
	--entitlements ../entitlements.plist

.phony: clean

tdom.pkg: ${PACKAGE}
	mkdir -p temp;
	pkgbuild --root ${PACKAGE} \
	  --identifier core.tcl-lang.org-tdom${TDOM_VERSION} \
	  --version ${TDOM_VERSION} \
	  --install-location ${INSTALL_DIR} \
	  temp/tdom.pkg;
	productsign --sign ${DEV_ID} temp/tdom.pkg tdom.pkg

${PACKAGE}: ${TDOM_SRC}
	cd ${TDOM_SRC}; \
	export CFLAGS="${TDOM_CFLAGS}"; \
	./configure \
	  --prefix=${PREFIX} \
	  --exec-prefix=${PREFIX} \
	  --with-tcl=${TCL} \
	  --with-tcl-headers=/${TCL}/Headers; \
	make install
	codesign ${CODESIGN_OPTS} ${PACKAGE}/*.dylib

${TDOM_SRC}: ${TARBALL}
	tar xfz ${TARBALL}

${TARBALL}:
	curl -L -o ${TARBALL} ${TDOM_URL}

clean:
	cd ${TDOM_SRC}; \
	if [ -e Makefile ]; then \
	    make distclean; \
	fi;
	rm -rf bin lib include share tdom.pkg
