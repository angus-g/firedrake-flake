{
  lib,
  buildPythonPackage,
  ufl,
  pkgs,
}:

buildPythonPackage rec {
  pname = "fiat";
  version = "2025-05-09";
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "fiat";
    rev = "9bcf0d71e035c085f412e1841c65a50e018f3aa6";
    sha256 = "sha256-e1OklZuDkXanLx1M17w86JtaUZuPfOCboOAkMdQfYCA=";
  };

  build-system = [
    pkgs.python3Packages.setuptools
  ];

  dependencies = [
    pkgs.python3Packages.numpy
    pkgs.python3Packages.scipy
    pkgs.python3Packages.sympy
    pkgs.python3Packages.symengine
    pkgs.python3Packages.recursivenodes
    ufl
  ];

  doCheck = false;

  meta = with lib; {
    description = "FInite element Automatic Tabulator";
    homepage = "https://fenics-fiat.readthedocs.org";
    license = licenses.lgpl3Plus;
  };
}
