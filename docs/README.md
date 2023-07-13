# RT-Thread with Nix and Zig on a CH32V208WBU6

What I wanted to do
- I wanted to expiriment with Zig to evaluate the ease of replacing the RISC-V gcc toolchain to compile RT-Thread
- I wanted to link a Zig application against RT-Thread
- I wanted to create a Nix workflow to make board and application development easier
- I wanted to build an OLED binary clock

What I did
- [x] LED blink with [example application](https://github.com/RT-Thread/rt-thread/blob/0b6f7743f142daff066d14b99b85a60eb0e8a4a0/bsp/wch/risc-v/ch32v208w-r0/applications/main.c)
- Learned about the board, deving with onboard LED and included flashing capability (any docs that point this out?)
- Made a neat little nix project
    ## Summary
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
    - Used MRS to flash the WCH-Link with new firmware which fixed "unknown version" and flashed a working CH32V208WBU6 template from here

    
## Assets
- Picture of board with WCH-Link and Schematic?
- Picture of board with usb-c direct connection
- Gif of board flashing LED, big led and onboard
    - talk about pins and their usage for the LED
- Screenshots of RT-Thread/MRS Studio Configs
- Screenshots of build/flash successes and errors

## Resources
- http://wch-ic.com/downloads/WCHISPTool_Setup_exe.html
- https://rbino.com/posts/zig-stm32-blink/
- https://lupyuen.github.io/articles/zig
- https://github.com/ziglang/zig/issues/9760
