{
  lib,
  buildPythonPackage,
  libsupermesh,
  ufl,
  fiat,
  petsc,
  petsc4py,
  pkgs,
}:
buildPythonPackage rec {
  pname = "firedrake";
  version = "2025.4.1";
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "firedrake";
    rev = version;
    sha256 = "sha256-p/yquIKWynGY7UESDNBCf1cM8zpy8beuuRxSrSMvj7c=";
  };

  build-system = [
    pkgs.python3Packages.cython
    pkgs.python3Packages.setuptools
    pkgs.python3Packages.pkgconfig
    pkgs.python3Packages.pybind11
  ];

  dependencies = [
    pkgs.python3Packages.mpi4py
    petsc4py
    pkgs.python3Packages.numpy
    pkgs.python3Packages.rtree
    libsupermesh
    fiat
    ufl
    pkgs.python3Packages.loopy
    pkgs.python3Packages.decorator
    pkgs.python3Packages.cachetools
    pkgs.python3Packages.packaging
    pkgs.python3Packages.h5py-mpi
    pkgs.python3Packages.progress
    pkgs.python3Packages.requests
    pkgs.python3Packages.pycparser
    pkgs.python3Packages.pyadjoint-ad
  ];

  pythonRelaxDeps = [
    "decorator"
    "petsc4py"
  ];

  preBuild = ''
    export PETSC_DIR=${petsc}
  '';

  shellHook = ''
    export OMP_NUM_THREADS=1
  '';

  doCheck = false;

  meta = with lib; {
    description = "An automated system for PDEs using FEM";
    homepage = "https://firedrakeproject.org";
    license = licenses.gpl3;
  };
}
