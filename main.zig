const uefi = @import("std").os.uefi;
const efi = @import("efi.zig");
const shell = @import("shell.zig");
const common = @import("common.zig");

pub fn main() void {
    _ = uefi.system_table.con_out.?.clearScreen();
    efi.init(uefi.system_table);

    shell.run();
}
