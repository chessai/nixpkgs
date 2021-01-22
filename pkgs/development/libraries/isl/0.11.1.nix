{ lib, stdenv, fetchurl, gmp }:

stdenv.mkDerivation {
  name = "isl-0.11.1"; # CLooG 0.16.3 fails to build with ISL 0.08.

  src = fetchurl {
    url = "https://src.fedoraproject.org/repo/pkgs/gcc/isl-0.11.1.tar.bz2/bce1586384d8635a76d2f017fb067cd2/isl-0.11.1.tar.bz2";
    sha256 = "13d9cqa5rzhbjq0xf0b2dyxag7pqa72xj9dhsa03m8ccr1a4npq9";
  };

  buildInputs = [ gmp ];
  patches = [ ./fix-gcc-build.diff ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.kotnet.org/~skimo/isl/";
    license = lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = lib.platforms.all;
  };
}
