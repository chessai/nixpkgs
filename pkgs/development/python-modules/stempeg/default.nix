{ lib, ffmpeg, buildPythonPackage, fetchPypi
, numpy, soundfile
}:

buildPythonPackage rec {
  pname = "stempeg";
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dl12k07g24nyi9yxrgh6bd6m3m5ifj656r76slz6ksf5p9nl9pj";
  };

  nativeBuildInputs = [
    numpy
    soundfile
  ];

  checkInputs = [ ffmpeg ];

  meta = with lib; {
    homepage = "https://github.com/faroit/stempeg";
    description = "Python I/O for STEM audio files";
    license = licenses.mit;
    maintainers = with maintainers; [ chessai ];
  };
}
