const uefi = @import("std").os.uefi;
const efi = @import("efi.zig");
const common = @import("common.zig");

pub const PixelColor = struct {
    blue: u8,
    green: u8,
    red: u8,
    reserved: u8,

    pub fn white() PixelColor {
        return PixelColor{
            .blue = 0xff,
            .green = 0xff,
            .red = 0xff,
            .reserved = 0xff,
        };
    }
};

pub const Rect = struct {
    x: usize,
    y: usize,
    w: usize,
    h: usize,
};

pub fn drawPixel(x: usize, y: usize, color: PixelColor) void {
    // const hr: u32 = efi.gop.mode.info.horizontal_resolution;
    // hr を 4 倍しないとちょうどいい感じのサイズで描画できなかった
    const hr: u32 = efi.gop.mode.info.horizontal_resolution * 4;
    const p = @intToPtr(*PixelColor, efi.gop.mode.frame_buffer_base + (hr * y) + x);
    p.blue = color.blue;
    p.green = color.green;
    p.red = color.red;
    p.reserved = color.reserved;
}

pub fn drawRect(r: Rect, color: PixelColor) void {
    var i: usize = r.x;
    while (i < (r.x + r.w)) : (i += 1) {
        drawPixel(i, r.y, color);
        drawPixel(i, r.y + r.h - 1, color);
    }
    i = r.y;
    while (i < (r.y + r.h)) : (i += 1) {
        drawPixel(r.x, i, color);
        drawPixel(r.x + r.w - 1, i, color);
    }
}
