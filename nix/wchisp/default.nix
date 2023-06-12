{ pkgs, fenix, system }:
let
  wchisp = pkgs.fetchFromGitHub {
    owner = "ch32-rs";
    repo = "wchisp";
    rev = "master";
    sha256 = "sha256-iBN+sBHu9vD3nwy0FAP3Uut5+uV5LTvSK9kqCGhLnfQ=";
  };

  toolchain = fenix.packages.${system}.minimal.toolchain;

  darwinDeps = with pkgs; [
    libiconv
  ] ++ (with pkgs.darwin.apple_sdk_11_0.frameworks; [
    Security
    CoreFoundation
  ]);
in
with pkgs; (makeRustPlatform {
  cargo = toolchain;
  rustc = toolchain;
}).buildRustPackage {
  pname = wchisp.repo;
  version = wchisp.rev;
  src = wchisp;
  buildInputs = [ ]
    ++ lib.optional stdenv.isDarwin
    [
      darwinDeps
    ];
  cargoSha256 = "sha256-qT8soQlD/xo9Ud1lS96/c+tJynDbeuYR1n98m1Z3MDg=";
}
