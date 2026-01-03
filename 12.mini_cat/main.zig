const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.skip(); // skip the name of the executable
    var i:usize = 1;
    if (args.next() == null) {
        std.debug.print("Enter some argument: \n", .{} );
        return;
    }
    while (args.next())  |arg| : (i += 1) {
        std.debug.print("{d} : {s}\n", .{i, arg});
    }
    
}
