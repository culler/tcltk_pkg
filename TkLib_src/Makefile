SHELL := /bin/bash
TK_FRAMEWORK := ..//TclTk_src/build/tk/Tk.framework
TK_VERSION := $(shell readlink ${TK_FRAMEWORK}/Versions/Current)
BRANCH := trunk
TCLCONFIG_URL := https://core.tcl-lang.org/tclconfig/tarball/${BRANCH}/tclconfig.tar.gz
TKLIB_URL := https://core.tcl-lang.org/tklib/tarball/${BRANCH}
DEV_ID := $(shell source ../IDs.sh; echo $$DEV_ID)
INSTALL_DIR := /Library/Frameworks/Tk.framework/Versions/${TK_VERSION}/Resources/Scripts/tklib
TKLIB_VER := `ls  | sed 's/tklib//'`; \

TKLIB_VERSION := 0.9

.phony: clean

tklib.pkg: dist/lib/tklib

	mkdir -p temp
	export TKLIB_VERSION=`grep "Version:" tklib/DESCRIPTION.txt | cut -d' ' -f2`; \
	pkgbuild --root dist/lib/tklib \
	  --identifier core.tcl-lang.org-tklib$${TKLIB_VERSION} \
	  --version $${TKLIB_VERSION} \
	  --install-location ${INSTALL_DIR} \
	  temp/tklib.pkg ;
	productsign --sign ${DEV_ID} temp/tklib.pkg tklib.pkg

dist/lib/tklib: tklib
	mkdir -p dist
	cd tklib; ./configure --prefix=`realpath ..`/dist
	make -C tklib install
	mv dist/lib/tklib* dist/lib/tklib

tklib: tklib.tar.gz
	tar xfz tklib.tar.gz

tklib.tar.gz:
	curl -L -O ${TKLIB_URL}/tklib.tar.gz

clean:
	rm -rf *.tar.gz tklib.pkg tklib dist
