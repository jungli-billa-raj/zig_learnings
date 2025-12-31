The purpose of this is:

To limit what errors a function is allowed to return 

fn mightFail() !T {}
  -> rn, this function can fail with any error in the Known Universe. 

and in C, 
return -1, better luck guessing what went wrong. 

Zig's solution: Error Sets => These are basically 'enums' of allowed failures. 
const MyError = enum{
  FileNotFound, 
  EOF, 
}


Your task (do this)
1️⃣ Define an error set
const CalcError = error{
    NegativeInput,
};

2️⃣ Use it in the function
fn mightFail(x: i32) CalcError!i32 {
    if (x < 0) return CalcError.NegativeInput;
    return x * 2;
}

3️⃣ Handle it in main using if |value| else |err|

Print:

result on success

error name on failure
