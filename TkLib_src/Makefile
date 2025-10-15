SHELL := /bin/bash
TCL_FRAMEWORK := ../TclTk_build/build/tcl/Tcl.framework
TCL_VERSION := $(shell readlink ${TCL_FRAMEWORK}/Versions/Current)
BRANCH := trunk
TCLCONFIG_URL := https://core.tcl-lang.org/tclconfig/tarball/${BRANCH}/tclconfig.tar.gz
TKLIB_URL := https://core.tcl-lang.org/tklib/tarball/${BRANCH}

.phony: clean

tklib.pkg: dist/lib/tklib0.9
	bash make_pkg.sh

dist/lib/tklib0.9: tklib
	mkdir -p dist
	cd tklib; ./configure --prefix=`realpath ..`/dist
	make -C tklib install

tklib.tar.gz:
	curl -L -O ${TKLIB_URL}/tklib.tar.gz

tklib: tklib.tar.gz
	tar xfz tklib.tar.gz

clean:
	rm -rf *.tar.gz tklib.pkg tklib dist
