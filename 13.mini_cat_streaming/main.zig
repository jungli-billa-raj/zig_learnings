const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.skip(); // skip the name of the executable
                     
    // ------------------------------------------------------------------------------------------------------
    var buffer:[100]u8 = undefined;


    // ------------------------------------------------------------------------------------------------------
    const first_arg = args.next() orelse "";
    if (std.mem.eql(u8, first_arg, "")) {
        std.debug.print("Enter some argument: \n", .{} );
        return;
    }

    try print(buffer[0..], first_arg);
        while (true) {
        if (args.next())  |arg| {
            try print(buffer[0..], arg);
        } else return;
    }
    
}


fn print(buffer: []u8,  address: []const u8) !void {
    const file =  std.fs.cwd().openFile(address, .{ .mode = .read_only }) catch |err| {
        std.debug.print("Error with file: .{s}\nError: .{}\n", .{address, err});
        return;
};
    defer file.close();

    while(true) {
        const bytes_read = try file.read(buffer);
        // std.debug.print("{s}", .{buffer[0..]}); // This is wrong. It will always print everything inside the buffer even if the thing read is smaller than the buffer size. There's a good reason why bytes_read return usize, the size of bytes read. 
        std.debug.print("{s}", .{buffer[0..bytes_read]});
        if (bytes_read == 0) return;
    }


}


