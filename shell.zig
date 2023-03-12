const uefi = @import("std").os.uefi;
const common = @import("common.zig");
const efi = @import("efi.zig");
const graphics = @import("graphics.zig");

const MAX_COMMAND_LEN: usize = 100;

pub fn run() void {
    var command: [MAX_COMMAND_LEN]u16 = .{0} ** MAX_COMMAND_LEN;

    while (true) {
        common.puts("uefi>");
        if (common.gets(@ptrCast([*:0]u16, &command), MAX_COMMAND_LEN) <= 0) continue;

        if (common.strcmp(&[_:0]u16{ 'h', 'e', 'l', 'l', 'o' }, @ptrCast([*:0]u16, &command)) == 0) {
            common.puts("Hello UEFI!\r\n");
        } else if (common.strcmp(&[_:0]u16{ 'r', 'e', 'c', 't' }, @ptrCast([*:0]u16, &command)) == 0) {
            graphics.drawRect(.{ .x = 100, .y = 10, .w = 100, .h = 200 }, graphics.PixelColor.white());
        } else if (common.strcmp(&[_:0]u16{ 'c', 'l', 'e', 'a', 'r' }, @ptrCast([*:0]u16, &command)) == 0) {
            _ = efi.st.con_out.?.clearScreen();
        } else {
            common.puts("Command not found\r\n");
        }
    }
}
