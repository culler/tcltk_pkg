SHELL := /bin/bash
# Assume that Tcl has been installed from TclTk_src
TCL_FRAMEWORK := /Library/Frameworks/Tcl.framework
TK_FRAMEWORK := /Library/Frameworks/Tk.framework
TCL_VERSION := $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
TK_VERSION := $(shell readlink ${TK_FRAMEWORK}/Versions/Current)
TCL := ${TCL_FRAMEWORK}/Versions/${TCL_VERSION}
TK := ${TK_FRAMEWORK}/Versions/${TK_VERSION}

TDBCSQLITE3_SRC := tdbcsqlite3
TARBALL := tdbcsqlite3.tar.gz
TDBCSQLITE3_URL := https://core.tcl-lang.org/tdbcsqlite3/tarball/${TARBALL}
PACKAGE := dist/tdbcsqlite3
PKG_INDEX := ${TDBCSQLITE3_SRC}/pkgIndex.tcl
PACKAGE_FILES := ${PACKAGE}/pkgIndex.tcl ${PACKAGE}/tdbcsqlite3.tcl
INSTALL_DIR := ${TCL}/Resources/Scripts/tdbcsqlite3
TCLCONFIG_URL := https://core.tcl-lang.org/tclconfig/tarball/main/tclconfig.tgz
DEV_ID := $(shell source ../IDs.sh; echo $$DEV_ID)
CODESIGN_OPTS := -v -s ${DEV_ID} --options runtime --force --timestamp \
	--entitlements ../entitlements.plist
VERSION := $(shell grep "PACKAGE_VERSION=" ${TDBCSQLITE3_SRC}/configure | cut -d"'" -f2)

.phony: clean

tdbcsqlite3.pkg: ${PACKAGE_FILES}
	mkdir -p temp;
	pkgbuild --root ${PACKAGE} \
	  --identifier core.tcl-lang.org-tdbcsqlite${VERSION} \
	  --version ${VERSION} \
	  --install-location ${INSTALL_DIR} \
	  temp/tdbcsqlite3.pkg;
	productsign --sign ${DEV_ID} temp/tdbcsqlite3.pkg tdbcsqlite3.pkg

${PACKAGE_FILES}: ${TDBCSQLITE3_SRC} ${TDBCSQLITE3_SRC}/tclconfig
	mkdir -p ${PACKAGE} ${LIBRARY}
	cd ${TDBCSQLITE3_SRC}; \
	./configure --with-tdbc=../../TDBC_src/tdbc_src; \
	make
	sed 's/.. library //' ${PKG_INDEX} > ${PACKAGE}/pkgIndex.tcl
	cp ${TDBCSQLITE3_SRC}/library/tdbcsqlite3.tcl ${PACKAGE}

${TDBCSQLITE3_SRC}/tclconfig: tclconfig.tgz
	cd ${TDBCSQLITE3_SRC}; tar xvfz ../tclconfig.tgz

tclconfig.tgz:
	curl -L -O ${TCLCONFIG_URL}

${TDBCSQLITE3_SRC}: ${TARBALL}
	tar xfz ${TARBALL}

${TARBALL}:
	curl -L -o ${TARBALL} ${TDBCSQLITE3_URL}

clean:
	cd ${TDBCSQLITE3_SRC}; \
	if [ -e Makefile ]; then \
	    make distclean; \
	fi;
	rm -rf dist temp *.pkg
