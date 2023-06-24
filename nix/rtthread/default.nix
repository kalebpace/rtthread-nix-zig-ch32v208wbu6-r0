{ pkgs, gcc }:
let
  rtthread = with pkgs; fetchFromGitHub {
    owner = "RT-Thread";
    repo = "rt-thread";
    rev = "0b6f7743f142daff066d14b99b85a60eb0e8a4a0";
    hash = "sha256-Fxzd9Gtq9uvJ9MHlwdE9WYUWpvTUotI2s+NWOrF5blI=";
  };

  env = import ./env.nix { inherit pkgs; };
in
rec {
  root = with pkgs; stdenvNoCC.mkDerivation {
    name = "rtthread";
    buildInputs = [ unzip ];
    src = rtthread;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };

  bsp.wch.risc-v = {
    ch32v208w-r0 = with pkgs; stdenvNoCC.mkDerivation {
      name = "ch32v208w-r0";
      nativeBuildInputs = [
        unzip
        scons
        git
        python311.pkgs.requests
      ];
      src = rtthread;
      sourceRoot = "source/bsp/wch/risc-v/ch32v208w-r0";
      phases = [ "unpackPhase" "buildPhase" "installPhase" ];
      buildPhase = ''
        export RTT_EXEC_PATH=${gcc}/bin
        
        # Menuconfig tries to write env tools to home so a shim is needed
        # https://github.com/RT-Thread/rt-thread/blob/1d239db59e58e0439d9f4fc61de44221bf5d9535/tools/menuconfig.py#L148
        export HOME=.
        export ENV_ROOT=$HOME
        cp -r ${env} .env
        export PATH=./.env/tools/scripts:$PATH
        
        # FIXME: scons links libraries in parent directory 
        # which is outside of the allowed build scope.
        # What is a good way to address /etc/paths.d error in sandboxed builder?
        chmod 755 -R ../
        
        scons --menuconfig
        pkgs --update
        scons
      '';

      installPhase = ''
        mkdir -p $out
        cp *.elf *.bin $out
      '';
    };
  };
}
