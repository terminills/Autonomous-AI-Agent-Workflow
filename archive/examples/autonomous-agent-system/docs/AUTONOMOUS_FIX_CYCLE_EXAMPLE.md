# Autonomous Fix Cycle Example

## AI_PHASE: DOCUMENTATION
## AI_STATUS: IMPLEMENTED
## AI_COMPLEXITY: LOW
## AI_NOTE: Example demonstrating the complete autonomous generate-compile-test-fix cycle
## AI_COMMIT: llm_integration_v2

---

## Overview

This document provides a complete example of how the autonomous fix cycle works in practice, running on Linux and cross-compiling to AROS.

## Example Scenario

### Initial State

**File**: `arch/m68k-amiga/graphics/test.c`

```c
// AI_PHASE: GRAPHICS_TEST
// AI_STATUS: IN_PROGRESS
// AI_COMPLEXITY: LOW
// AI_COMMIT: initial

#include <proto/graphics.h>

void test_graphics(void) {
    struct BitMap *bm = allocate_bitmap(640, 480);  // Error: undefined reference
    // ... rest of code
}
```

### Build Attempt #1

```bash
$ ./scripts/autonomous_build_agent.py --target amiga-m68k

[14:23:15] 🤔 Autonomous Build Agent initialized
[14:23:15] 🤔 Repository: /home/runner/work/AROS/AROS  
[14:23:15] 🤔 Build directory (out-of-tree): /home/runner/work/aros-build-amiga-m68k
[14:23:15] 🤔 Target platform: amiga-m68k (cross-compiling from Linux)
[14:23:15] ✅ LLM llama2 available: /usr/bin/llama2
[14:23:15] ✅ Model: /usr/share/llm/stories110M.bin
[14:23:15] ✅ Git repository initialized
```

### Error Detection

```
[14:25:32] ❌ Build failed with return code 2
[14:25:32] 🤔 Analyzing error...
[14:25:32] 🤔 Error 1: arch/m68k-amiga/graphics/test.c:6:23: error: implicit declaration of function 'allocate_bitmap'
```

### Autonomous Fix Cycle - Iteration 1

#### Step 1: Get Historical Context

```
[14:25:33] 🤔 Step 1: Getting git history context...
[14:25:33] 🤔 File history:
  Recent Changes:
    initial: Initial graphics test implementation
[14:25:33] 🤔 Line 6 last modified in: initial
```

#### Step 2: Generate Fix with LLM

