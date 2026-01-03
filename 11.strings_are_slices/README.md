Perfect. **Strings in Zig are just slices.**
Once you see this, *everything* makes sense.

---

## The core truth (no drama)

> **A string in Zig is `[]u8` (or `[]const u8`).**

That’s it.
No string object. No hidden allocator. No magic.

---

## Two kinds you’ll see everywhere

### 1️⃣ `[]const u8` — read-only string

```zig
const s: []const u8 = "hello";
```

* string literal
* stored in read-only memory
* cannot be modified
* **most common**

Think: *borrowed, immutable text*

---

### 2️⃣ `[]u8` — mutable string buffer

```zig
var buf: []u8 = try allocator.alloc(u8, 10);
```

* heap / arena / stack
* writable
* you own it
* **must be freed**

Think: *string you’re building*

---

## Why Zig does this (the real insight)

Other languages mix **three things**:

* text data
* ownership
* allocation

Zig separates them:

| Concern    | Zig tool          |
| ---------- | ----------------- |
| text bytes | `[]u8`            |
| mutability | `const` vs `var`  |
| lifetime   | allocator / scope |

This is why strings feel “low-level” at first — but scale beautifully.

---

## Why `{s}` exists in `print`

```zig
std.debug.print("{s}\n", .{s});
```

`{s}` means:

> “Interpret this `[]u8` as UTF-8 bytes.”

Zig does **not** assume bytes are text unless you say so.

Compare:

```zig
{any}  // debug view
{s}    // string view
```

---

## Very important rule (memorize)

> **A string slice never owns memory.**

If you free the buffer:

```zig
allocator.free(buf);
```

Any slice pointing to it becomes **invalid**.

Zig won’t save you from this — ownership is your job.

---

## Building strings (where allocators matter)

### Example: build a string at runtime

```zig
var list = std.ArrayList(u8).init(allocator);
defer list.deinit();

try list.appendSlice("hello ");
try list.appendSlice("world");

const s: []const u8 = list.items;
```

Here:

* `ArrayList` owns memory
* `s` borrows it
* allocator controls lifetime

Same pattern as before. Nothing new.

---

## Why Zig has no `String` type

Because:

* it would hide allocation
* hide lifetime
* hide copying
* break embedded use
* break predictability

Zig says:

> “Text is bytes. Everything else is policy.”

---

## Mental model (lock this in)

* `[]const u8` → “I’m reading text”
* `[]u8` → “I’m writing text”
* allocator → “who owns the bytes”
* slice → “who can see them”

Exactly the same model you just learned with `[]i32`.

---

## Tiny exercise (do this mentally)

Answer these:

1. Can you return `"hello"` from a function without allocator? → **yes**
2. Can you return a formatted string without allocator? → **no**
3. Does `[]const u8` imply null-terminated? → **no**
4. Is a Zig string guaranteed UTF-8? → **no (by default)**

If these answers feel obvious now — you’re getting it.

---

## Where to go next (natural progression)

The *next* powerful step is:

### 👉 **String building + formatting with allocators**

(`std.fmt.allocPrint`, `ArrayList`, avoiding leaks)

This ties:

* strings
* slices
* allocators
* errors

together into real programs.

Say **“formatting”** when ready.

