SHELL := /bin/bash
TCL_FRAMEWORK := ../TclTk_build/build/tcl/Tcl.framework
TCL_VERSION := $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
BRANCH := trunk
TCLCONFIG_URL := https://core.tcl-lang.org/tclconfig/tarball/${BRANCH}/tclconfig.tar.gz
TKLIB_URL := https://core.tcl-lang.org/tklib/tarball/${BRANCH}
DEV_ID := $(shell source ../IDs.sh; echo $$DEV_ID)
INSTALL_DIR := ${FRAMEWORK}/Versions/${TCL_VERSION}/Resources/Scripts

.phony: clean

tklib.pkg: dist/lib/tklib0.9
	mkdir -p temp
	export TKLIB=`ls dist/lib | grep 'tklib\([0-9]*\.[0=9]*\)'`; \
	export TKLIB_VER=`echo $${TKLIB} | sed 's/tklib//'`; \
	pkgbuild --root dist/lib/$${TKLIB} \
	  --identifier core.tcl-lang.org-tcllib$${TKLIB_VER} \
	  --version $${TKLIB_VER} \
	  --install-location ${INSTALL_DIR} \
	  temp/tklib.pkg ;
	productsign --sign ${DEV_ID} temp/tklib.pkg tklib.pkg

dist/lib/tklib0.9: tklib
	mkdir -p dist
	cd tklib; ./configure --prefix=`realpath ..`/dist
	make -C tklib install

tklib: tklib.tar.gz
	tar xfz tklib.tar.gz

tklib.tar.gz:
	curl -L -O ${TKLIB_URL}/tklib.tar.gz

clean:
	rm -rf *.tar.gz tklib.pkg tklib dist
