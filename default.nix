{ pkgs, rtthread }:
with pkgs; stdenv.mkDerivation {
  name = "ch32v208-binary-clock";
  src = ./.;
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];
  nativeBuildInputs = [ rtthread.root ];
  buildPhase = ''
    export HOME=.
    # FIX ME: include package natively instead of copying.
    # Both in default package and in devshell so reliance on result/ is gone.
    cp -r ${rtthread.root} result/
    
    ${zig}/bin/zig build
  '';
  installPhase = ''
    mkdir -p $out
    cp -r ./zig-out/* $out/
  '';
}
