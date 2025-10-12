#!/bin/bash
PROFILE="culler"
source ./IDs.sh
VERSION=`readlink TclTk_build/build/tk/Tcl.framework/Versions/Current`
mkdir -p temp
cp TclTk_build/*.pkg .
cp TclLib_build/*.pkg .

# Assemble all of the packages as components of a product.
productbuild --distribution distribution.plist \
	     --resources resources \
	     temp/tcltk${VERSION}.pkg
productsign --sign $DEV_ID temp/tcltk${VERSION}.pkg tcltk${VERSION}.pkg

# Notarize the product
xcrun notarytool submit tcltk${VERSION}.pkg --keychain-profile ${PROFILE} --wait
xcrun stapler staple tcltk${VERSION}.pkg 
