Zig + OS Exercise #1 — “Meet the Process”

Goal: realize that a “program” is a running process with an address space.

Task

Write a Zig program that prints:

Address of a stack variable

Address of a heap allocation

Process ID

Parent process ID

This is OS-fundamental and 100% GitHub-worthy.

What you’ll learn

Stack vs heap (not theory—addresses)

That a process has an identity (PID)

That programs live in a process tree

Rules

Zig 0.15

No libraries beyond std

Linux

Bonus (optional)

Run it twice. Compare addresses.

Your first quiz (answer in plain English)

Why does the heap address usually look very different from the stack address?

Why does running the same program twice give different addresses?
