const std = @import("std");

const twoBufError = error{
    TooLarge, 
    OutOfMemory,
};

fn twoAlloc(
    allocator: std.mem.Allocator,
    n: usize
    ) twoBufError!struct {
    a:[]i32,
    b:[]i32,
} {
   const a = try allocator.alloc(i32, n);
   errdefer allocator.free(a);

   const b = try allocator.alloc(i32, n);
   errdefer allocator.free(b);

   if (n>10) return twoBufError.TooLarge;

   for (a, 0..) |*value, i|  value.* = @intCast(i);
   for (b, 0..) |*value, i|  value.* = @intCast(i*2);

   return .{ .a=a , .b=b };
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    if (twoAlloc(allocator, 5)) |result| {
        std.debug.print("a: {}\n", .{result});
        defer allocator.free(result.a);
        defer allocator.free(result.b);
    } else |err| {
        std.debug.print("An error occured: {}\n", .{err});
    }

    if (twoAlloc(allocator, 15)) |result| {
        std.debug.print("b: {}\n", .{result});
        defer allocator.free(result.a);
        defer allocator.free(result.b);
    } else |err| {
        std.debug.print("An error occured: {}\n", .{err});
    }
}
