const uefi = @import("std").os.uefi;

pub fn main() void {
    const con_out = uefi.system_table.con_out.?;

    _ = con_out.reset(false);
    _ = con_out.outputString(&[_:0]u16{ 'H', 'e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd', '!', '\r', '\n' });

    var key: uefi.protocols.InputKey = undefined;
    var str: [3]u16 = .{0} ** 3;
    while (true) {
        _ = uefi.system_table.con_in.?.readKeyStroke(&key);
        if (key.unicode_char != '\r') {
            str[0] = key.unicode_char;
            str[1] = 0;
        } else {
            str[0] = '\r';
            str[1] = '\n';
            str[2] = 0;
        }
        _ = con_out.outputString(&[3:0]u16{ str[0], str[1], str[2] });
    }
    const boot_services = uefi.system_table.boot_services.?;

    _ = boot_services.stall(5 * 1000 * 1000);
}
