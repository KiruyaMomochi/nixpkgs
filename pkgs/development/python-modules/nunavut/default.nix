{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-resources
, pydsdl
, pyyaml
}:

 buildPythonPackage rec {
  pname = "nunavut";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L4FbPhhhmgjkL1c3qnSJDK+4NBO2DUqeW6WGt9MBTbg=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pydsdl ~= 1.16" "pydsdl"
  '';

  propagatedBuildInputs = [
    importlib-resources
    pydsdl
    pyyaml
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
  '';

  # No tests in pypy package and no git tags yet for release versions, see
  # https://github.com/UAVCAN/nunavut/issues/182
  doCheck = false;

  pythonImportsCheck = [
    "nunavut"
  ];

  meta = with lib; {
    description = "A UAVCAN DSDL template engine";
    longDescription = ''
      It exposes a pydsdl abstract syntax tree to Jinja2 templates allowing
      authors to generate code, schemas, metadata, documentation, etc.
    '';
    homepage = "https://nunavut.readthedocs.io/";
    changelog = "https://github.com/OpenCyphal/nunavut/releases/tag/${version}";
    maintainers = with maintainers; [ wucke13 ];
    license = with licenses; [ bsd3 mit ];
  };
}
