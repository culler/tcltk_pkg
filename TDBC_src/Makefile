SHELL := /bin/bash
# Assume that Tcl has been installed from TclTk_src
TCL_FRAMEWORK := /Library/Frameworks/Tcl.framework
TK_FRAMEWORK := /Library/Frameworks/Tk.framework
TCL_VERSION := $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
TK_VERSION := $(shell readlink ${TK_FRAMEWORK}/Versions/Current)
TCL := ${TCL_FRAMEWORK}/Versions/${TCL_VERSION}
TK := ${TK_FRAMEWORK}/Versions/${TK_VERSION}
TDBC_SRC := tdbc_src
TARBALL := tdbc.tar.gz
TDBC_URL =  https://core.tcl-lang.org/tdbc/tarball/main/tdbc_src
PACKAGE := dist/lib/tdbc
INSTALL_DIR := ${TCL}/Resources/Scripts/tdbc
DYLIB := ${PACKAGE}/libtcl9${THREAD_NAME}.dylib
PKGINDEX := ${PACKAGE}/pkgIndex.tcl
TCLCONFIG_URL := https://core.tcl-lang.org/tclconfig/tarball/main/tclconfig.tgz
THREAD_CFLAGS := -arch x86_64 -arch arm64 -mmacosx-version-min=10.13
DEV_ID := $(shell source ../IDs.sh; echo $$DEV_ID)
CODESIGN_OPTS := -v -s ${DEV_ID} --options runtime --force --timestamp \
	--entitlements ../entitlements.plist

.phony: clean

tdbc.pkg: dist/tdbc
	mkdir -p temp;
	export VER=$(shell grep tdbc_VERSION dist/tdbc/tdbcConfig.sh | cut -d\= -f2);\
	pkgbuild --root dist/tdbc \
	  --identifier core.tcl-lang.org-tdbc$${VER} \
	  --version $${VER} \
	  --install-location ${INSTALL_DIR} \
	  temp/tdbc.pkg;
	productsign --sign ${DEV_ID} temp/tdbc.pkg tdbc.pkg

dist/tdbc: ${TDBC_SRC} ${TDBC_SRC}/tclconfig
	export PREFIX=$(shell pwd)/dist; \
	cd ${TDBC_SRC}; \
	./configure \
	--prefix=$$PREFIX \
	--exec-prefix=$$PREFIX; \
	make install
	mv dist/lib/tdbc* dist/tdbc
	codesign ${CODESIGN_OPTS} dist/tdbc/*.dylib

${TDBC_SRC}/tclconfig: tclconfig.tgz
	cd ${TDBC_SRC}; tar xvfz ../tclconfig.tgz

tclconfig.tgz:
	curl -L -O ${TCLCONFIG_URL}

${TDBC_SRC}: ${TARBALL}
	tar xfz ${TARBALL}

${TARBALL}:
	curl -L -o ${TARBALL} ${TDBC_URL}

clean:
	cd ${TDBC_SRC}; \
	if [ -e Makefile ]; then \
	    make distclean; \
	fi;
	rm -rf dist temp *.pkg
