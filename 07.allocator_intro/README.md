The story of memory (why allocators exist)

Era 1: C (the wild west)
int *p = malloc(100);
free(p);

Problems (one-liners):
forget free → memory leak
double free → crash
free wrong pointer → chaos
no idea who owns memory

The compiler helps zero percent.

---------------------------------------------------

Era 2: C++ / Rust (RAII)
std::vector<int> v;

Idea (one-liner):
Memory is freed automatically when an object dies.

Good, but:
hidden allocations
hidden deallocations
hard to control where memory comes from
embedded / OS code hates this

---------------------------------------------------

Zig’s philosophy (very important)

One-liner:

Memory allocation is not magic, it’s a resource like a file or mutex.

So Zig asks:

“Who gives you memory?”
“Who takes it back?”
“When?”

---------------------------------------------------

### An allocator is just an object that knows how to give and take memory. ### BELIEVE IT !!!  


Mental model (lock this in)
Allocator → “Where memory comes from”

defer → “Always clean up”
errdefer → “Clean up only on failure”
Ownership → Whoever didn’t free it yet
