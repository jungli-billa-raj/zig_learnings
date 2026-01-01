🎯 Goal of the exercise

Write a function that:

allocates memory

does multiple steps

can fail in the middle

never leaks memory

This answers the real question:

“How do I stay safe when things fail halfway?”

🧪 Exercise: readAndDouble
What you’ll build

A function that:

allocates an array

fills it

intentionally fails on a condition

cleans up correctly

Step 1: Function signature (important)
fn readAndDouble(
    allocator: std.mem.Allocator,
    n: usize,
) ![]i32


Meaning:

caller chooses allocator

function owns memory until it returns

on success → caller frees

on error → function cleans up

Step 2: Required behavior

Inside the function:

allocate n integers

errdefer allocator.free(buf);

fill with i * 2

if n > 10, return an error

otherwise return the buffer

Define an error set:

const TooBigError = error{
    TooLarge,
};

Step 3: Caller (main)

In main:

call the function twice

once with n = 5 (success)

once with n = 20 (failure)

print results

do not leak memory
