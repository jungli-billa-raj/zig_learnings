test "static local variable" {
    try expect(increment()==1235);
    try expect(increment()==1236);
}

fn increment() u32 {
    const S = struct {
        var x:u32 = 1234;
};
    S.x += 1;
    return S.x;
}

const expect = @import("std").testing.expect;
