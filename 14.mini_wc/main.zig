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

    var buffer:[100]u8 = undefined;
    var word_count:u32 = 0;
    var bytes_count:usize = 0;
    var line_count:u32 = 0; 

    var in_word:bool = false;

    while (true){
        const n = try file.read(&buffer);

        if (n==0) break;
        bytes_count += n;

        for (buffer[0..n]) |b| {
            if (b=='\n') line_count+=1;

            const is_space = b==' ' or b=='\n' or b=='\t';
            if (!is_space and !in_word) {
                word_count += 1;
                in_word = true;
            } else if (is_space) in_word = false; 
        }

    }
    // <lines> <words> <bytes> README.md
    std.debug.print(" {d} {d} {d} {s}\n", .{line_count, word_count, bytes_count, address});
    return;
}
