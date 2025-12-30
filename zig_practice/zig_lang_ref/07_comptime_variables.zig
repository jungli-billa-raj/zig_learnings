
test "comptime varialble" {
    var x:i32 = 1;
    comptime var y:i32 = 2;
    
    x += 1;
    y += 1;

    try expect(x==2);
    try expect(y==3);

    if (y!=3){
        @compileError("Unreachable statement reached");
    }
}

const expect = @import("std").testing.expect;
