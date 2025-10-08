#!/bin/bash
PROFILE="culler"
VERSION="9.1.0"
VRSN=`echo ${VERSION} | cut -d . -f 1,2`

####################

source ./IDs.sh
mkdir -p temp

PKG_ROOT="pkg_root"

# Tcl package parameters
TCL_PKG_ID="org.tcl-lang.core-Tcl${VERSION}"
TCL_FRAMEWORK="${PKG_ROOT}/Tcl.framework"
TCL_TARGET="/Library/Frameworks/Tcl.framework"

# Tk package parameters
TK_PKG_ID="org.tcl-lang.core-Tk${VERSION}"
TK_FRAMEWORK="${PKG_ROOT}/Tk.framework"
TK_TARGET="/Library/Frameworks/Tk.framework"

# Tcllib package parameters
TCLLIB_PKG_ID="org.tcl-lang.core-Tcllib${VERSION}"
TCLLIB_LIB_DIR="${PKG_ROOT}/tcllib2.0"
TCLLIB_TARGET="/Library/Frameworks/Tcl.framework/Versions/9.1/Resources/Scripts/tcllib2.0"

# Build and sign a package for the Tcl framework.
pkgbuild --root ${TCL_FRAMEWORK} \
	 --identifier $TCL_PKG_ID \
	 --version ${VERSION} \
	 --install-location $TCL_TARGET \
	 --scripts TclScripts \
	 temp/tcl.pkg
productsign --sign $DEV_ID temp/tcl.pkg tcl.pkg

# Build and sign a package for the Tk framework.
pkgbuild --root $TK_FRAMEWORK \
	 --identifier $TK_PKG_ID \
	 --version ${VERSION} \
	 --install-location $TK_TARGET \
	 --scripts TkScripts \
	 temp/tk.pkg
productsign --sign $DEV_ID temp/tk.pkg tk.pkg

# Build and sign a package for Tcllib.
pkgbuild --root $TCLLIB_LIB_DIR \
	 --identifier $TCLLIB_PKG_ID \
	 --version ${VERSION} \
	 --install-location $TCLLIB_TARGET \
	 temp/tcllib.pkg
productsign --sign $DEV_ID temp/tcllib.pkg tcllib.pkg

# Assemble all of these packages as components of a product.
productbuild --distribution distribution.plist \
	     --resources resources \
	     temp/tcltk.pkg
productsign --sign $DEV_ID temp/tcltk.pkg tcltk${VERSION}.pkg

# Notarize the product
xcrun notarytool submit tcltk${VERSION}.pkg --keychain-profile ${PROFILE} --wait
xcrun stapler staple tcltk${VERSION}.pkg 
