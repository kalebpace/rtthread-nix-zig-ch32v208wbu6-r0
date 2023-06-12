{ pkgs }:
with pkgs; vscode-with-extensions.override {
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
}
