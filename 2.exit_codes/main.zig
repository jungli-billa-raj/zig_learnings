// Try writing a program that:
//
// Reads command-line args
//
// If no args → exit with code 1
//
// If args exist → print them and exit 0

const std = @import("std");
const os = std.os;
const print = std.debug.print;

pub fn main() u8 {
    const args = os.argv;
    if (args.len>1) return 0 else return 1;
}
