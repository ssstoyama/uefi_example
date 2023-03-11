const uefi = @import("std").os.uefi;

var st: *uefi.tables.SystemTable = undefined;

pub fn ST() *uefi.tables.SystemTable {
    return st;
}

pub fn init(system_table: *uefi.tables.SystemTable) void {
    st = system_table;
    // ウォッチドッグタイマー無効化。無効化しないと 5 分後に再起動するため。
    _ = st.boot_services.?.setWatchdogTimer(0, 0, 0, null);
}