
// TASK: Write
// fn mightFail(x: i32) !i32
//
// if x < 0 → error
// else return x * 2
// Then in main:
// print result if ok
// exit 1 if error

const print = @import("std").debug.print;

fn mightFail(x: i32) !i32 {
    if (x<0) return error.NegativeNumberNotAllowed else return x;
}

pub fn main() !void {
    print("Result: {}\n", .{try mightFail(42)});
    print("Result: {}\n", .{try mightFail(-98)});

    // Why the program stopped (important rule)

    // One-liner:
    // try means “I refuse to handle this error here”.
    // So Zig says:
    // “Alright, I’ll stop the program and tell you why.”
    // This is intentional
}
