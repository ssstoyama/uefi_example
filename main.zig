const uefi = @import("std").os.uefi;

pub fn main() void {
    const con_in = uefi.system_table.con_in.?;
    const con_out = uefi.system_table.con_out.?;

    _ = con_out.clearScreen();
    _ = con_out.outputString(&[_:0]u16{ 'H', 'e', 'l', 'l', 'o', ' ', 'U', 'E', 'F', 'I', '!', '\r', '\n' });
    var key: uefi.protocols.InputKey = undefined;
    var str: [3]u16 = .{0} ** 3;
    while (true) {
        switch (con_in.readKeyStroke(&key)) {
            .Success => {
                if (key.unicode_char != '\r') {
                    str[0] = key.unicode_char;
                    str[1] = 0;
                } else {
                    str[0] = '\r';
                    str[1] = '\n';
                    str[2] = 0;
                }
                _ = con_out.outputString(&[3:0]u16{ str[0], str[1], str[2] });
            },
            else => {},
        }
    }
}
