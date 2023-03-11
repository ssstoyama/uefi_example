const uefi = @import("std").os.uefi;
const common = @import("common.zig");
const ST = @import("efi.zig").ST;

const MAX_COMMAND_LEN: usize = 100;

pub fn run() void {
    var command: [MAX_COMMAND_LEN]u16 = .{0} ** MAX_COMMAND_LEN;

    while (true) {
        common.puts("uefi>");
        if (common.gets(@ptrCast([*:0]u16, &command), MAX_COMMAND_LEN) <= 0) continue;

        if (common.strcmp(&[_:0]u16{ 'h', 'e', 'l', 'l', 'o' }, @ptrCast([*:0]u16, &command)) == 0) {
            common.puts("Hello UEFI!\r\n");
        } else if (common.strcmp(&[_:0]u16{ 'c', 'l', 'e', 'a', 'r' }, @ptrCast([*:0]u16, &command)) == 0) {
            _ = ST().con_out.?.clearScreen();
        } else {
            common.puts("Command not found\r\n");
        }
    }
}
