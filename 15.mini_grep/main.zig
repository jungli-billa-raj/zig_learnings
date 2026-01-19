const std = @import("std");

// fn print(address: []u8, pattern: []u8) !void{
fn print(address: []u8) !void{
    const file = std.fs.cwd().openFile(address, .{ .mode = .read_only});
    defer file.close();

    var read_buf:[4096]u8 = undefined;
    var line_buf:[4096]u8 = undefined;

    // Let's try to print each line first.
    var line_len:usize = 0;

    while (true) {
        const n = try file.read(&read_buf);
        if (n==0) return;

        for (read_buf[0..n], 0..) |val, i| {
            if (val == '\n') {
                std.debug.print("{s}", .{line_buf[0..i]}); // Should I do [0..line_len] ?? But why? 
                line_len = 0;
            }
            line_buf[line_len] = val;
            line_len += 1;
        }
    } 
}

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

