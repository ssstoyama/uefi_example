const uefi = @import("std").os.uefi;
const common = @import("common.zig");

const MAX_COMMAND_LEN: usize = 100;

pub fn run() void {
    var command: [MAX_COMMAND_LEN]u16 = .{0} ** MAX_COMMAND_LEN;

    while (true) {
        common.puts(&[_:0]u16{ 'u', 'e', 'f', 'i', '>', ' ' });
        if (common.gets(@ptrCast([*:0]u16, &command), MAX_COMMAND_LEN) <= 0) continue;

        if (common.strcmp(&[_:0]u16{ 'h', 'e', 'l', 'l', 'o' }, @ptrCast([*:0]u16, &command)) == 0) {
            common.puts(&[_:0]u16{ 'H', 'e', 'l', 'l', 'o', ' ', 'U', 'E', 'F', 'I', '!', '\r', '\n' });
        } else {
            common.puts(&[_:0]u16{ 'C', 'o', 'm', 'm', 'a', 'n', 'd', ' ', 'n', 'o', 't', ' ', 'f', 'o', 'u', 'n', 'd', '.', '\r', '\n' });
        }
    }
}
