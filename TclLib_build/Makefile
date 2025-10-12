SHELL := /bin/bash
TCL_FRAMEWORK := ../TclTk_build/build/tcl/Tcl.framework
TCL_VERSION := $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
BRANCH := main
TCLCONFIG_URL := https://core.tcl-lang.org/tclconfig/tarball/${BRANCH}
TCLLIB_URL := https://core.tcl-lang.org/tcllib/tarball/${BRANCH}
.phony: clean

tcllib.pkg: dist/lib
	bash make_pkg.sh

dist/lib: tcllib tcllib/tclconfig
	mkdir -p dist
	cd tcllib; ./configure --prefix=`realpath ../dist`
	make -C tcllib

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
