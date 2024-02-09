{ lib
, buildPythonPackage
, fetchPypi
, grpcio
, protobuf
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "grpcio-testing";
  version = "1.60.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vvrZX0fes/OTTr1VEpl0jqo/Y+44btlq1pemZFNWixc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"grpcio>={version}".format(version=grpc_version.VERSION)' '"grpcio"'
  '';

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [
    "grpc_testing"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Testing utilities for gRPC Python";
    homepage = "https://grpc.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
