const print = @import("std").debug.print;


pub fn main() void{ 
    var a:u32 = 5;
    var b:u32 = 0;

    _ = .{&a, &b}; // This is important. This tells the compiler that the value of a and b will be used or modified elsewhere, so "Compiler Sir, you don't have to check it's value, alright? "
    
    const c = a/b;
    // 10_runtime_dbz_error.zig:10:16: error: division with 'i32' and 'i32': signed integers must use @divTrunc, @divFloor, or @divExact
    // changed to u32
    print("Value of c:{}\n", .{c});
}
