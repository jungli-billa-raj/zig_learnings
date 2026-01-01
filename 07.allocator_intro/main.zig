// exercise (small, powerful)
//
// Write a function:
//
// fn doubleAlloc(
//     allocator: std.mem.Allocator,
//     n: usize,
// ) ![]i32
//
//
// Requirements:
//
// 1.allocate n integers
// 2.fill with i * 2
// 3.use errdefer correctly
// 4.caller must free the result
//
// Don’t rush.
// This is where Zig becomes honest and beautiful.


const std = @import("std"); 

fn doubleAlloc(
    allocator: std.mem.Allocator,
    n: usize,
) ![]i32{
    const buf = try allocator.alloc(i32, n);
    errdefer allocator.free(buf);

    for (buf, 0..) |*value, i| {
        value.* = @intCast(i*2); // to be more explicit, value.* = @as(i32, @intCast(i*2)); 
    }

    return buf;

}

pub fn main() !void {
   // using a page allocator to call doubleAlloc()
   const allocator = std.heap.page_allocator;

   const result = try doubleAlloc(allocator, 55);
   defer allocator.free(result);

   std.debug.print("The result :{any}\n", .{result});
}
