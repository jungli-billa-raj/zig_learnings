Great choice. This is a **turning-point topic**.

### Exercise name

Let’s call it:

> **“Borrow, Don’t Own”**

Because that’s exactly what slices are about.

---

## What a slice really is (no fluff)

**A slice is just two things:**

1. a pointer to memory
2. a length

That’s it.
No ownership. No allocation. No freeing.

```zig
[]i32  // pointer + length
```

Think:

> “I can *look at* this memory, but I don’t own it.”

---

## Why Zig made slices this way (the insight)

In many languages:

* arrays copy
* references hide lifetimes
* ownership is implicit

Zig instead separates concerns:

* **Allocator** → who owns memory
* **Slice** → who can *use* memory

This separation is why your allocator code stayed clean.

---

## The key rule (burn this in)

> **Slices never free memory. Ever.**

Whoever **allocated** the memory is responsible for freeing it.
Slices just *borrow*.

---

## The exercise: “Borrow, Don’t Own”

### Step 1: Write a slice-only function

```zig
fn doubleView(data: []i32) void {
    for (data) |*v| {
        v.* *= 2;
    }
}
```

Notice:

* no allocator
* no errors
* no ownership logic

This function works on **any memory**.

---

### Step 2: Call it with stack memory

```zig
var arr = [_]i32{ 1, 2, 3 };
doubleView(arr[0..]);
```

* memory lives on the stack
* slice borrows it
* no allocation involved

---

### Step 3: Call it with heap memory

```zig
const buf = try allocator.alloc(i32, 3);
defer allocator.free(buf);

buf[0] = 1;
buf[1] = 2;
buf[2] = 3;

doubleView(buf);
```

Same function.
Different memory source.

---

### Step 4: (optional later) arena memory

Exact same call.

---

## The insight you’re meant to get

> **Slices make APIs allocator-agnostic.**

That’s why Zig code scales:

* from stack → heap → arena
* from small tools → compilers → kernels

Without rewriting logic.

---

## Why this matters more than it sounds

Before slices:

* functions had to know *how* memory was allocated
* APIs leaked ownership decisions

With slices:

* functions only care about *shape*
* callers decide *lifetime*

This is why Zig feels strict first — then freeing.

---

## One-sentence summary

> **Allocators decide lifetime.
> Slices decide access.**

Next, we can:

* deliberately violate slice ownership and see Zig stop us, or
* build a small pipeline of slice-based functions, or
* connect this to string handling (`[]u8` vs `[]const u8`).

Your call.

