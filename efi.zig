const uefi = @import("std").os.uefi;

pub var st: *uefi.tables.SystemTable = undefined;
pub var gop: *uefi.protocols.GraphicsOutputProtocol = undefined;

pub fn init(system_table: *uefi.tables.SystemTable) void {
    st = system_table;
    // ウォッチドッグタイマー無効化。無効化しないと 5 分後に再起動するため。
    _ = st.boot_services.?.setWatchdogTimer(0, 0, 0, null);
    var _gop: ?*uefi.protocols.GraphicsOutputProtocol = undefined;
    if (st.boot_services.?.locateProtocol(
        &uefi.protocols.GraphicsOutputProtocol.guid,
        null,
        @ptrCast(*?*anyopaque, &_gop),
    ) == uefi.Status.Success) {
        gop = _gop.?;
    }
}
