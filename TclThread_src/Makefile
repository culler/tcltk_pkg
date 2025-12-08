SHELL := /bin/bash
# Assume that Tcl has been installed from the TclTk_src
TCL_FRAMEWORK := /Library/Frameworks/Tcl.framework
TK_FRAMEWORK := /Library/Frameworks/Tk.framework
TCL_VERSION := $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
TK_VERSION := $(shell readlink ${TK_FRAMEWORK}/Versions/Current)
TCL := ${TCL_FRAMEWORK}/Versions/${TCL_VERSION}
TK := ${TK_FRAMEWORK}/Versions/${TK_VERSION}
TCLSH := ${TC}/tclsh${TCL_VERSION}
THREAD_VERSION := 3.0.3
THREAD_SRC := thread-${THREAD_VERSION}
THREAD_NAME := Thread${THREAD_VERSION}
TARBALL := ${THREAD_SRC}.tar.gz
THREAD_URL :=  https://core.tcl-lang.org/thread/tarball/thread-3-0-3/${TARBALL}
PACKAGE := dist/lib/thread${THREAD_VERSION}
INSTALL_DIR := ${TCL}/Resources/Scripts/thread
DYLIB := ${PACKAGE}/libtcl9${THREAD_NAME}.dylib
PKGINDEX := ${PACKAGE}/pkgIndex.tcl
TCLCONFIG_URL := https://core.tcl-lang.org/tclconfig/tarball/main/tclconfig.tgz
THREAD_CFLAGS := -arch x86_64 -arch arm64 -mmacosx-version-min=10.13
DEV_ID := $(shell source ../IDs.sh; echo $$DEV_ID)
CODESIGN_OPTS := -v -s ${DEV_ID} --options runtime --force --timestamp \
	--entitlements ../entitlements.plist

.phony: clean

thread.pkg: ${DYLIB} ${PKGINDEX}
	mkdir -p temp;
	pkgbuild --root ${PACKAGE} \
	  --identifier core.tcl-lang.org-${THREAD_NAME} \
	  --version ${THREAD_VERSION} \
	  --install-location ${INSTALL_DIR} \
	  temp/thread.pkg;
	productsign --sign ${DEV_ID} temp/thread.pkg thread.pkg

# WARNING: Doing a zipfs build makes the dylib unsignable!!
${DYLIB} ${PKGINDEX}: ${THREAD_SRC} ${THREAD_SRC}/tclconfig
	cd ${THREAD_SRC}/unix; \
	export CFLAGS="${THREAD_CFLAGS}"; \
	../configure --enable-threads \
	--prefix=/Users/culler/projects/tcltk_pkg/TclThread_src/dist \
	--exec-prefix=/Users/culler/projects/tcltk_pkg/TclThread_src/dist \
	--libdir=/Users/culler/projects/tcltk_pkg/TclThread_src/dist/lib \
	--with-tcl=${TCL} \
	--with-tclinclude=${TCL}/Headers; \
	make ZIPFS_BUILD=0 install
	codesign ${CODESIGN_OPTS} ${DYLIB}

${THREAD_SRC}/tclconfig: tclconfig.tgz
	cd ${THREAD_SRC}; tar xvfz ../tclconfig.tgz

tclconfig.tgz:
	curl -L -O ${TCLCONFIG_URL}

${THREAD_SRC}: ${TARBALL}
	tar xfz ${TARBALL}

${TARBALL}:
	curl -L -O ${THREAD_URL}

clean:
	cd ${THREAD_SRC}/unix; \
	if [ -e Makefile ]; then \
	    make distclean; \
	fi;
	rm -rf dist temp
