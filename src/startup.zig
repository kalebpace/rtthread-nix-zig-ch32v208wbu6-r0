const main = @import("main.zig");
// ENTRYPOINT (_start) in linker scri
export fn @"_start"() void {
    main.main();
    unreachable;
}
