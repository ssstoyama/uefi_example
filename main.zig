const uefi = @import("std").os.uefi;

pub fn main() void {
    const con_out = uefi.system_table.con_out.?;

    _ = con_out.reset(false);
    _ = con_out.outputString(&[_:0]u16{ 'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!' });

    const boot_services = uefi.system_table.boot_services.?;

    _ = boot_services.stall(5 * 1000 * 1000);
}
