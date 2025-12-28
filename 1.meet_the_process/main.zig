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
    const name = "Raj";
    std.debug.print("{*}\n", .{name});

    // Address of a heap allocation
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // I had trouble creating []u8 as the create() does not take a second argument. How am I going to specify the size of the char array I'm trying to init as string. The name 'allocated_name' shows my past endevavours to initialize a string.  
    const allocated_name = try allocator.create(u8); // I do not understand why this has to be const. I'm clearly modifying it in the very next line. 
    defer allocator.destroy(allocated_name);
    // allocated_name.* = "RAJ";
    allocated_name.* = 123;

    std.debug.print("{*}\n", .{allocated_name} );
    std.debug.print("value of allocated_name is {d}\n", .{allocated_name.*} );

    // Process ID
    const pid = std.os.linux.getpid();
    std.debug.print("The current process ID : {}\n", .{pid});

    // Parent process ID
    const p_pid = std.os.linux.getppid();
    std.debug.print("The current parent process ID : {}\n", .{p_pid});
   
}
