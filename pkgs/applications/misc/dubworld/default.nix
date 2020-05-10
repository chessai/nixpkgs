{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dubworld";
  version = "69";

  src = fetchurl {
    url = "http://dubinets.io/static/HelloWorld";
    sha256 = "1qvqlr71588jc2k22g3wsfai06rl5422myp93w30c9n1zic5y8p7";
  };
  sourceRoot = ".";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/HelloWorld
    chmod +x $out/bin/HelloWorld
  '';
  preFixup = let
    libPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib  # libstdc++.so.6
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/HelloWorld
  '';

  meta = with stdenv.lib; {
    homepage = " http://dubinets.io";
    description = "Hello World";
    platforms = platforms.linux;
    license = licenses.free;
    maintainers = with maintainers; [ chessai ];
  };
}
