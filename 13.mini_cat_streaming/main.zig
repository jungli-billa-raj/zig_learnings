const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.skip(); // skip the name of the executable
                     
    // ------------------------------------------------------------------------------------------------------
    var buffer:[100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator().init(&buffer);
    const fb_allocator = fba.allocator();


    // ------------------------------------------------------------------------------------------------------
    const first_arg = args.next() orelse "";
    if (std.mem.eql(u8, first_arg, "")) {
        std.debug.print("Enter some argument: \n", .{} );
        return;
    }

    const memory = try fb_allocator.alloc(u8, 100); 
    defer fb_allocator.free(memory);
    try print(memory, first_arg);
        while (true) {
        if (args.next())  |arg| {
            try print(memory, arg);
        } else return;
    }
    
}


fn print(buffer: []u8,  address: []const u8) !void {
    const file =  std.fs.cwd().openFile(address, .{ .mode = .read_only }) catch |err| {
        std.debug.print("Error with file: .{s}\nError: .{}\n", .{address, err});
        return;
};
    defer file.close();

    const data = try file.read(&buffer) catch |err| {
        std.debug.print("Error with file: .{s}\nError: .{}\n", .{address, err});
        return;
};

    std.debug.print("\n{s}\n", .{data});

}


