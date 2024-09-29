{
  lib,
  aiobotocore,
  aiohttp,
  buildPythonPackage,
  docutils,
  fetchPypi,
  fsspec,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "s3fs";
  version = "2024.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZJNwWrtQN01reZT5YW0nrb3YohnIY1EAvcKGOC79kfU=";
  };

  postPatch = ''
    sed -i 's/fsspec==.*/fsspec/' requirements.txt
  '';

  buildInputs = [ docutils ];

  propagatedBuildInputs = [
    aiobotocore
    aiohttp
    fsspec
  ];

  # Depends on `moto` which has a long dependency chain with exact
  # version requirements that can't be made to work with current
  # pythonPackages.
  doCheck = false;

  pythonImportsCheck = [ "s3fs" ];

  meta = with lib; {
    description = "Pythonic file interface for S3";
    homepage = "https://github.com/fsspec/s3fs";
    changelog = "https://github.com/fsspec/s3fs/raw/${version}/docs/source/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
