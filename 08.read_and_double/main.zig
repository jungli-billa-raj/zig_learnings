const std = @import("std");

fn readAndDouble(allocator: std.mem.Allocator, n:usize) ![]i32 {
    if (n>10) return tooBigError.bigNumber;

    const buf = try allocator.alloc(i32, n);
    errdefer allocator.free(buf);

    for (buf, 0..) |*value, i| {
        value.* = @intCast(i*2);
    }

    return buf;
}

const tooBigError = error{
    bigNumber,
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const result1 = try readAndDouble(allocator, 8);
    std.debug.print("Result: {any}\n", .{result1});

    const result2 = readAndDouble(allocator, 11) catch |err| {
        std.debug.print("An error occured: {}\n", .{err});
        return;
};
    std.debug.print("Result: {any}\n", .{result2});
}
