{
  lib,
  buildPythonPackage,
  pkgs,
}:

buildPythonPackage rec {
  pname = "ufl";
  version = "2025-05-09";
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "ufl";
    rev = "eee35146ad0c9b4a89d1331882b9494372406501";
    sha256 = "sha256-WYRJ+sDLRuprVWxbqRhNdijND7YpZE1kGFpsjX7SJMw=";
  };

  build-system = [
    pkgs.python3Packages.setuptools
  ];

  dependencies = [
    pkgs.python3Packages.numpy
  ];

  doCheck = false;

  meta = with lib; {
    description = "Unified Form Language";
    homepage = "https://github.com/firedrakeproject/ufl";
    license = licenses.lgpl3Plus;
  };
}
