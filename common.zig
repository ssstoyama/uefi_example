const uefi = @import("std").os.uefi;
const efi = @import("efi.zig");

const MAX_STR_BUF: usize = 100;

pub fn putc(c: u8) void {
    _ = efi.st.con_out.?.outputString(&[2:0]u16{ c, 0 });
}

pub fn puts(s: []const u8) void {
    for (s) |c| {
        putc(c);
    }
}

pub fn putws(s: []const u16) void {
    for (s) |c| {
        putc(@truncate(u8, c));
    }
}

pub fn puth(val: u64, num_digits: u8) void {
    var i: usize = undefined;
    var unicode_val: u16 = undefined;
    var str: [100]u16 = .{0} ** 100;

    if (num_digits <= 0) return;
    i = num_digits - 1;
    var v = val;
    while (true) : (i -= 1) {
        unicode_val = @truncate(u16, v & 0xf);
        if (unicode_val < 0xa) {
            str[i] = '0' + unicode_val;
        } else {
            str[i] = 'A' + (unicode_val - 0xa);
        }
        v >>= 4;
        if (i == 0) break;
    }
    str[num_digits] = 0;

    putws(&str);
}

pub fn getc() u16 {
    var key: uefi.protocols.InputKey = undefined;
    var waitidx: usize = undefined;

    _ = efi.st.boot_services.?.waitForEvent(1, &[_]uefi.Event{efi.st.con_in.?.wait_for_key}, &waitidx);
    while (efi.st.con_in.?.readKeyStroke(&key) != uefi.Status.Success) {}

    return key.unicode_char;
}

pub fn gets(buf: [*:0]u16, buf_size: usize) usize {
    var i: usize = 0;
    while (i < buf_size) : (i += 1) {
        buf[i] = getc();
        putc(@truncate(u8, buf[i]));
        if (buf[i] == '\r') {
            putc('\n');
            break;
        }
    }
    buf[i] = 0;

    return i;
}

pub fn strcmp(s1: [*:0]const u16, s2: [*:0]const u16) isize {
    var is_equal = true;

    var i: usize = 0;
    while (s1[i] != 0 and s2[i] != 0) : (i += 1) {
        if (s1[i] != s2[i]) {
            is_equal = false;
            break;
        }
    }

    if (is_equal) {
        if (s1[i] != 0) return 1;
        if (s2[i] != 0) return -1;
        return 0;
    } else {
        return @intCast(isize, s1[i]) - @intCast(isize, s2[i]);
    }
}

const testing = @import("std").testing;
test "strcmp" {
    try testing.expect(strcmp(&[_:0]u16{ 'a', 'b', 'c' }, &[_:0]u16{ 'a', 'b', 'c' }) == 0);
    try testing.expect(strcmp(&[_:0]u16{ 'a', 'b', 'c' }, &[_:0]u16{ 'a', 'b', 'c', 'd' }) == -1);
    try testing.expect(strcmp(&[_:0]u16{ 'a', 'b', 'c', 'd' }, &[_:0]u16{ 'a', 'b', 'c' }) == 1);
}
