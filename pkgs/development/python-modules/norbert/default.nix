{ lib, buildPythonPackage, fetchPypi
, scipy, pytest
}:

buildPythonPackage rec {
  pname = "norbert";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kp7ilvafw8bsciwiqz4f5zsnb1m9fkc2ra2py0hnmgh4wjvqk5x";
  };

  nativeBuildInputs = [
    scipy
  ];

  meta = with lib; {
    homepage = "https://sigsep.github.io/norbert";
    description = "Painless Wiener filters for audio separation";
    license = licenses.mit;
    maintainers = with maintainers; [ chessai ];
  };
}
