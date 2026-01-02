fn doubleView(data: []i32) void {
    for (data) |*v| {
        v.* *= 2;
    }
}

const std = @import("std");

pub fn main() !void {
    var data1 = [_]i32{ 4, 5, 6 };

    doubleView(data1[0..]);

    std.debug.print("Modified Data: {any}\n", .{data1});
}
