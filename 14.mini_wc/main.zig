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

fn print(address: []const u8) !void{
    const file = try std.fs.cwd().openFile(address, .{ .mode = .read_only });
    defer file.close();

    var buffer:[1]u8 = undefined;
    var word_count:u32 = 0;
    var bytes_count:u32 = 0;
    var line_count:u32 = 0; 

    while (true){
        const read_byte = try file.read(&buffer);
        if (read_byte==0) break;
        if (buffer[0]==' ') word_count+=1;
        if (buffer[0]=='\n') line_count+=1;
        bytes_count+=1;
    }
    // <lines> <words> <bytes> README.md
    std.debug.print("{d} {d} {d} {s}\n", .{line_count, word_count, bytes_count, address});
    return;
}
