const s = struct {
    var a:u32 = 1234;
};

fn increment() u32 {
    s.a += 1;
    return s.a;
}

test "namespaced container variable"{
    try expect(increment()==1235);
    try expect(increment()==1236);
}

const expect = @import("std").testing.expect;
