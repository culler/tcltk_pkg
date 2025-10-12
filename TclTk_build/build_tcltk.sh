#!/bin/bash
source ../IDs.sh

BRANCH="main"
TCL_URL="https://core.tcl-lang.org/tcl/tarball/${BRANCH}/tcl.tar.gz"
TK_URL="https://core.tcl-lang.org/tk/tarball/${BRANCH}/tk.tar.gz"

TCL_FRAMEWORK="build/tk/Tcl.framework"
TCL_VERSION_DIR="${TCL_FRAMEWORK}/Versions/Current"
TK_FRAMEWORK="build/tk/Tk.framework"
TK_VERSION_DIR="${TK_FRAMEWORK}/Versions/Current"
WISH_APP="${TK_VERSION_DIR}/Resources/Wish.app"
CODESIGN_OPTS="-v -s A3LBEGBB69 --options runtime --force \
--timestamp --entitlements ../entitlements.plist"

if [ ! -e tcl.tar.gz ]; then
    curl -L -O ${TCL_URL}
fi
if [ ! -e tk.tar.gz ]; then
    curl -L -O ${TK_URL}
fi

rm -rf tcl tk build
tar xfz tcl.tar.gz
tar xfz tk.tar.gz

export CFLAGS="-arch x86_64 -arch arm64 -mmacosx-version-min=10.13"
pushd tcl
make -C macosx deploy
popd

pushd tk
make -C macosx deploy
popd

cp build/tcl/tclsh* ${TCL_VERSION_DIR}
pushd ${TCL_VERSION_DIR}
mkdir -p Resources
for rsrc in `ls *.sh *.a`; do
    mv $rsrc Resources 
    ln -s Resources/${rsrc} ${rsrc}
done
popd

cp build/tk/wish* ${TK_VERSION_DIR}
pushd ${TK_VERSION_DIR}
mkdir -p Resources
for rsrc in `ls *.sh *.a`; do
    mv $rsrc Resources
    ln -s Resources/${rsrc} ${rsrc}
done
popd

codesign ${CODESIGN_OPTS} ${TCL_VERSION_DIR}/tclsh*
codesign ${CODESIGN_OPTS} ${TCL_VERSION_DIR}/Tcl
codesign ${CODESIGN_OPTS} ${TCL_FRAMEWORK}
codesign ${CODESIGN_OPTS} ${TK_VERSION_DIR}/wish*
codesign ${CODESIGN_OPTS} ${TK_VERSION_DIR}/Tk
codesign ${CODESIGN_OPTS} ${WISH_APP}/Contents/MacOS/Wish
codesign ${CODESIGN_OPTS} ${WISH_APP}
codesign ${CODESIGN_OPTS} ${TK_FRAMEWORK}

VRSN=`readlink build/tk/Tk.framework/Versions/Current`
PKG_ROOT=build/tk

# Tcl package parameters
TCL_PKG_ID="org.tcl-lang.core-Tcl${VRSN}"
TCL_FRAMEWORK="${PKG_ROOT}/Tcl.framework"
TCL_TARGET="/Library/Frameworks/Tcl.framework"

# Tk package parameters
TK_PKG_ID="org.tcl-lang.core-Tk${VRSN}"
TK_FRAMEWORK="${PKG_ROOT}/Tk.framework"
TK_TARGET="/Library/Frameworks/Tk.framework"

mkdir -p temp

# Build and sign a package for the Tcl framework.
pkgbuild --root ${TCL_FRAMEWORK} \
         --identifier $TCL_PKG_ID \
         --version ${VRSN} \
         --install-location ${TCL_TARGET} \
         --scripts TclScripts \
         temp/tcl.pkg
productsign --sign $DEV_ID temp/tcl.pkg tcl.pkg

# Build and sign a package for the Tk framework.
pkgbuild --root ${TK_FRAMEWORK} \
         --identifier ${TK_PKG_ID} \
         --version ${VRSN} \
         --install-location ${TK_TARGET} \
         --scripts TkScripts \
         temp/tk.pkg
productsign --sign ${DEV_ID} temp/tk.pkg tk.pkg