```
[14:25:34] 🤖 Step 2: Consulting llama2 LLM for intelligent error analysis...
[14:25:34] 🤔 Building prompt with historical context...

Prompt sent to LLM:
"""
You are an expert C/C++ developer fixing build errors in the AROS operating system.

File: arch/m68k-amiga/graphics/test.c
Line: 6

Recent Changes:
  initial: Initial graphics test implementation

Line 6 last modified in: initial

Lines 1-16:
// AI_PHASE: GRAPHICS_TEST
// AI_STATUS: IN_PROGRESS
// AI_COMPLEXITY: LOW
// AI_COMMIT: initial

#include <proto/graphics.h>

void test_graphics(void) {
    struct BitMap *bm = allocate_bitmap(640, 480);  // Error: undefined reference
    // ... rest of code
}

Build Error:
arch/m68k-amiga/graphics/test.c:6:23: error: implicit declaration of function 'allocate_bitmap'

Generate the corrected code that fixes this error. Provide ONLY the code, no explanations.
Include necessary headers and declarations. Preserve existing functionality.

Fixed Code:
```c
"""

[14:25:37] 🤖 LLM Response received (350 tokens)
```

#### Step 3: Apply Generated Fix

```
[14:25:37] 💡 LLM Generated Fix:
// AI_PHASE: GRAPHICS_TEST
// AI_STATUS: IN_PROGRESS
// AI_COMPLEXITY: LOW

#include <proto/graphics.h>
#include <graphics/gfx.h>

void test_graphics(void) {
    struct BitMap *bm = AllocBitMap(640, 480, 8, BMF_CLEAR, NULL);
    // ... rest of code
}

[14:25:37] ✅ Applied fix to test.c
[14:25:37] 🤔 Modified lines: 1-10
```

#### Step 4: Cross-Compile Validation

```
[14:25:38] 🔧 Step 4: Cross-compiling to validate fix...
[14:25:38] 🔧 Running: make -C /home/runner/work/aros-build-amiga-m68k -k
[14:25:42] ✅ Compilation successful!
```

#### Step 5: Git Commit

```
[14:25:42] 🤔 Step 5: Committing successful fix...
[14:25:42] 🔧 Git: git add arch/m68k-amiga/graphics/test.c
[14:25:42] 🔧 Git: git commit -m "Auto-fix: implicit declaration of function 'allocate_bitmap'"
[14:25:43] ✅ Committed: a3b2c1d - Auto-fix: implicit declaration of function 'allocate_bitmap'
```

#### Step 6: Update AI_COMMIT Tags

```
[14:25:43] 🤔 Step 6: Updating AI_COMMIT tags in modified sections...
[14:25:43] ✅ Updated AI_COMMIT tags in test.c (lines 1-10)
[14:25:43] ✅ Automatic fix applied in 1 attempts
```

### Final State

**File**: `arch/m68k-amiga/graphics/test.c` (after fix)

```c
// AI_PHASE: GRAPHICS_TEST
// AI_STATUS: IN_PROGRESS
// AI_COMPLEXITY: LOW
// AI_COMMIT: a3b2c1d

#include <proto/graphics.h>
#include <graphics/gfx.h>

void test_graphics(void) {
    struct BitMap *bm = AllocBitMap(640, 480, 8, BMF_CLEAR, NULL);
    // ... rest of code
}
```

**Git Log**:

```bash
$ git log --oneline arch/m68k-amiga/graphics/test.c

a3b2c1d Auto-fix: implicit declaration of function 'allocate_bitmap'
initial Initial graphics test implementation
```

**Git Blame**:

```bash
$ git blame arch/m68k-amiga/graphics/test.c

initial   (Agent  2025-01-15) // AI_PHASE: GRAPHICS_TEST
initial   (Agent  2025-01-15) // AI_STATUS: IN_PROGRESS
initial   (Agent  2025-01-15) // AI_COMPLEXITY: LOW
a3b2c1d  (Agent  2025-01-15) // AI_COMMIT: a3b2c1d
initial   (Agent  2025-01-15)
initial   (Agent  2025-01-15) #include <proto/graphics.h>
a3b2c1d  (Agent  2025-01-15) #include <graphics/gfx.h>
initial   (Agent  2025-01-15)
initial   (Agent  2025-01-15) void test_graphics(void) {
a3b2c1d  (Agent  2025-01-15)     struct BitMap *bm = AllocBitMap(640, 480, 8, BMF_CLEAR, NULL);
```

### Subsequent Fix with Historical Context

If another error occurs in the same file later:

```
[14:30:15] 🤔 Getting git history context...
[14:30:15] 🤔 File history:
  Recent Changes:
    a3b2c1d: Auto-fix: implicit declaration of function 'allocate_bitmap'
    initial: Initial graphics test implementation
[14:30:15] 🤔 Line 10 last modified in: a3b2c1d
```

The LLM now knows:
- Line 10 was just fixed by commit `a3b2c1d`
- The fix changed `allocate_bitmap` to `AllocBitMap`
- This helps the LLM make consistent, context-aware fixes

## Multi-Attempt Example

### Scenario: Fix Requires Multiple Attempts

```
[14:35:20] 🤖 Attempting automatic fix with LLM...

==========================================================
Auto-Fix Attempt 1/5
==========================================================
File: arch/common/kernel/init.c
Error: undefined reference to `InitKernel'...

[14:35:25] 💡 Generated 234 characters of code
[14:35:25] ✅ Applied fix to init.c
[14:35:26] 🔧 Cross-compiling to validate...
[14:35:30] ⚠️  Compilation failed, analyzing...
[14:35:30] 🔄 Retrying with new error information...

==========================================================
Auto-Fix Attempt 2/5
==========================================================
File: arch/common/kernel/init.c  
Error: conflicting types for 'InitKernel'...

[14:35:35] 💡 Generated 189 characters of code
[14:35:35] ✅ Applied fix to init.c
[14:35:36] 🔧 Cross-compiling to validate...
[14:35:40] ✅ Compilation successful!
[14:35:40] ✅ Committed: b7d9e4f - Auto-fix: undefined reference to `InitKernel'
[14:35:40] ✅ Updated AI_COMMIT tags in init.c
[14:35:40] ✅ Automatic fix applied in 2 attempts
```

## Configuration Options

### Using Different LLM Engines

```bash
# Use llama2 (default, faster)
./scripts/autonomous_build_agent.py --llm-type llama2

# Use qwen3 (better for complex reasoning)
./scripts/autonomous_build_agent.py --llm-type qwen3

# Disable automatic fixing (suggestions only)
./scripts/autonomous_build_agent.py --llm-type none
```

### Custom Model Paths

```bash
# Specify custom model
./scripts/autonomous_build_agent.py \
    --llm-type llama2 \
    --llm-model /path/to/custom/model.bin \
    --llm-bin-dir /path/to/llm/binaries
```

## Benefits of Git-Based Historical Memory

### 1. Context-Aware Fixes

The LLM sees why code was written a certain way, leading to fixes that:
- Match existing code style and patterns
- Respect previous design decisions
- Avoid repeating failed approaches

### 2. Tracking Evolution

Each fix is committed with:
- Descriptive message (the error it fixed)
- AI_COMMIT tag (links code to git history)
- Full diff (shows exactly what changed)

### 3. Debugging Failed Fixes

If an automatic fix introduces a regression:

```bash
# See what the agent changed
git log --oneline --grep="Auto-fix"

# Revert a problematic fix
git revert a3b2c1d

# See the AI_COMMIT tag in source
grep -n "AI_COMMIT: a3b2c1d" arch/m68k-amiga/graphics/test.c
```

### 4. Learning from History

The agent can see:
- Which error patterns it has fixed before
- Which approaches worked vs. failed
- How the codebase evolved over time

This historical context makes each subsequent fix smarter.

## Performance Characteristics

### Single Fix Cycle

- **Context gathering**: ~1 second (git blame + log)
- **LLM inference**: ~3-5 seconds (depends on model)
- **Code application**: <1 second
- **Cross-compilation**: ~5-60 seconds (depends on file)
- **Git commit**: ~1 second
- **Total**: ~10-70 seconds per fix attempt

### Multi-Attempt Scenarios

- **Max attempts**: 5 (configurable)
- **Typical success**: 1-2 attempts
- **Complex fixes**: 3-4 attempts
- **Timeout**: After 5 failed attempts, falls back to suggestion-only mode

## Limitations and Future Work

### Current Limitations

- **No Runtime Testing**: Cross-compilation only validates syntax/linking, not runtime behavior
- **Simple Patching**: Current implementation does basic code replacement
- **File-Level Fixes**: Works best with single-file errors

### Future Enhancements

- More sophisticated code patching (AST-based)
- Multi-file fix coordination
- Learn from successful fix patterns
- Integration with QEMU for runtime validation
- Larger context windows for complex refactoring
- Parallel fixing of independent errors

## Summary

The autonomous fix cycle transforms the build agent from a passive analyzer to an active developer:

**Before**: 
```
Error detected → Suggestion printed → Developer fixes manually
```

**After**:
```
Error detected → LLM generates fix → Apply & test → Commit → Continue building
```

This enables true autonomous development where the agent can:
- Fix common errors automatically
- Learn from its history via git
- Iterate until compilation succeeds
- Track all changes with AI_COMMIT tags
- Provide historical context for future fixes

All while running on Linux and cross-compiling to AROS targets.
