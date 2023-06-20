{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, fenix }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        wchisp = import ./nix/wchisp { inherit pkgs fenix; };
        mrs-toolchain = import ./nix/mrs-toolchain { inherit pkgs; };
        rtthread = import ./nix/rtthread { inherit pkgs; inherit (mrs-toolchain) gcc; };

        vscodeWithExtensions = with pkgs; vscode-with-extensions.override {
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
          inherit
            rtthread
            mrs-toolchain
            wchisp;
          default = import ./. { inherit pkgs rtthread; };
        };

        apps = {
          wch-link = {
            flash = {
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

          wchisp = {
            flash = {
              type = "app";
              program = toString (pkgs.writeShellScript "flash"
                ''
                  ${wchisp}/bin/wchisp flash ${rtthread.bsp.wch.risc-v.ch32v208w-r0}/rtthread.bin
                '');
            };
          };
        };

        devShells = {
          default = with pkgs; (mkShell.override { stdenv = stdenvNoCC; } {
            nativeBuildInputs = [
              vscodeWithExtensions
              neovim
              scons
              zig
            ];
          });
        };
      }
    );
}
