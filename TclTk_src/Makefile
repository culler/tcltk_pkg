TCL_BRANCH := main
# Temporary - to fix demos
TK_BRANCH := main
TCL_URL := https://core.tcl-lang.org/tcl/tarball/${TCL_BRANCH}/tcl.tar.gz
TK_URL := https://core.tcl-lang.org/tk/tarball/${TK_BRANCH}/tk.tar.gz
CFLAGS := -arch x86_64 -arch arm64 -mmacosx-version-min=10.13
TCL_FRAMEWORK := build/tcl/Tcl.framework
TCL_VERSION_DIR := ${TCL_FRAMEWORK}/Versions/Current
TK_FRAMEWORK := build/tk/Tk.framework
TK_VERSION_DIR := ${TK_FRAMEWORK}/Versions/Current

.phony: clean

packages: build/tk/Tk.framework
	bash build_tcltk_packages.sh

build/tk/Tk.framework: tcl tk
	export CFLAGS="${CFLAGS}"; make -C tcl/macosx deploy
	export CFLAGS="${CFLAGS}"; make -C tk/macosx deploy
	cp build/tcl/tclsh* ${TCL_VERSION_DIR}
	cd ${TCL_VERSION_DIR}; \
	mkdir -p Resources; \
	for rsrc in `ls *.sh *.a`; do \
	    mv $$rsrc Resources; \
	    ln -s Resources/$${rsrc} $${rsrc}; \
	    done
	cp build/tk/wish* ${TK_VERSION_DIR}
	cd ${TK_VERSION_DIR}; \
	mkdir -p Resources; \
	for rsrc in `ls *.sh *.a`; do \
	    mv $$rsrc Resources; \
	    ln -s Resources/$${rsrc} $${rsrc}; \
	    done

tcl.tar.gz:
	curl -L -O ${TCL_URL}

tk.tar.gz:
	curl -L -O ${TK_URL}

tcl: tcl.tar.gz
	tar xfz tcl.tar.gz

tk: tk.tar.gz
	tar xfz tk.tar.gz

clean:
	rm -rf tcl.tar.gz tk.tar.gz tcl tk *.pkg build temp usr_local_bin
