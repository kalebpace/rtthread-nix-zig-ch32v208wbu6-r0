{ pkgs }:
let
  env = with pkgs; fetchFromGitHub {
    owner = "RT-Thread";
    repo = "env";
    rev = "e028fbd8fcbe0e1e86bc9de33274802c86095d31";
    sha256 = "sha256-Z2wNaqalFd2GcLEFk0gwIgleJV8Y3sWO6PeQPxlcY2I=";
  };

  packages = with pkgs; fetchFromGitHub {
    owner = "RT-Thread";
    repo = "packages";
    rev = "37c6a79152f90414467e8e9b4be0dc439be73de8";
    sha256 = "sha256-3y08jGriIt6Rldf3VVHFlPIl4skUDXj1TW7C6Gu8Quo=";
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
