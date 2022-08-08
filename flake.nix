{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages = {
          cloud-localds = nixpkgs.callPackage ./cloud-localds.nix { };
          sqldef = nixpkgs.callPackage ./sqldef.nix { };
          # watchman = nixpkgs.callPackage ./watchman.nix { };
        };
      }
    );
}
