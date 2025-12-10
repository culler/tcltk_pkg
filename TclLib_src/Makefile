SHELL := /bin/bash
TCL_FRAMEWORK := ../TclTk_src/build/tcl/Tcl.framework
TCL_VERSION := $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
BRANCH := main
TCLCONFIG_URL := https://core.tcl-lang.org/tclconfig/tarball/${BRANCH}
TCLLIB_URL := https://core.tcl-lang.org/tcllib/tarball/${BRANCH}
DEV_ID := $(shell source ../IDs.sh; echo $$DEV_ID)
INSTALL_DIR := ${FRAMEWORK}/Versions/${TCL_VERSION}/Resources/Scripts
TCLLIB_CFLAGS := -arch arm64 -arch x86_64 -mmacosx-version-min=10.13

.phony: clean

tcllib.pkg: dist/lib
	mkdir -p temp
	export TCLLIB=`ls dist/lib | grep 'tcllib\([0-9]*\.[0=9]*\)'`; \
	export TCLLIB_VER=`echo $${TCLLIB} | sed 's/tcllib//'`; \
	pkgbuild --root dist/lib/$${TCLLIB} \
	  --identifier core.tcl-lang.org-tcllib$${TCLLIB_VER} \
	  --version $${TCLLIB_VER} \
	  --install-location ${INSTALL_DIR} \
	  temp/tcllib.pkg ;
	productsign --sign ${DEV_ID} temp/tcllib.pkg tcllib.pkg

dist/lib: tcllib tcllib/tclconfig
	mkdir -p dist
	cd tcllib; ./configure --with-tcl=${TCL_FRAMEWORK} --prefix=`realpath ../dist`
	make -C tcllib CFLAGS="${TCLLIB_CFLAGS}" install

tclconfig.tar.gz:
	curl -L -O ${TCLCONFIG_URL}/tclconfig.tar.gz

tcllib.tar.gz:
	curl -L -O ${TCLLIB_URL}/tcllib.tar.gz

tcllib: tcllib.tar.gz
	tar xfz tcllib.tar.gz

tcllib/tclconfig: tclconfig.tar.gz 
	cd tcllib; tar xfz ../tclconfig.tar.gz

clean:
	rm -rf *.tar.gz tcllib.pkg tcllib tclconfig dist temp
