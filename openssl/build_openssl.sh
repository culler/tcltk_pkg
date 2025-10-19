#!/bin/bash
rm -rf arm64 x86_64
mkdir arm64 x86_64
cd openssl-3.6.0
if [ -e Makefile ]; then
    make distclean
fi
./Configure --prefix=`realpath ../arm64` darwin64-arm64 \
	    -mmacosx-version-min=11.0
make install
sed -i '' 's|Libs: .*|Libs: ${prefix}/lib/libcrypto.a|' \
    ../arm64/lib/pkgconfig/libcrypto.pc
sed -i '' 's|Libs: .*|Libs: ${prefix}/lib/libssl.a|' \
    ../arm64/lib/pkgconfig/libssl.pc

if [ -e Makefile ]; then
    make distclean
fi
./Configure --prefix=`realpath ../x86_64` darwin64-x86_64 \
	    -mmacosx-version-min=10.13
make install
sed -i '' 's|Libs: .*|Libs: ${prefix}/lib/libcrypto.a|' \
    ../x86_64/lib/pkgconfig/libcrypto.pc
sed -i '' 's|Libs: .*|Libs: ${prefix}/lib/libssl.a|' \
    ../x86_64/lib/pkgconfig/libssl.pc
