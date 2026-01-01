const std = @import("std");

fn readAndDouble(allocator: std.mem.Allocator, n:usize) tooBigError![]i32 {
    const buf = allocator.alloc(i32, n) catch return tooBigError.bigNumber; // so this can return  OutOfMemory error. There are two ways to solve it. 
                                             // Either include it in your error enum struct. 
                                             // or what I did here, catch allocator error to return our defined error.
    errdefer allocator.free(buf);

    if (n>10) return tooBigError.bigNumber;

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
    defer allocator.free(result1);
    std.debug.print("Result: {any}\n", .{result1});
// This is correct and safe because the allocation was already cleared by errdefer. However the second is more simple to understand. 
//     const result2 = readAndDouble(allocator, 11) catch |err| {
//         std.debug.print("An error occured: {}\n", .{err});
//         return;
// };
//     defer allocator.free(result2);
    // std.debug.print("Result: {any}\n", .{result2});
    
    if (readAndDouble(allocator, 11)) |result2| {
        defer allocator.free(result2);
        std.debug.print("Result: {any}\n", .{result2});
    } else |err| {
        std.debug.print("An error occured: {}\n", .{err});
    }
}
