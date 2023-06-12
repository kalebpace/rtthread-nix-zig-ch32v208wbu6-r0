{ pkgs }:
let
  env = with pkgs; fetchFromGitHub {
    owner = "RT-Thread";
    repo = "env";
    rev = "master";
    hash = "sha256-Z2wNaqalFd2GcLEFk0gwIgleJV8Y3sWO6PeQPxlcY2I=";
  };

  packages = with pkgs; fetchFromGitHub {
    owner = "RT-Thread";
    repo = "packages";
    rev = "master";
    hash = "sha256-gKCfzvsiE8IdG7VFoMqOs//7oyznNuPUhhGO75kfKmA=";
  };
in
with pkgs; stdenvNoCC.mkDerivation {
  name = "env";
  description = "Populates the .env directory to circumvent menuconfig cloning dependencies into it";
  buildInputs = [ unzip ];
  src = env; 
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p \
      tools/scripts \
      packages/packages \
      $out 
    
    cp -r ${env}/* tools/scripts 
    cp ${packages}/Kconfig packages/Kconfig
    cp -r ${packages}/* packages/packages

    cp -r ./tools ./packages $out
  '';
}
