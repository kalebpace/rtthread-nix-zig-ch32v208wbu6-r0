{ pkgs, fenix }:
let
  wchisp = pkgs.fetchFromGitHub {
    owner = "ch32-rs";
    repo = "wchisp";
    rev = "461639201622d52bf7c869ab074be4e69a78486e";
    sha256 = "sha256-iBN+sBHu9vD3nwy0FAP3Uut5+uV5LTvSK9kqCGhLnfQ=";
  };

  toolchain = fenix.packages.${pkgs.stdenv.hostPlatform.system}.minimal.toolchain;

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
  cargoSha256 = "sha256-Q4jet3cDbfXzO94AermMy+FUqbqxoL45pEkS6oguJqc=";
}
