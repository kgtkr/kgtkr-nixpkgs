{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      packageNames = [
        "cloud-localds"
        "sqldef"
        # "watchman"
      ];
    in
    {
      overlay = (final: prev: prev.lib.listToAttrs (prev.lib.lists.map
        (name: {
          inherit name;
          value = prev.callPackage ./${name}.nix { };
        })
        packageNames));
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlay
          ];
        };
      in
      {
        packages = pkgs.lib.listToAttrs (pkgs.lib.lists.map
          (name: {
            inherit name;
            value = pkgs.${name};
          })
          packageNames
        );
      }
    );
}
