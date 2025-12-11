SHELL := /bin/bash
# Assume that Tcl has been installed from the TclTk_src
TCL_FRAMEWORK := /Library/Frameworks/Tcl.framework
TCL_VERSION = $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
TCLSH := ${TCL_FRAMEWORK}/Versions/Current/tclsh${TCL_VERSION}
SQLITE_VERSION := 3.50.4
SQLITE_SRC := sqlite-src-3500400
SQLITE_URL := https://sqlite.org/2025/sqlite-src-3500400.zip
SQLITE_CFLAGS := -arch x86_64 -arch arm64 -mmacosx-version-min=10.13
PACKAGE := sqlite${SQLITE_VERSION}
DYLIB := ${SQLITE_SRC}/libtcl9${PACKAGE}.dylib
PKG_INDEX := ${SQLITE_SRC}/pkgIndex.tcl
TCL_VER=`readlink ../TclTk_src/build/tk/Tcl.framework/Versions/Current`
FRAMEWORK="/Library/Frameworks/Tcl.framework"
INSTALL_DIR=${FRAMEWORK}/Versions/${TCL_VER}/Resources/Scripts/sqlite3
DEV_ID = $(shell source ../IDs.sh; echo $$DEV_ID)
CODESIGN_OPTS := -v -s ${DEV_ID} --options runtime --force --timestamp \
	--entitlements ../entitlements.plist

.phony: clean

sqlite.pkg: ${PACKAGE}
	mkdir -p temp;
	source ../IDs.sh; \
	pkgbuild --root ${PACKAGE} \
          --identifier core.tcl-lang.org-${PACKAGE} \
          --version ${SQLITE_VERSION} \
          --install-location ${INSTALL_DIR} \
          temp/sqlite.pkg;
	productsign --sign ${DEV_ID} temp/sqlite.pkg sqlite.pkg

${SQLITE_SRC}: ${SQLITE_SRC}.zip
	unzip ${SQLITE_SRC}.zip

${SQLITE_SRC}.zip:
	curl -L -O ${SQLITE_URL}

${DYLIB} ${PKG_INDEX}: ${SQLITE_SRC}
	export CC="gcc ${SQLITE_CFLAGS}"; \
	cd ${SQLITE_SRC}; \
	./configure --all --with-tcl="${TCL_FRAMEWORK}" -with-tclsh="${TCLSH}"; \
	CFLAGS="${SQLITE_CFLAGS}"; \
	make -e tclextension

${PACKAGE}: ${DYLIB} ${PKG_INDEX}
	mkdir -p ${PACKAGE}; \
	codesign ${CODESIGN_OPTS} ${DYLIB}; \
	cp ${DYLIB} ${PACKAGE}; \
	cp ${PKG_INDEX} ${PACKAGE}

clean:
	rm -rf temp
	rm -rf ${PACKAGE}
	rm -f *.pkg
	make -C ${SQLITE_SRC} clean
