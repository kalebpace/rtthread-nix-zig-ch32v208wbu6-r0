{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        buildInputs = with pkgs; [
          scons
          zig
        ];

        mrs-toolchain = import ./nix/mrs-toolchain { inherit pkgs; };
        rtthread = import ./nix/rtthread {
          inherit pkgs;
          toolchain-gcc = mrs-toolchain.gcc;
        };

        vsCodeWithExtensions = with pkgs; vscode-with-extensions.override {
          vscode = vscodium;
          vscodeExtensions = with vscode-extensions; [
            jnoortheen.nix-ide
            arrterian.nix-env-selector
            asvetliakov.vscode-neovim
          ] ++ vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "gitlens";
              publisher = "eamodio";
              version = "latest";
              sha256 = "sha256-/z49Lv9p7CL+FtjvZfI8KUZriqA2l/orlnW/MoZpP9E=";
            }
            {
              name = "vscode-zig";
              publisher = "ziglang";
              version = "latest";
              sha256 = "sha256-szG/Fm86RWWNITIYNvCQmEv8tx2VCAxtkXyQrb7Wsn4=";
            }
            {
              name = "rt-thread-studio";
              publisher = "RT-Thread";
              version = "latest";
              sha256 = "sha256-obQjGowO/DOuMaWBWqrRdlCyvu/WxefMn5M09neUJMI=";
            }
          ];
        };
      in
      rec {
        packages = {
          inherit rtthread mrs-toolchain;
          default = with pkgs.stdenv; mkDerivation {
            name = "hello-world-ch32";
            inherit buildInputs;
            src = ./.;
            phases = [ "unpackPhase" "installPhase" ];
            installPhase = ''
              mkdir -p $out
              cp -r . $out
            '';
          };
        };

        apps = {
          default = {
            type = "app";
            program = toString (pkgs.writeShellScript "flash" 
            ''
              ${mrs-toolchain.openocd}/bin/openocd  \
                -f ${mrs-toolchain.openocd}/bin/wch-riscv.cfg \
                -c init \
                -c halt \
                -c 'flash write_image ${rtthread.bsp.wch.risc-v.ch32v208w-r0}/rtthread.bin'
            '');
          };
        };

        devShells = {
          default = with pkgs; (mkShell.override { stdenv = stdenvNoCC; } {
            nativeBuildInputs = buildInputs ++ [
              vsCodeWithExtensions
              neovim
            ];
          });
        };
      }
    );
}
