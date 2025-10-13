TCL_FRAMEWORK := TclTk_src/build/tcl/Tcl.framework
COMPONENTS := tcl.pkg tk.pkg tcllib.pkg

.phony: package clean all_clean

package: tcltk.pkg
	VERSION=`readlink ${TCL_FRAMEWORK}/Versions/Current`; \
	rm -f tcltk$${VERSION}.pkg; \
	mv tcltk.pkg tcltk$${VERSION}.pkg

tcltk.pkg: tcl.pkg tk.pkg tcllib.pkg
	bash build_package.sh

tcl.pkg tk.pkg:
	make -C TclTk_src
	cp TclTk_src/{tcl,tk}.pkg .

tcllib.pkg:
	make -C TclLib_src
	cp TclLib_src/tcllib.pkg .

clean:
	rm -rf ${COMPONENTS} temp

all_clean:
	make clean
	rm -rf *.pkg
	make -C TclTk_src clean
	make -C TclLib_src clean
