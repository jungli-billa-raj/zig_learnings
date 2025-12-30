const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;

test "thread local variable" {
   const thread1 = try std.Thread.spawn(.{}, testTL, .{}); 
   const thread2 = try std.Thread.spawn(.{}, testTL, .{}); 
   testTL();
   thread1.join();
   thread2.join();
}

threadlocal var counter:u32 = 1234; // looks like a gloabal variable
                                    // Because, each thread now, get's 
                                    // it's own copy

fn testTL() void {
    assert(counter == 1234);
    counter += 1;
    assert(counter == 1235);
}
