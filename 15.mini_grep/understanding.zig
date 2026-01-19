const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var args_iterator = try std.process.argsWithAllocator(allocator);
    defer args_iterator.deinit(); 

    _ = args_iterator.skip();

    const first_arg = args_iterator.next() orelse "";
    if (std.mem.eql(u8, first_arg, "")){
        std.debug.print("Please enter some argument\n", .{});
        return;
    }

    try print(first_arg);
    while (true) {
        if (args_iterator.next()) |arg| {
            try print(arg);
        } else return;
    }
}

pub fn print(address: []const u8) !void{
    const file = try std.fs.cwd().openFile(address, .{ .mode = .read_only } );
    defer file.close();

    var trial_buffer:[4096]u8 = undefined;
    _ = try file.read(&trial_buffer);
    std.debug.print("{s}", .{trial_buffer});

}
