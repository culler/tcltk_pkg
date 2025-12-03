#!/bin/bash
set -e
OPENSSL_VERSION="3.6.0"
URL="https://github.com/openssl/openssl/releases/download/openssl-${OPENSSL_VERSION}/openssl-${OPENSSL_VERSION}.tar.gz"
if ! [ -e openssl-${OPENSSL_VERSION} ]; then
    curl -L -O ${URL}
    tar xfz openssl-${OPENSSL_VERSION}.tar.gz
fi
rm -rf arm64 x86_64
mkdir arm64 x86_64
cd openssl-${OPENSSL_VERSION}
if [ -e Makefile ]; then
    make distclean
fi
./Configure --prefix=`realpath ../arm64` darwin64-arm64 \
	    -mmacosx-version-min=11.0
make install_sw
sed -i '' 's|Libs: .*|Libs: ${prefix}/lib/libcrypto.a|' \
    ../arm64/lib/pkgconfig/libcrypto.pc
sed -i '' 's|Libs: .*|Libs: ${prefix}/lib/libssl.a|' \
    ../arm64/lib/pkgconfig/libssl.pc

if [ -e Makefile ]; then
    make distclean
fi
./Configure --prefix=`realpath ../x86_64` darwin64-x86_64 \
	    -mmacosx-version-min=10.13
make install_sw
sed -i '' 's|Libs: .*|Libs: ${prefix}/lib/libcrypto.a|' \
    ../x86_64/lib/pkgconfig/libcrypto.pc
sed -i '' 's|Libs: .*|Libs: ${prefix}/lib/libssl.a|' \
    ../x86_64/lib/pkgconfig/libssl.pc
