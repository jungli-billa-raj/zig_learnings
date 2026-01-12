const std = @import("std");

fn print(address: []u8, pattern: []u8) !void{
    const file = std.fs.cwd().openFile(address, .{ .mode = .read_only});
    defer file.close();

    var read_buf:[4096]u8 = undefined;
    var line_buf:[4096]u8 = undefined;

    while (true) {
        const n = try file.read(&read_buf);
        if (n==0) return;

        std.mem.indexOf()
    } 


}
