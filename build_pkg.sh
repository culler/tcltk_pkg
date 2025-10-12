#!/bin/bash
PROFILE="culler"
source ./IDs.sh
mkdir -p temp

# Assemble all of the packages as components of a product.
productbuild --distribution distribution.plist \
	     --resources resources \
	     temp/tcltk.pkg
productsign --sign $DEV_ID temp/tcltk.pkg tcltk${VERSION}.pkg

# Notarize the product
xcrun notarytool submit tcltk${VERSION}.pkg --keychain-profile ${PROFILE} --wait
xcrun stapler staple tcltk${VERSION}.pkg 
