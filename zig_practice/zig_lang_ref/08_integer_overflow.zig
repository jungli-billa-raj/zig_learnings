const std = @import("std");

const print = std.debug.print;
const expect = std.testing.expect;
const max_int = std.math.maxInt(i32); 
const min_int = std.math.minInt(i32); 

test "integer overflow prevention" {
    var x:i32 = max_int;
    x = x +% 1;
    print("Expected: {}  Got: {}\n", .{min_int, x});
    try expect(x==min_int);

    var y:i32 = min_int;
    y = y -% 1;
    print("Expected: {}  Got: {}\n", .{max_int, x});
    try expect(y == max_int);

}
