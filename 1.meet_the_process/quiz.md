Mini-quiz (short answers)

1️⃣ Why can stack arrays not have runtime-determined sizes?
-> Because stack then will be unpredictable. For runtime-determined sizes, heaps are preferred. In zig, for heap-allocations, allocators must be explicitly provided.
2️⃣ Why is read-only memory usually marked non-writable by the OS?
-> Because, they are often constants throughout the lifetime of the app. However, in the program, if the value is changed, then they are not marked non-writable. 
3️⃣ Which memory region is shared between all threads of a process?
-> read-only memory.


Good answers overall—but this is where we **sharpen them into systems-grade understanding**. I’ll correct *precisely*, not broadly.

---

## 1️⃣ Stack arrays & runtime size

Your answer is **mostly right**, but let’s make it exact.

> ❌ “Stack would be unpredictable” (vague)
> ✅ Correct reason:

**The stack pointer must move in fixed, statically-known increments.**

* Stack allocation is just pointer arithmetic
* The compiler must know the size **at compile time**
* Otherwise it can’t generate correct prologue/epilogue code

Heaps exist **because** size is known only at runtime.
Zig enforces this explicitly → good language design.

✔️ You’re correct that Zig *forces* allocator awareness.

---

## 2️⃣ Read-only memory (important correction)

> ❌ “If the value is changed, then they are not marked non-writable”

This is **false** (and dangerous thinking).

### Correct model:

* Read-only memory is **always** non-writable
* Attempting to write → **segmentation fault**
* The OS enforces this via page permissions

If something *can* be changed, it **never goes into rodata** in the first place.

This protection enables:

* Sharing pages between processes
* Security (W^X, exploit prevention)

---

## 3️⃣ Shared between threads — partial credit

> ❌ Only “read-only memory”

### Correct answer:

**Everything except stacks is shared between threads.**

Shared:

* Heap
* Read-only memory
* Global/static data
* File descriptors
* Address space

Not shared:

* Stack (each thread has its own)

This is why **data races exist**.

---

## Verdict so far

You’re thinking like a **programmer**, not memorizing. Good.

---
