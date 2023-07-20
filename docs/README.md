# RT-Thread with Nix and Zig on CH32V208WBU6

## Getting Started

Setup Nix on macOS: https://zero-to-nix.com/start/install

| Command                                            | Description
| -------------------------------------------------- | --------------------------------------- |
| `nix build .#rtthread.bsp.wch.risc-v.ch32v208w-r0` | Builds the [ch32v208w-r0 example project](https://github.com/RT-Thread/rt-thread/blob/0b6f7743f142daff066d14b99b85a60eb0e8a4a0/bsp/wch/risc-v/ch32v208w-r0/applications/main.c) using the [MRS Toolchain for macOS](http://www.mounriver.com/download) |
| `nix run .#wchisp.flash` | Flash a board connected via USB-C and in download mode |
| `nix run .#wch-link.flash` | Flash a board connected via WCH Link and in download mode |

## Project Features & Goals
- [x] Build, flash, and blink onboard LED with [example application](https://github.com/RT-Thread/rt-thread/blob/0b6f7743f142daff066d14b99b85a60eb0e8a4a0/bsp/wch/risc-v/ch32v208w-r0/applications/main.c) using the Nix interface
- [ ] Configure RT-Thread with `menuconfig` using the Nix interface
  - [ ] Enable ESP module for wifi connectivity
  - [ ] Enable Arduino compatability mode
- [ ] Build blink project using `zig cc` 
- [ ] Port blink to `main.zig` and build with `build.zig`
- [ ] Implement [I<sup>2</sup>C OLED](https://www.amazon.com/Pieces-Display-Module-SSD1306-Screen/dp/B08N6N8L5Q) binary clock

# Introduction

This project started with the intention to build a simple binary clock using RT-Thread and Zig. Due in part to its [first-class C interop](https://ziglearn.org/chapter-4/), Zig was chosen to evaluate its tooling, build system, and its ease of use as a drop-in `gcc` replacement. 
Though, after spending significant time setting up tooling, piecing together documentation, and verifying board health/features, focus shifted more to developer experience than on project implementation.

Once receiving a [CH32V208WBU6 development board from WCH](https://www.wch.cn/products/CH32V208.html) as part of the RT-Thread hackathon/competition, my first todo was to verify the board was healthy. This was met with difficulty in building provided example applications, configuring multiple IDEs: RT-Thread Studio and MounRiver Studio, and 
finding the necessary tools to flash/debug the dev board. 

There was also a separate interest in developing on a Macbook Pro M1 with VSCode instead of Windows 10 with Eclipse-based IDEs. This lead to the setup of a Nix project to aid in managing tools, environments, and any cross-building needs that may surface. 



<!-- ## Summary
- It collects all my tools for me, builds them, version and hashes them
- Keeps all my dependencies verifiable and immutible
- Builds a custom toolchain and injects it into RT-Thread build environment to support building for a custom BSP
- Overrides RT-Thread defaults to build in a sandboxed, pre-cached environment

## Walkthrough
- mrs-toolchain, easy archive mangement
- wchisp, no fuss rust
- rt-thread, cached env and packages, overrides without mutating root
- How to Use, nix run magic


Issues I ran into
- scons & menuconfig have a lot of leaky/implicit things going on
- Getting a simple RT-Thread project setup for a given board was unintuitive
    - No documentation on the proper way to flash the board, so I ordered a WCH link to be safe (and for debugging)
    - Went through multiple tools: RT-Thread Studio and MounRiver Studio to test the basic flashing process and verify the board
    - RT-Thread example ran into build issues out of the box
    - Used MRS to flash the WCH-Link with new firmware which fixed "unknown version" and flashed a working CH32V208WBU6 template from here -->

    
<!-- ## Assets
- Picture of board with WCH-Link and Schematic?
- Picture of board with usb-c direct connection
- Gif of board flashing LED, big led and onboard
    - talk about pins and their usage for the LED
- Screenshots of RT-Thread/MRS Studio Configs
- Screenshots of build/flash successes and errors -->

## Resources
- http://wch-ic.com/downloads/WCHISPTool_Setup_exe.html
- https://rbino.com/posts/zig-stm32-blink/
- https://lupyuen.github.io/articles/zig
- https://github.com/ziglang/zig/issues/9760
- https://embed-labs.dev/blog/2023/05/getting-started-with-rt-thread/
- https://reidemeister.com/?p=640
