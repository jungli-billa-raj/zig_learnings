const x = add(0,y);
const y = add(5,12);

test "container level variable" {
    try assert(x==17);
    try assert(y==17);
}

pub fn add(a:u32, b:u32) u32{
    return a+b;
}

const assert = @import("std").testing.expect;
