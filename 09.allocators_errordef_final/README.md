Perfect. This is the **payoff exercise**.
If you understand this, allocators + `errdefer` are basically *done*.

---

## 🎯 What you’re about to build

A function that:

1. allocates **buffer A**
2. allocates **buffer B**
3. fails **after A but before B is returned**
4. leaks **nothing**

We’ll then reason *exactly* which cleanup runs.

---

## Step 1: Error set

We’ll be honest and include allocator failure.

```zig
const TwoBufError = error{
    TooLarge,
    OutOfMemory,
};
```

---

## Step 2: Function with **two allocations**

```zig
fn allocTwo(
    allocator: std.mem.Allocator,
    n: usize,
) TwoBufError!struct {
    a: []i32,
    b: []i32,
} {
    // ---- allocate A ----
    const a = try allocator.alloc(i32, n);
    errdefer allocator.free(a);

    // fail in between (intentional)
    if (n > 10) return TwoBufError.TooLarge;

    // ---- allocate B ----
    const b = try allocator.alloc(i32, n);
    errdefer allocator.free(b);

    // fill buffers
    for (a, 0..) |*v, i| v.* = @intCast(i);
    for (b, 0..) |*v, i| v.* = @intCast(i * 2);

    return .{ .a = a, .b = b };
}
```

Read this **slowly**. Nothing fancy is happening.

---

## Step 3: Caller (`main`)

```zig
pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // ---- success case ----
    if (allocTwo(allocator, 5)) |res| {
        defer allocator.free(res.a);
        defer allocator.free(res.b);

        std.debug.print("A: {any}\n", .{res.a});
        std.debug.print("B: {any}\n", .{res.b});
    } else |err| {
        std.debug.print("Error: {}\n", .{err});
    }

    // ---- failure case ----
    if (allocTwo(allocator, 20)) |res| {
        defer allocator.free(res.a);
        defer allocator.free(res.b);
    } else |err| {
        std.debug.print("Expected failure: {}\n", .{err});
    }
}
```

---

## 🧠 NOW THE IMPORTANT PART: what runs, exactly?

### Case 1: `n = 5` (success)

Execution order inside `allocTwo`:

1. allocate `a`
2. register `errdefer free(a)`
3. skip failure
4. allocate `b`
5. register `errdefer free(b)`
6. return success

What happens next?

* function returns → **no error**
* **both `errdefer`s are cancelled**
* caller owns `a` and `b`
* caller frees them with `defer`

✅ no leaks
✅ no double free

---

### Case 2: `n = 20` (failure)

Execution order:

1. allocate `a`
2. register `errdefer free(a)`
3. `if (n > 10)` → return error
4. stack unwinds

What runs?

* `errdefer free(a)` ✅
* allocation of `b` never happened ❌
* `errdefer free(b)` was never registered ❌

Result:

* **only `a` is freed**
* nothing else touches memory

✅ no leaks
✅ no guessing
✅ no cleanup code branches

---

## 🔑 The rule you just proved to yourself

> **`errdefer` cleans up exactly what was successfully acquired — no more, no less.**

This is something:

* exceptions struggle with
* RAII hides
* garbage collectors avoid

Zig makes it **mechanical and visible**.

---

## Why this is such a big deal

You can now safely write code that:

* allocates in stages
* fails anywhere
* never leaks
* never double-frees

This is *hard* in most languages.

---

## Pause and reflect (seriously)

If this makes sense to you now, then:

* allocators ✔
* ownership ✔
* error paths ✔
* cleanup ✔

You’ve crossed a **major Zig milestone**.

---

### Next possible directions (your choice)

1. Use an **arena allocator** with this same function
2. Write a bug *without* `errdefer` and watch it leak
3. Learn how slices + allocators work together in APIs
4. Move into **files + allocators** (real OS resources)

Just tell me which one you want.

