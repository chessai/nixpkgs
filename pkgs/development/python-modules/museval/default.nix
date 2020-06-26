{ lib, buildPythonPackage, fetchPypi
, musdb, pandas, numpy, scipy
, simplejson, soundfile, jsonschema
, tqdm, stempeg, pyaml
}:

buildPythonPackage rec {
  pname = "museval";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pqxsd40lvxc2v313i6gf8qdr1syspv1a9chq5iabpk76gfk84rf";
  };

  nativeBuildInputs = [
    musdb
    pandas
    numpy
    scipy
    simplejson
    soundfile
    jsonschema
    tqdm
    stempeg
    pyaml
  ];

  # requires network connectivity
  doCheck = false;

  meta = with lib; {
    homepage = "https://sigsep.github.io/sigsep-mus-eval";
    description = "source separation evaluation tools for python";
    license = licenses.mit;
    maintainers = with maintainers; [ chessai ];
  };
}
