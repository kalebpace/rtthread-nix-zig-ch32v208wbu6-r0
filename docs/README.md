# Compiling against RT-Thread with Nix and Zig

## TODO
- [x] LED blink with [example application](https://github.com/RT-Thread/rt-thread/blob/0b6f7743f142daff066d14b99b85a60eb0e8a4a0/bsp/wch/risc-v/ch32v208w-r0/applications/main.c)
- [] Build project with example project with zig cc
- [] Build project with build.zig to circumvent much of scons
- [] LED blink with main.zig

## Dev Log

- Tried to setup RT-Thread Studio, ran into build issues, took awhile to fix and lots of slack/forum reading
- Setup MounRiver Studio on Windows 10, flashed new WCH-Link firmware with embedded tool which fixed “unknown version” error, then flashed CH32V208WBU6 template successfully
- Write nix derivations to manage/build the toolchain and rtthread template
- [Currently] understand project template build system: SConscript provides modules, KConfig provides filebased path submodules to generate rtthread.h,

## Resources
- https://codepen.io/willmcneilly/pen/gMBJmv
- http://wch-ic.com/downloads/WCHISPTool_Setup_exe.html
- https://rbino.com/posts/zig-stm32-blink/
- https://lupyuen.github.io/articles/zig
- https://github.com/ziglang/zig/issues/9760