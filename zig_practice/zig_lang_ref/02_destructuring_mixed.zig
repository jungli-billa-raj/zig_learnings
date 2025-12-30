const print = @import("std").debug.print;


pub fn main() !void {
   var x:i32 = undefined;

   const tuple = .{1, 2, 3};

   x, var y:u32, const z = tuple;

   print("x={} y={} z={}\n", .{x, y, z});

   y = 4;

   _, x, _ = tuple;

   print("x={} y={} z={}\n", .{x, y, z});

   print("tuple y={d}\n", .{tuple.@"1"});
}
