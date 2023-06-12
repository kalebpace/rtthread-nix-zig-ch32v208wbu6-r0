{ pkgs }:
with pkgs; stdenv.mkDerivation {
  name = "ch32v208-binary-clock";
  src = ./.;
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];
  buildPhase = ''
    export HOME=.;
    ${zig}/bin/zig build
  '';
  installPhase = ''
    mkdir -p $out
    cp -r ./zig-out/* $out/
  '';
}
