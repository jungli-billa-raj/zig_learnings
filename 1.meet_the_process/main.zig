// Task
//
// Write a Zig program that prints:
//
// Address of a stack variable
//
// Address of a heap allocation
//
// Process ID
//
// Parent process ID
//

const std = @import("std");

pub fn main() !void {
    // Address of a stack variable
    var stack_value:u32 = 42; // so you are saying that I cannot allocate a string on the stack? Doesn't seem right. Also, what the hell is static/ read only memeory?
    std.debug.print("Address of stack_value: {*}\n", .{&stack_value});

    // Address of heap allocation
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    const name = try allocator.alloc(u8, 3);
    defer allocator.free(name);
    name[0] = 'R';
    name[1] = 'A';
    name[2] = 'J';
    std.debug.print("Address of heap allocated name: {*}\n", .{name});


    // Process ID
    const pid = std.os.linux.getpid();
    std.debug.print("The current process ID : {}\n", .{pid});

    // Parent process ID
    const p_pid = std.os.linux.getppid();
    std.debug.print("The current parent process ID : {}\n", .{p_pid});
   
}
