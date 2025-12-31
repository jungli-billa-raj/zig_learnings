const print = @import("std").debug.print;

const CalcError = error {
    NegativeInput,
};

fn mightFail(no: i32) CalcError!i32 {
    if (no<0) return CalcError.NegativeInput;
    return no*2;
} 

pub fn main() !void {

    const num = 54;
    if (mightFail(num)) |result| {
        print("Result: {}\n", .{result});
    } else |err| {
        print("An exception occured: {}\n", .{err});
    }
}
