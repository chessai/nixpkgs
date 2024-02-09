{ lib
, stdenv
, fetchurl
, installShellFiles
, pkg-config

# Optional dependencies
, enableApp ? with stdenv.hostPlatform; !isWindows && !isStatic
, c-aresMinimal, libev, openssl, zlib
, enableGetAssets ? false, libxml2
, enableHpack ? false, jansson
, enableHttp3 ? false, ngtcp2, nghttp3, quictls
, enableJemalloc ? false, jemalloc
, enablePython ? false, python3, ncurses

# Unit tests ; we have to set TZDIR, which is a GNUism.
, enableTests ? stdenv.hostPlatform.isGnu, cunit, tzdata

# downstream dependencies, for testing
, curl
, libsoup
}:

# Note: this package is used for bootstrapping fetchurl, and thus cannot use fetchpatch!
# All mutable patches (generated by GitHub or cgit) that are needed here
# should be included directly in Nixpkgs as files.

assert enableGetAssets -> enableApp;
assert enableHpack -> enableApp;
assert enableHttp3 -> enableApp;
assert enableJemalloc -> enableApp;

stdenv.mkDerivation rec {
  pname = "nghttp2";
  version = "1.59.0";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-A1P8u6ENKl9304ouSS5eZ3tjexdxI0WkcyXDw1+0d/g=";
  };

  outputs = [ "out" "dev" "lib" "doc" "man" ];

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (enableApp) [ installShellFiles ];

  buildInputs = lib.optionals enableApp [ c-aresMinimal libev zlib ]
    ++ lib.optionals (enableApp && !enableHttp3) [ openssl ]
    ++ lib.optionals (enableGetAssets) [ libxml2 ]
    ++ lib.optionals (enableHpack) [ jansson ]
    ++ lib.optionals (enableJemalloc) [ jemalloc ]
    ++ lib.optionals (enableHttp3) [ ngtcp2 nghttp3 quictls ]
    ++ lib.optionals (enablePython) [ python3 ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-examples"
    (lib.enableFeature enableApp "app")
    (lib.enableFeature enableHttp3 "http3")
  ];

  # Unit tests require CUnit and setting TZDIR environment variable
  doCheck = enableTests;
  nativeCheckInputs = lib.optionals (enableTests) [ cunit tzdata ];
  preCheck = lib.optionalString (enableTests) ''
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  postInstall = lib.optionalString (enableApp) ''
    installShellCompletion --bash doc/bash_completion/{h2load,nghttp,nghttpd,nghttpx}
  '' + lib.optionalString (!enableApp) ''
    rm -r $out/bin
  '' + lib.optionalString (enablePython) ''
    patchShebangs $out/share/nghttp2
  '' + lib.optionalString (!enablePython) ''
    rm -r $out/share
  '';

  passthru.tests = {
    inherit curl libsoup;
  };

  meta = with lib; {
    description = "HTTP/2 C library and tools";
    longDescription = ''
      nghttp2 is an implementation of the HyperText Transfer Protocol version 2 in C.
      The framing layer of HTTP/2 is implemented as a reusable C library. On top of that,
      we have implemented an HTTP/2 client, server and proxy. We have also developed
      load test and benchmarking tools for HTTP/2.
      An HPACK encoder and decoder are available as a public API.
      We have Python bindings of this library, but we do not have full code coverage yet.
      An experimental high level C++ library is also available.
    '';

    homepage = "https://nghttp2.org/";
    changelog = "https://github.com/nghttp2/nghttp2/releases/tag/v${version}";
    # News articles with changes summary can be found here: https://nghttp2.org/blog/archives/
    license = licenses.mit;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.all;
  };
}
