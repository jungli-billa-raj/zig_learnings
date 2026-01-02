fn doubleView(data: []i32) void {
    for (data) |*v| {
        v.* *= 2;
    }
}

const std = @import("std");

pub fn main() !void {
    // var data1 = [_]i32{ 4, 5, 6 }; // calling with stack memeory

    // calling with heap memeory
    // const allocator = std.heap.page_allocator;
    // const data1 = try allocator.alloc(i32, 3);
    // defer allocator.free(data1);
    // data1[0] = 4;
    // data1[1] = 5;
    // data1[2] = 6;

    // using fixed buffer allocator 
    // var buffer:[100]u8 = undefined;
    // var fba = std.heap.FixedBufferAllocator.init(&buffer);
    // const allocator = fba.allocator();
    //
    // const data1 = try allocator.alloc(i32, 3);
    // defer allocator.free(data1);
    // data1[0] = 4;
    // data1[1] = 5;
    // data1[2] = 6;

    // using arena allocator 
    // I'll try to use fixed buffer allocator with arena allocator
    // var buffer:[100]u8 = undefined;
    // var fba = std.heap.FixedBufferAllocator.init(&buffer);
    // var arena = std.heap.ArenaAllocator.init(fba.allocator());
    // defer arena.deinit();
    // const allocator = arena.allocator();
    //
    // const data1 = try allocator.alloc(i32, 3);
    // data1[0] = 4;
    // data1[1] = 5;
    // data1[2] = 6;
    //
    doubleView(data1[0..]);

    std.debug.print("Modified Data: {any}\n", .{data1});
}
