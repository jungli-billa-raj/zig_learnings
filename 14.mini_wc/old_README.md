## 🔧 **mini-wc**

> Rebuild the core of the Unix `wc` tool.

This one is perfect *right now* because it builds directly on your streaming `mini-cat`, but forces you to **analyze bytes**, not just forward them.

---

## What `wc` really does (demystified)

At the OS level, `wc` does **one thing**:

> Read a stream of bytes and **count patterns** in it.

Specifically:

* **bytes** → count every byte read
* **lines** → count `'\n'`
* **words** → count transitions from whitespace → non-whitespace

No magic. No parsing libraries.

---

## Version 1 (the right starting point)

### Goal

```bash
zig run mini_wc.zig README.md
```

Output:

```
<lines> <words> <bytes> README.md
```

Don’t worry about flags yet.

---

## Rules (important)

### ✅ Use

* streaming I/O (same loop as mini-cat)
* stack buffer
* slices
* explicit counters

### ❌ Do NOT use

* `readToEndAlloc`
* regex
* string splitting
* heap allocation (for now)

This keeps it *honest* and *fast*.

---

## Mental model (this is the key insight)

You already know how to do this:

```zig
const n = try reader.read(buffer);
if (n == 0) break;
```

Now you’ll add:

```zig
for (buffer[0..n]) |byte| {
    // analyze byte
}
```

That’s the entire trick.

---

## Counters you need

```zig
var bytes: usize = 0;
var lines: usize = 0;
var words: usize = 0;
var in_word = false;
```

**One-liner meanings:**

* `bytes` → total bytes read
* `lines` → count `'\n'`
* `words` → count word starts
* `in_word` → state machine flag

---

## Word-count logic (this is the “thinking” part)

A word starts when:

* current byte is **not whitespace**
* previous byte **was whitespace**

In code terms:

* whitespace = `' '`, `'\n'`, `'\t'`
* anything else = part of a word

This is classic systems programming.

---

## Skeleton (fill the logic, not the structure)

```zig
const std = @import("std");

pub fn main() !void {
    var buffer: [4096]u8 = undefined;

    var bytes: usize = 0;
    var lines: usize = 0;
    var words: usize = 0;
    var in_word = false;

    const stdin = std.io.getStdIn().reader();

    while (true) {
        const n = try stdin.read(&buffer);
        if (n == 0) break;

        bytes += n;

        for (buffer[0..n]) |c| {
            if (c == '\n') lines += 1;

            const is_space = c == ' ' or c == '\n' or c == '\t';
            if (!is_space and !in_word) {
                words += 1;
                in_word = true;
            } else if (is_space) {
                in_word = false;
            }
        }
    }

    std.debug.print("{} {} {}\n", .{ lines, words, bytes });
}
```

**Type it, don’t paste.**
Then test with:

```bash
echo "hello world" | zig run mini_wc.zig
```

---

## What this tool teaches you (the real reason)

> **Streaming + state machines = most Unix tools**

You’ll learn:

* how text tools really work
* why slices are perfect
* how to reason about byte streams
* how *little* code is actually needed

This is the foundation of:

* `grep`
* `sed`
* `awk`
* parsers
* protocol decoders

---

## When you’re done, we can extend it

Natural upgrades (pick later):

* `-l`, `-w`, `-c` flags
* file arguments + stdin fallback
* UTF-8 awareness (hard, interesting)
* performance tuning (buffer size effects)

---


