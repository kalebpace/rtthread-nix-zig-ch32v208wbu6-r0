{ pkgs }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-darwin = "x86_64";
    aarch64-darwin = "arm64";
  }.${system} or throwSystem;

  mounriver-toolchain = with pkgs; fetchzip {
    url = "http://file.mounriver.com/tools/MRS_Toolchain_MAC_V180.zip";
    sha256 = "sha256-geKNRbp7M+Zed24fI1MRmbtLQQWBI6biqFQSB7dX4Vo=";
  };
in
{
  openocd = with pkgs; stdenv.mkDerivation {
    name = "openocd";
    buildInputs = [ unzip ];
    src = mounriver-toolchain;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out
      
      unzip ./openocd_${plat}.zip

      cp -r ./openocd_${plat}/openocd_${plat}/* $out
    '';
  };

  gcc = with pkgs; stdenv.mkDerivation {
    name = "gcc";
    buildInputs = [ unzip ];
    src = mounriver-toolchain;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out
      
      unzip ./xpack-riscv-none-embed-gcc-8.2.0.zip

      cp -r ./xpack-riscv-none-embed-gcc-8.2.0/* $out
    '';
  };
}
