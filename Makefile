TCL_FRAMEWORK := TclTk_src/build/tcl/Tcl.framework
COMPONENTS := tcl.pkg tk.pkg tcllib.pkg tklib.pkg sqlite.pkg tcltls.pkg

.phony: package clean all_clean

package: tcltk.pkg
	VERSION=`readlink ${TCL_FRAMEWORK}/Versions/Current`; \
	rm -f tcltk$${VERSION}.pkg; \
	mv tcltk.pkg tcltk$${VERSION}.pkg

tcltk.pkg: ${COMPONENTS}
	bash build_package.sh

tcl.pkg tk.pkg:
	make -C TclTk_src
	cp TclTk_src/{tcl,tk}.pkg .

tcllib.pkg:
	make -C TclLib_src
	cp TclLib_src/tcllib.pkg .

tklib.pkg:
	make -C TkLib_src
	cp TkLib_src/tklib.pkg .

sqlite.pkg:
	make -C Sqlite_src
	cp Sqlite_src/sqlite.pkg .

tcltls.pkg:
	make -C TclTLS_src
	cp TclTLS_src/tcltls.pkg .

clean:
	rm -rf ${COMPONENTS} temp

all_clean:
	make clean
	rm -rf *.pkg
	make -C TclTk_src clean
	make -C TclLib_src clean
	make -C TkLib_src clean
	make -C Sqlite_src clean
	make -C TclTLS_src clean
