// Write a function:
//
// ```zig
// fn readFile(
//     allocator: std.mem.Allocator,
//     path: []const u8,
// ) ![]u8
// ```
//
// Requirements:
//
// 1. open file
// 2. read contents into allocated buffer
// 3. close file
// 4. return buffer
// 5. caller frees it

const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    
    const file = try std.fs.cwd().readFile("README.md", .{ .read = true});
    defer file.close();

    const data = try file.readToEndAlloc(
        allocator,
        1024 * 1024,
        );
    defer allocator.free(data); 
    
    std.debug.print("File contents:\n{s}\n", .{data});
}
