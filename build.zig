const std = @import("std");

const CpuModel = std.Target.Cpu.Model;
const CpuFeature = std.Target.Cpu.Feature;
const RiscvFeature = std.Target.riscv.Feature;

const qingke_v4c_cpu = CpuModel{
    // .name = "qingke_v4c",
    .name = "generic",
    .llvm_name = "qingke-v4c",
    .features = CpuFeature.feature_set_fns(RiscvFeature).featureSet(&[_]RiscvFeature{
        .m,
        .a,
        .c,
    }),
};

pub fn build(b: *std.build.Builder) void {
    // Target QingKe V4C: RISC-V R32IMAC
    const target = .{
        // .cpu_arch = .thumb,
        .cpu_arch = std.Target.Cpu.Arch.riscv32,
        // sifive_e21 seems to share the same feature set as the QingKe V4C
        // .cpu_model = .{ .explicit = &std.Target.riscv.cpu.sifive_e21 },
        .cpu_model = .{ .explicit = &qingke_v4c_cpu },
        .os_tag = .freestanding,
        // .abi = .eabihf,
        .abi = .eabi,
    };

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const elf = b.addExecutable("zig-ch32-blink.elf", "src/main.zig");
    elf.setTarget(target);
    elf.setBuildMode(mode);

    // const vector_obj = b.addObject("vector", "src/vector.zig");
    // vector_obj.setTarget(target);
    // vector_obj.setBuildMode(mode);

    // elf.addObject(vector_obj);
    // result directory provided to build environment by nix
    elf.setLinkerScriptPath(.{ .path = "result/bsp/wch/risc-v/ch32v208w-r0/board/linker_scripts/link.lds" });

    const bin = b.addInstallRaw(elf, "zig-ch32-blink.bin", .{});
    const bin_step = b.step("bin", "Generate binary file to be flashed");
    bin_step.dependOn(&bin.step);

    // const flash_cmd = b.addSystemCommand(&[_][]const u8{
    //     "st-flash",
    //     "write",
    //     b.getInstallPath(bin.dest_dir, bin.dest_filename),
    //     "0x8000000",
    // });
    // flash_cmd.step.dependOn(&bin.step);
    // const flash_step = b.step("flash", "Flash and run the app on your STM32F4Discovery");
    // flash_step.dependOn(&flash_cmd.step);

    b.default_step.dependOn(&elf.step);
    b.default_step.dependOn(&bin.step);
    b.installArtifact(elf);
    b.installArtifact(bin.artifact);
}
