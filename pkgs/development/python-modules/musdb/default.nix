{ lib, buildPythonPackage, fetchPypi
, soundfile, stempeg, pyaml, tqdm
, pytest, ffmpeg
}:

buildPythonPackage rec {
  pname = "musdb";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 ="1xyb1zm584vi8af7b7wmbrj7alkldwgay9mmrzhcf6grjl8cgai7";
  };

  nativeBuildInputs = [
    soundfile
    stempeg
    tqdm
    pyaml
  ];

  # We're not intereseted in code quality tests
  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-cov" "" \
      --replace "coverage>=4.4" "" \
      --replace "pytest-pep8" ""
    substituteInPlace setup.cfg \
      --replace "--cov-report term-missing" "" \
      --replace "--cov musdb" "" \
      --replace "--pep8" ""
  '';

  checkInputs = [
    pytest
    ffmpeg
  ];

  # silly failure about missing version number
  doCheck = false;

  meta = with lib; {
    homepage = "https://sigsep.github.io/sigsep-mus-db";
    description = "Python parser and tools for MUSDB18 Music Separation Dataset";
    license = licenses.mit;
    maintainers = with maintainers; [ chessai ];
  };
}
