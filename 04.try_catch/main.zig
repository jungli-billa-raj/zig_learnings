const print = @import("std").debug.print;

fn mightFail(x: i32) !i32 {
    if (x<0) return error.NegativeNumberNotAllowed else return x;
}

pub fn main() !void {
    // const correct = mightFail(42) catch |err| {
    //                                 print("Error occured: {}\n", .{err});
    //                                 return err;
    //                             };
    // print("Result: {d}\n", .{correct});
    //
    // const wrong = mightFail(-98) catch |err| {
    //                                 print("Error occured: {}\n", .{err});
    //                                 return err;
    //                             };
    // print("Result: {d}\n", .{wrong}); // but this doesn't feel right. Instead of returning I want this print stamtement to not run. 
    //
    //
    // Instead we can use "if".
    // Yes, in Zig , 'if' can pattern match .

    if (mightFail(42)) |result| {
        print("{}\n", .{result});
    } else |err| {
        print("error occured: {}\n", .{err});
    }

    if (mightFail(-92)) |result| {
        print("{}\n", .{result});
    } else |err| {
        print("error occured: {}\n", .{err});
    }
}
