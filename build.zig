const std = @import("std");
const CrossTarget = std.zig.CrossTarget;

pub fn build(b: *std.Build) !void {
    const kernel = b.addExecutable(.{
        .name = "bootx64",
        .root_source_file = .{ .path = "main.zig" },
        .target = CrossTarget{
            .cpu_arch = .x86_64,
            .os_tag = .uefi,
            .abi = .msvc,
        },
        .linkage = .static,
    });

    kernel.setOutputDir("fs/efi/boot");
    kernel.install();

    const qemu = b.step("run", "run in qemu");
    const run_qemu = b.addSystemCommand(&[_][]const u8{
        "qemu-system-x86_64",
        "-bios",
        "/usr/share/ovmf/OVMF.fd",
        "-hdd",
        "fat:rw:fs",
    });
    qemu.dependOn(&run_qemu.step);
    run_qemu.step.dependOn(&kernel.step);
}
