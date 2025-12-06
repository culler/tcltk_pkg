SHELL := /bin/bash
TCL_FRAMEWORK := ../../TclTk_src/build/tcl/Tcl.framework
TCL_VERSION = $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
TCLSH := ../../TclTk_src/build/tcl/tclsh${TCL_VERSION}
SQLITE_VERSION := 3.50.4
SQLITE_DIR := sqlite-src-3500400
SQLITE_URL := https://sqlite.org/2025/sqlite-src-3500400.zip
SQLITE_CFLAGS := -arch x86_64 -arch arm64 -mmacosx-version-min=10.13
SQLITE := sqlite${SQLITE_VERSION}
DYLIB := ${SQLITE_DIR}/libtcl9${SQLITE}.dylib
INDEX := ${SQLITE_DIR}/pkgIndex.tcl
TCL_VER=`readlink ../TclTk_src/build/tk/Tcl.framework/Versions/Current`
FRAMEWORK="/Library/Frameworks/Tcl.framework"
INSTALL_DIR=${FRAMEWORK}/Versions/${TCL_VER}/Resources/Scripts
DEV_ID = $(shell source ../IDs.sh; echo $$DEV_ID)
CODESIGN_OPTS := -v -s ${DEV_ID} --options runtime --force --timestamp \
	--entitlements ../entitlements.plist

.phony: clean

${SQLITE}.pkg: ${SQLITE}
	mkdir -p temp;
	source ../IDs.sh; \
	pkgbuild --root ${SQLITE} \
          --identifier core.tcl-lang.org-${SQLITE} \
          --version ${SQLITE_VERSION} \
          --install-location ${INSTALL_DIR} \
          temp/sqlite.pkg;
	productsign --sign ${DEV_ID} temp/sqlite.pkg sqlite.pkg

${SQLITE_DIR}: ${SQLITE_DIR}.zip
	unzip ${SQLITE_DIR}.zip

${SQLITE_DIR}.zip:
	curl -L -O ${SQLITE_URL}

${DYLIB} ${INDEX}: ${SQLITE_DIR}
	cd ${SQLITE_DIR}; \
	./configure --with-tcl="${TCL_FRAMEWORK}" -with-tclsh="${TCLSH}"; \
	CFLAGS="${SQLITE_CFLAGS}"; \
	make -e tclextension

${SQLITE}: ${DYLIB} ${INDEX}
	mkdir -p ${SQLITE}; \
	codesign ${CODESIGN_OPTS} ${DYLIB}; \
	cp ${DYLIB} ${SQLITE}; \
	cp ${INDEX} ${SQLITE}

clean:
	rm -rf temp
	rm -rf ${SQLITE}
	rm -f *.pkg
	make -C ${SQLITE_DIR} clean
