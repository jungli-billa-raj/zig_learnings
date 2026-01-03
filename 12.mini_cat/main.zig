const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.skip(); // skip the name of the executable
                     
    const first_arg = args.next() orelse "";
    if (std.mem.eql(u8, first_arg, "")) {
        std.debug.print("Enter some argument: \n", .{} );
        return;
    }

    try print(allocator, first_arg);
        while (true) {
        if (args.next())  |arg| {
            try print(allocator, arg);
        } else return;
    }
    
}


fn print(allocator:std.mem.Allocator,  address: []const u8) !void {
    const file =  std.fs.cwd().openFile(address, .{ .mode = .read_only }) catch |err| {
        std.debug.print("Error with file: .{s}\nError: .{}\n", .{address, err});
        return;
};
    defer file.close();

    const data = file.readToEndAlloc(allocator, 4*1024) catch |err| {
        std.debug.print("Error with file: .{s}\nError: .{}\n", .{address, err});
        return;
};
    defer allocator.free(data); 

    std.debug.print("\n{s}\n", .{data});

}
