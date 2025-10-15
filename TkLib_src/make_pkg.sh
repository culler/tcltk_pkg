#!/bin/bash
source ../IDs.sh
TKLIB=`ls dist/lib | grep 'tklib\([0-9]*\.[0=9]*\)'`
TKLIB_VER=`echo ${TKLIB} | sed 's/tklib//'`
TCL_VER=`readlink ../TclTk_src/build/tk/Tcl.framework/Versions/Current`
FRAMEWORK="/Library/Frameworks/Tcl.framework"
INSTALL_DIR=${FRAMEWORK}/Versions/${TCL_VER}/Resources/Scripts
mkdir -p temp
pkgbuild --root dist/lib/${TKLIB} \
         --identifier core.tcl-lang.org-tklib${TKLIB_VER} \
         --version ${TKLIB_VER} \
         --install-location ${INSTALL_DIR} \
         temp/tklib.pkg ;
productsign --sign $DEV_ID temp/tklib.pkg tklib.pkg
