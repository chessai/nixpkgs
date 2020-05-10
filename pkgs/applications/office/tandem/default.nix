{ appimageTools, fetchurl, lib }:

let
  pname = "tandem";
  version = "1.4.2";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://tandem.chat/downloadv3/linux";
    sha256 = "1vicc1g8mhp14zjci1j6n8yr48fjvrqrlqkzp1iaz94ck1jvnw2y";
  };

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [ p.at-spi2-atk p.at-spi2-core ];
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "A virtual office for remote teams";
    homepage = "https://tandem.chat";
    license = licenses.issl;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ chessai ];
  };
}
