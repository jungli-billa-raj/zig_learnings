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


// I learnt so much while building this. 
// I know the code is not perfect at all but I'm happy that it works. 
// My concerns:
// 1. I think using page_allocator is a wrong choice here. What if the text is larger than 4KB or however large a page is ?
// 2. I don't like the idea of reading to end. I prefer reading a certain amount of bytes and writing them stdout until the end of the file is found. However, I've know idea what the end of a file looks like. I mean, I dont' know what to check. 
// 3. Just by looking at the code, it looks cumbersome and not great. 
//
// Nevertheless, I'm happy that I wrote a tool(cat) that I've been using for so long without realizing how it workds. 😝
