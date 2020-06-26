{ ffmpeg, libsndfile, buildPythonPackage, lib
, fetchFromGitHub, installShellFiles, makeWrapper
, musdb, museval, ffmpeg-python, norbert, pandas
, requests, librosa, numba
}:

buildPythonPackage rec {
  pname = "spleeter";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "deezer";
    repo = pname;
    rev = "v${version}";
    sha256 = "016jyfxsmx8c5dg7kw0njw4v887v4n0yhmd5380czmnb0g0kwics";
  };

  nativeBuildInputs = [
    makeWrapper
    ffmpeg-python
    librosa
    musdb
    museval
    norbert
    numba
    pandas
    requests
  ];

  makeWrapperArgs = [
    ''--prefix PATH : "${lib.makeBinPath [ffmpeg]}"''
  ];

  patches = [ ./allow-newer-python.patch ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/deezer/spleeter";
    description = "Deezer source separation library including pretrained models";
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ chessai ];
  };
}
