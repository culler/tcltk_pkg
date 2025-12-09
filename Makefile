TCL_FRAMEWORK := TclTk_src/build/tcl/Tcl.framework
COMPONENTS := tcl.pkg tk.pkg tcllib.pkg tklib.pkg thread.pkg sqlite.pkg \
tcltls.pkg tkimg.pkg tdbc.pkg


.phony: package clean all_clean

package: tcltk.pkg
	VERSION=`readlink ${TCL_FRAMEWORK}/Versions/Current`; \
	rm -f tcltk$${VERSION}.pkg; \
	mv tcltk.pkg tcltk$${VERSION}.pkg

tcltk.pkg: ${COMPONENTS}
	bash build_package.sh

tcl.pkg tk.pkg bin.pkg:
	make -C TclTk_src
	cp TclTk_src/{tcl,tk,bin}.pkg .
#	The Tcl install always fails on a clean system because it finds Tcl 8.5
	sudo make -C Tcltk_src/tcl/macosx install || true
	sudo make -C Tcltk_src/tk/macosx install || true

tcllib.pkg:
	make -C TclLib_src
	cp TclLib_src/tcllib.pkg .

tklib.pkg:
	make -C TkLib_src
	cp TkLib_src/tklib.pkg .

thread.pkg:
	make -C TclThread_src
	cp TclThread_src/thread.pkg .

sqlite.pkg:
	make -C Sqlite_src
	cp Sqlite_src/sqlite.pkg .

tkimg.pkg:
	make -C TkImg_src
	cp TkImg_src/tkimg.pkg .

tcltls.pkg: openssl/arm64 openssl/x86_64
	make -C TclTLS_src
	cp TclTLS_src/tcltls.pkg .

tdbc.pkg:
	make -C TDBC_src
	cp TDBC_src/tdbc.pkg .

openssl/arm64 openssl/x86_64:
	cd openssl; \
	bash build_openssl.sh

clean:
	rm -rf ${COMPONENTS} temp

all_clean:
	make clean
	rm -rf *.pkg
	rm -rf openssl/{arm64,x86_64}
	make -C TclTk_src clean
	make -C TclLib_src clean
	make -C TkLib_src clean
	make -C Sqlite_src clean
	make -C TclTLS_src clean
