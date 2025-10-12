TCL_FRAMEWORK := TclTk_build/build/tcl/Tcl.framework
COMPONENTS := tcl.pkg tk.pkg tcllib.pkg

.phony: package clean all_clean

package: tcltk.pkg
	VERSION=`readlink ${TCL_FRAMEWORK}/Versions/Current`; \
	rm -f tcltk$${VERSION}.pkg; \
	mv tcltk.pkg tcltk$${VERSION}.pkg

tcltk.pkg: tcl.pkg tk.pkg tcllib.pkg
	bash build_package.sh

tcl.pkg tk.pkg:
	make -C TclTk_build
	cp TclTk_build/{tcl,tk}.pkg .

tcllib.pkg:
	make -C TclLib_build
	cp TclLib_build/tcllib.pkg .

clean:
	rm -rf ${COMPONENTS} temp

all_clean:
	make clean
	rm -rf *.pkg
	make -C TclTk_build clean
	make -C TclLib_build clean
