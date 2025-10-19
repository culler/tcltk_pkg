TCLTLS_URL = https://chiselapp.com/user/bohagan/repository/TCLTLS
DEV_ID = $(shell source ../IDs.sh; echo $$DEV_ID)
PKG_NAME = $(shell ls dist-x86_64/lib)
DYLIB_NAME = libtcl9${PKG_NAME}.dylib
DYLIB = dist/${PKG_NAME}/${DYLIB_NAME}
CODESIGN_OPTS = runtime --force --timestamp --entitlements ../entitlements.plist
TCLTLS_VERSION = $(shell echo tls2.0b | sed -n 's/^tls\([0-9\.]*\).*/\1/p')
TCL_VER=`readlink ../TclTk_src/build/tk/Tcl.framework/Versions/Current`
FRAMEWORK="/Library/Frameworks/Tcl.framework"
INSTALL_DIR=${FRAMEWORK}/Versions/${TCL_VER}/Resources/Scripts/tcltls

.phony: package clean

tcltls.pkg: ${DYLIB}
	mkdir -p temp;
	pkgbuild --root dist/${PKG_NAME} \
          --identifier core.tcl-lang.org-${PKG_NAME} \
          --version ${TCLTLS_VERSION} \
          --install-location ${INSTALL_DIR} \
          temp/tcltls.pkg;
	productsign --sign ${DEV_ID} temp/tcltls.pkg tcltls.pkg

${DYLIB}: tcltls
	mkdir -p dist
	make ARCH=x86_64 -f makefile_arch
	make ARCH=arm64 -f makefile_arch
	cp -a dist-x86_64/lib/${PKG_NAME} dist
	lipo -create \
	    dist-x86_64/lib/${PKG_NAME}/${DYLIB_NAME} \
	    dist-arm64/lib/${PKG_NAME}/${DYLIB_NAME} \
	    -output ${DYLIB}
	codesign -s ${DEV_ID} --options ${CODESIGN_OPTS} ${DYLIB}

tcltls: tcltls.tar.gz
	tar xfz tcltls.tar.gz

tcltls.tar.gz:
	curl -L -O ${TCLTLS_URL}/tarball/tcltls.tar.gz

