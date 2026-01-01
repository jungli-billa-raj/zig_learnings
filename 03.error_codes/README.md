exit_codes => for system to understand
error_codes => for the programemr to understand

in C , you would do something like:

if (ptr == NULL) return -1;

The problemo is that functions define their own convention. Which is not good. ofc. 

Zig's solution, separate the two. 

pub fn readFile() !void{
  return error.FileNotFound; // Errors are a part of the function's type.
}
here, 
error is a Typed Failure
!T -> suggests that the functions may fail 
try -> is used to propagate errors upward. 


Mental model (keep this)
Inside program → errors
At program exit → exit codes

Errors are thoughts, exit codes are signals.
