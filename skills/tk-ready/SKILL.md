---
name: tk-ready
description: Show tickets ready to work on (no unresolved dependencies)
---

Run `tk ready` and display the results.

Ready tickets are open or in-progress tickets with all dependencies resolved. These are the tickets you can work on right now.

## Usage

```bash
tk ready              # Show all ready tickets
tk ready -T feature   # Ready features only
tk ready -T bug       # Ready bugs only
```
