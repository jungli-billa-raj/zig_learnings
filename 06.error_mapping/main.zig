const print = @import("std").debug.print;

const InputError = error {
    Negative,
};
const AppError = error {
    BadInput,
};

fn mightFail(no: i32) InputError!i32 {
    if (no<0) return InputError.Negative;
    return no*2;
}

fn run(no: i32) AppError!i32 {
    return mightFail(no) catch |err| switch (err) {
        InputError.Negative => AppError.BadInput,
    };
}

pub fn main() AppError!void {
    const num =-32;

    if (run(num)) |result|{
        print("Result: {}\n", .{result});
    } else |err| {
        print("Error: {}\n", .{err});
    }
}
