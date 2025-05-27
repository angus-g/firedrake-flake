{
  description = "Firedrake flake with all related packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          scotch = pkgs.scotch.overrideAttrs (old: {
            version = "7.0.4";
            src = pkgs.fetchFromGitLab {
              domain = "gitlab.inria.fr";
              owner = "scotch";
              repo = "scotch";
              rev = "v7.0.4";
              hash = "sha256-uaox4Q9pTF1r2BZjvnU2LE6XkZw3x9mGSKLdRVUobGU=";
            };
          });
          petsc =
            (pkgs.petsc.override {
              fortranSupport = false;
              scotch = scotch;
            }).overrideAttrs
              (old: {
                version = "3.23.0";
                src = pkgs.fetchzip {
                  url = "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.23.0.tar.gz";
                  hash = "sha256-OcI4iyDOR0YTVV+JoOhbfutoW00EmfapNaMnD/JJFsI=";
                };
              });
          petsc4py = pkgs.python3.pkgs.toPythonModule (
            petsc.override {
              pythonSupport = true;
            }
          );
          ufl = pkgs.python3.pkgs.callPackage ./pkgs/ufl.nix { };
          fiat = pkgs.python3.pkgs.callPackage ./pkgs/fiat.nix {
            inherit ufl;
          };
          firedrake = pkgs.python3.pkgs.callPackage ./pkgs/firedrake.nix {
            inherit petsc petsc4py fiat ufl;
          };
        in
        {
          inherit firedrake;
        }
      );
      devShell = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        pkgs.mkShell {
          packages = [
            self.packages.${system}.firedrake
            pkgs.python3Packages.pytest
          ];
        }
      );
    };
}
