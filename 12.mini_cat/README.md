Perfect. Let’s do **mini-cat** properly — low-level, calm, no magic.

I’ll **not dump full code**. I’ll give you a **clear plan + skeleton**, then you fill gaps. That’s where the learning locks in.

---

## 🛠️ mini-cat — what you are building

A tiny program that:

```bash
zig run mini_cat.zig README.md
```

prints the file contents to **stdout**, just like `cat`.

No heap. No helpers. Just OS-style I/O.

---

## Mental model (important)

> You are building a **copy loop**:
> **file → buffer → stdout**

Nothing else.

---

## Step-by-step plan (follow in order)

### 1️⃣ Read command-line arguments

You already know this.

Goal:

* if no filename → print usage and exit with non-zero code
* else → take first argument as path

Hint:

```zig
const args = std.process.argsAlloc(allocator);
```

(You may free them later, but focus first.)

---

### 2️⃣ Open the file (read-only)

```zig
const file = try std.fs.cwd().openFile(
    path,
    .{}, // default = read_only
);
defer file.close();
```

Nothing fancy here.

---

### 3️⃣ Get stdout as a writer

```zig
var stdout = std.io.getStdOut().writer();
```

This gives you a **byte sink**.

---

### 4️⃣ Create a stack buffer

This is key — **no allocator**.

```zig
var buf: [4096]u8 = undefined;
```

This is your transfer buffer.

---

### 5️⃣ The copy loop (the heart of mini-cat)

Pseudo-logic:

```
loop:
    read into buffer
    if bytes_read == 0 → break (EOF)
    write those bytes to stdout
```

Zig version hint:

```zig
while (true) {
    const n = try file.read(&buf);
    if (n == 0) break;
    try stdout.writeAll(buf[0..n]);
}
```

That’s it. That loop *is* the program.

---

## 6️⃣ Exit cleanly

If you reach the end:

* program exits
* defers run
* OS is happy

---

## Skeleton (fill in the missing parts)

```zig
const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // 1. args
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("usage: mini-cat <file>\n", .{});
        return;
    }

    const path = args[1];

    // 2. open file
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    // 3. stdout
    var stdout = std.io.getStdOut().writer();

    // 4. buffer
    var buf: [4096]u8 = undefined;

    // 5. copy loop
    while (true) {
        const n = try file.read(&buf);
        if (n == 0) break;
        try stdout.writeAll(buf[0..n]);
    }
}
```

Try to **type it yourself**, don’t paste.

---

## What this exercise is secretly teaching you

Without new concepts, you just used:

* files
* slices
* stack memory
* error propagation
* ownership
* OS I/O semantics

This is *real systems programming*.

---

## When you’re done

Test:

```bash
zig run mini_cat.zig README.md
```

Then try:

```bash
zig run mini_cat.zig /etc/passwd
```

If that works — you’ve crossed a line.

---

### Next upgrades (later)

* support stdin (`cat` with no args)
* handle multiple files
* add `-n` (line numbers)
* add hex dump

But first: **get version 1 working**.

Paste your code or error output when ready — I’ll help you debug like a systems programmer, not a tutorial.

