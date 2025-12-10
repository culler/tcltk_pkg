#!/bin/bash
source ./IDs.sh
mkdir -p temp

# Assemble all of the packages as components of a product.
productbuild --distribution distribution.plist \
	     --resources resources \
	     temp/tcltk.pkg
productsign --sign $DEV_ID temp/tcltk.pkg tcltk.pkg

# Notarize the product
echo "Notarizing package file ..."
xcrun notarytool submit tcltk.pkg \
      --apple-id $APPLE_ID \
      --team-id $DEV_ID \
      --password $ONE_TIME_PASS \
      --wait \
      --no-progress
xcrun stapler staple tcltk.pkg 
