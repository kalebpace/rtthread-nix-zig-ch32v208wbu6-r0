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

        vscodeWithExtensions = import ./nix/vscodeWithExtensions.nix { inherit pkgs; };

        wchisp = import ./nix/wchisp { inherit pkgs fenix; };
        mrs-toolchain = import ./nix/mrs-toolchain { inherit pkgs; };
        rtthread = import ./nix/rtthread { inherit pkgs; inherit (mrs-toolchain) gcc; };

        default = import ./default.nix { inherit pkgs; };
      in
      rec {
        packages = {
          inherit
            rtthread
            mrs-toolchain
            wchisp
            default;
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
