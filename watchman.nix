{ stdenv, fetchzip, patchelf }:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux";
    x86_64-darwin = "macos";
    aarch64-darwin = "macos"; # rosetta
  }.${system};

  sha256 = {
    linux = "sha256-S+Z/Y5epZJuPfaM3O89n/VYzRLR671SltRBAghQFGX8=";
    macos = "sha256-6ut+DUDBe4opCYeR65JxMBe1tsIG/jmps3hi86irIWE=";
  }.${plat};
in
stdenv.mkDerivation rec {
  pname = "watchman";
  version = "2022.07.04.00";

  src = fetchzip {
    url = "https://github.com/facebook/watchman/releases/download/v${version}/watchman-v${version}-${plat}.zip";
    inherit sha256;
  };

  nativeBuildInputs = [
    patchelf
  ];
  buildPhase = ''
    cp -r $src/bin .
    cp -r $src/lib .
  '' + {
    linux = ''
    '';
    macos = ''
      for target in {lib,bin}/*; do
        for lib in lib/*; do
          install_name_tool -change /usr/local/lib/`basename $lib` $out/lib/`basename $lib` $target
        done
      done
    '';
  }.${plat};
  installPhase = ''
    mkdir -p $out
    cp -r ./bin $out
    cp -r ./lib $out
  '';
}
