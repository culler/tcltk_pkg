#!/bin/bash
source ../IDs.sh
TCLLIB=`ls dist/lib | grep 'tcllib\([0-9]*\.[0=9]*\)'`
TCLLIB_VER=`echo ${TCLLIB} | sed 's/tcllib//'`
TCL_VER=`readlink ../TclTk_src/build/tk/Tcl.framework/Versions/Current`
FRAMEWORK="/Library/Frameworks/Tcl.framework"
INSTALL_DIR=${FRAMEWORK}/Versions/${TCL_VER}/Resources/Scripts
mkdir -p temp
pkgbuild --root dist/lib/${TCLLIB} \
         --identifier core.tcl-lang.org-tcllib${TCLLIB_VER} \
         --version ${TCLLIB_VER} \
         --install-location ${INSTALL_DIR} \
         temp/tcllib.pkg ;
productsign --sign $DEV_ID temp/tcllib.pkg tcllib.pkg
