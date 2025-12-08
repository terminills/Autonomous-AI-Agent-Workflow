# Breadcrumb Implementation Guide

## Quick Start Guide for Contributors

This guide helps you add AI breadcrumbs to AROS source files to prepare the codebase for training a local LLaMA codegen model.

---

## What Are AI Breadcrumbs?

AI breadcrumbs are structured comment blocks placed above code sections that provide:
- **Context** about what the code does
- **Implementation details** and design decisions
- **Cross-references** to equivalent implementations (Linux, AmigaOS)
- **Error history** for learning from past mistakes
- **Training metadata** for AI model correlation

## Why Add Breadcrumbs?

1. **AI Training**: Provides structured data for training code generation models
2. **Documentation**: Self-documenting code with clear intent and history
3. **Code Review**: Easier understanding of complex implementations
4. **Maintenance**: Historical context for future modifications
5. **Pattern Recognition**: Helps identify reusable implementation patterns

---

## Tools Available

### 1. Generate Breadcrumbs
```bash
./scripts/generate_breadcrumbs.sh
```
Interactive tool to generate properly formatted breadcrumb blocks.

### 2. Validate Breadcrumbs
```bash
./scripts/validate_ai_breadcrumbs.sh [file|directory]
```
Validates breadcrumb formatting and completeness.

### 3. Analyze Coverage
```bash
./scripts/analyze_breadcrumb_coverage.sh -p
```
Shows breadcrumb coverage statistics and priority recommendations.

---

## How to Add Breadcrumbs

### Step 1: Include the Header

Add this to your includes:
```c
#include <aros/ai_metadata.h>
```

### Step 2: Choose a Template

Use one of three templates based on complexity:

#### Minimal Template (Simple Functions)
```c
// AI_PHASE: [PHASE_NAME]
// AI_STATUS: [STATUS]
// AI_NOTE: Brief description
```

#### Standard Template (Typical Functions)
```c
// AI_PHASE: [PHASE_NAME]
// AI_STATUS: [STATUS]
// AI_PATTERN: [PATTERN_NAME_V1]
// AI_STRATEGY: High-level approach
// AI_DETAILS: Detailed implementation description
// AI_NOTE: Additional context
// AROS_IMPL: AROS-specific details
// AI_VERSION: 1.0
```

#### Comprehensive Template (Critical/Complex Code)
```c
// AI_PHASE: [PHASE_NAME]
// AI_STATUS: [STATUS]
// AI_PATTERN: [PATTERN_NAME_V1]
// AI_STRATEGY: High-level strategy
// AI_DETAILS: Detailed implementation explanation
// FIX_REASON: [If fixing a bug, explain why]
// COMPILER_ERR: [Exact error message if applicable]
// RUNTIME_ERR: [Runtime error if applicable]
// REF_GITHUB_ISSUE: #[issue_number]
// AI_NOTE: Free-form context
// AMIGAOS_REF: [Reference to AmigaOS equivalent]
// LINUX_REF: [Reference to Linux equivalent]
// AROS_IMPL: AROS-specific implementation notes
// AI_VERSION: 1.0
// AI_CONTEXT: { "critical": true, "arch": "x86_64" }
```

### Step 3: Fill in the Values

#### Common AI_PHASE Values:
- `KERNEL_INIT` - Kernel initialization
- `MEMORY_MANAGEMENT` - Memory allocation/deallocation
- `TASK_MANAGEMENT` - Task/process operations
- `FILE_SYSTEM` - File system operations
- `GRAPHICS_RENDERING` - Graphics operations
- `GRAPHICS_PIPELINE` - Graphics pipeline
- `DEVICE_DRIVER` - Device driver code
- `SYNCHRONIZATION` - Locks, semaphores, etc.
- `EXCEPTION_HANDLING` - Trap/exception handling
- `NETWORK_STACK` - Network protocols
- `IPC` - Inter-process communication

#### AI_STATUS Values:
- `NOT_STARTED` - Planning stage
- `PARTIAL` - Incomplete implementation
- `IMPLEMENTED` - Complete implementation
- `FIXED` - Bug fix completed
- `NEEDS_REFACTOR` - Needs improvement

### Step 4: Place the Breadcrumb

Insert the breadcrumb block **immediately before** the function or code section:

```c
#include <aros/ai_metadata.h>
#include <exec/types.h>
#include <proto/exec.h>

// AI_PHASE: MEMORY_MANAGEMENT
// AI_STATUS: IMPLEMENTED
// AI_PATTERN: MEMORY_FREE_V1
// AI_STRATEGY: Memory deallocation with bounds checking
// AI_DETAILS: Returns memory block to system pool with validation
// AI_NOTE: Handles NULL pointers and zero sizes safely
// AMIGAOS_REF: exec.library FreeMem() - compatible API
// AROS_IMPL: Adds MungWall debugging support
// AI_VERSION: 1.0
void FreeMem(APTR memoryBlock, ULONG byteSize)
{
    // Implementation
}
```

### Step 5: Validate

Always validate your breadcrumbs:
```bash
./scripts/validate_ai_breadcrumbs.sh path/to/your/file.c
```

---

## Priority Areas for Breadcrumbs

Focus on these high-value areas first:

### Priority 1: Critical Core Systems
1. **rom/exec/** - Memory, tasks, interrupts
   - `allocmem.c`, `freemem.c` ✓
   - `addtask.c`, `removetask.c` ✓
   - `disable.c`, `enable.c`
   - `cause.c`, `forbid.c`, `permit.c`

2. **rom/kernel/** - Kernel core
   - `kernel_init.c` ✓
   - Memory management
   - Scheduler

3. **arch/*/kernel/** - Architecture-specific
   - `spininit.c` ✓
   - `cpu_traps.c` ✓
   - MMU code
   - Context switching

4. **rom/graphics/** - Graphics core
   - `bltbitmap.c` ✓
   - `setapen.c` ✓
   - Drawing primitives

### Priority 2: System Libraries
1. **rom/dos/** - DOS library
   - `open.c`, `close.c`, `read.c`, `write.c`
   - `lock.c` ✓
   - Directory operations

2. **rom/devs/** - Core devices
   - Timer, keyboard, console

3. **workbench/hidds/** - Hardware abstraction
   - Graphics HIDDs
   - Input HIDDs

---

## Best Practices

### DO:
✓ Add breadcrumbs to complex or critical functions  
✓ Include exact error messages in COMPILER_ERR/RUNTIME_ERR  
✓ Cross-reference Linux/AmigaOS equivalents when porting  
✓ Update AI_STATUS as code evolves  
✓ Use consistent AI_PATTERN names for similar code  
✓ Validate breadcrumbs before committing  

### DON'T:
✗ Add breadcrumbs to trivial getter/setter functions  
✗ Leave placeholder values unfilled  
✗ Copy breadcrumbs between unrelated functions  
✗ Forget to include `<aros/ai_metadata.h>`  
✗ Use breadcrumbs as general code comments  

---

## Examples

### Example 1: Memory Management (Implemented) ✓
```c
// AI_PHASE: MEMORY_MANAGEMENT
// AI_STATUS: IMPLEMENTED
// AI_PATTERN: MEMORY_FREE_V1
// AI_STRATEGY: Memory deallocation with bounds checking and mungwall debug support
// AI_DETAILS: Returns memory block to system pool with optional memory tracking validation
// AI_NOTE: Core memory management function - must handle NULL pointers and zero sizes safely
// AMIGAOS_REF: exec.library FreeMem() - compatible API with AROS extensions
// AROS_IMPL: Adds MungWall debugging support for memory corruption detection
// AI_VERSION: 1.0
// AI_CONTEXT: { "critical": true, "memory_safety": true, "debug_support": true }
AROS_LH2(void, FreeMem, ...)
```
See: `rom/exec/freemem.c`

### Example 2: Task Management (Implemented) ✓
```c
// AI_PHASE: TASK_MANAGEMENT
// AI_STATUS: IMPLEMENTED
// AI_PATTERN: TASK_CREATION_V1
// AI_STRATEGY: Legacy task creation interface with automatic field initialization
// AI_DETAILS: Adds task to system with priority-based scheduling and memory cleanup
// AI_NOTE: Deprecated in favor of NewAddTask() - alternative stack not properly initialized
// AMIGAOS_REF: exec.library AddTask() - maintains API compatibility
// AROS_IMPL: Limited stack support compared to NewAddTask(); no alternative stack initialization
// AI_VERSION: 1.0
// AI_CONTEXT: { "deprecated": true, "stack_limitations": true, "backward_compat": true }
AROS_LH3(APTR, AddTask, ...)
```
See: `rom/exec/addtask.c`

### Example 3: File System (Implemented) ✓
```c
// AI_PHASE: FILE_SYSTEM
// AI_STATUS: IMPLEMENTED
// AI_PATTERN: FILE_LOCK_V1
// AI_STRATEGY: Shared/exclusive locking mechanism with soft link resolution
// AI_DETAILS: Implements file/directory locking with nested soft link handling (max 16 levels)
// AI_NOTE: Critical for file system integrity - prevents deletion of locked files
// AMIGAOS_REF: dos.library Lock() - maintains compatibility with shared/exclusive semantics
// AROS_IMPL: Supports soft link resolution with cycle detection via nesting limit
// AI_VERSION: 1.0
// AI_CONTEXT: { "fs_integrity": true, "lock_semantics": "shared_exclusive", "softlink_support": true }
AROS_LH2(BPTR, Lock, ...)
```
See: `rom/dos/lock.c`

### Example 4: Graphics (Implemented) ✓
```c
// AI_PHASE: GRAPHICS_RENDERING
// AI_STATUS: IMPLEMENTED
// AI_PATTERN: RASTPORT_PEN_CONTROL_V1
// AI_STRATEGY: Primary pen configuration for drawing operations
// AI_DETAILS: Sets the primary (foreground) pen for subsequent drawing operations in RastPort
// AI_NOTE: Enables PenMode for the RastPort when called
// AMIGAOS_REF: graphics.library SetAPen() - fully compatible API
// AROS_IMPL: Standard implementation with PenMode activation
// AI_VERSION: 1.0
// AI_CONTEXT: { "pen_range": "0-255", "drawing_primitive": true, "penmode_control": true }
AROS_LH2(void, SetAPen, ...)
```
See: `rom/graphics/setapen.c`

### Example 5: Synchronization (Implemented) ✓
```c
// AI_PHASE: SYNCHRONIZATION
// AI_STATUS: IMPLEMENTED
// AI_PATTERN: SPINLOCK_INIT_V1
// AI_STRATEGY: Initialize spinlock to unlocked state with NULL owner
// AI_DETAILS: Sets up spinlock structure for use in multiprocessor synchronization
// AI_NOTE: Critical for SMP systems - must be called before spinlock usage
// LINUX_REF: include/linux/spinlock.h - spin_lock_init()
// AROS_IMPL: Lightweight initialization with owner tracking for debugging
// AI_VERSION: 1.0
// AI_CONTEXT: { "smp_safe": true, "critical": true, "arch": "all-pc" }
AROS_LH1(void, KrnSpinInit, ...)
```
See: `arch/all-pc/kernel/spininit.c`

### Example 6: Exception Handling (Implemented) ✓
```c
// AI_PHASE: EXCEPTION_HANDLING
// AI_STATUS: IMPLEMENTED
// AI_PATTERN: TRAP_MAPPING_V1
// AI_STRATEGY: Maps x86 CPU exceptions to AmigaOS trap numbers for exec exception handlers
// AI_DETAILS: Translates x86 trap numbers (0-18) to Amiga trap equivalents with context dumping
// AI_NOTE: Critical for fault handling - maps hardware exceptions to software-level handlers
// AMIGAOS_REF: m68k exception vectors (trap 0-15) - conceptual mapping to x86 exceptions
// LINUX_REF: arch/x86/kernel/traps.c - x86 exception handling model
// AROS_IMPL: Amiga-compatible trap numbering on x86 hardware with stack validation
// AI_VERSION: 1.0
// AI_CONTEXT: { "arch": "x86", "exception_mapping": true, "critical": true, "fault_handling": true }
```
See: `arch/all-pc/kernel/cpu_traps.c`

---

## References

- **Full Guide**: `AI_BREADCRUMB_GUIDE.md`
- **Quick Reference**: `AI_BREADCRUMB_QUICK_REFERENCE.md`
- **Header Spec**: `compiler/include/aros/ai_metadata.h`
- **Examples**: `examples/ai_breadcrumb_enhanced_demo.c`
- **Evaluation**: `BREADCRUMB_REPO_EVALUATION.md`

---

## Support

For questions or assistance:
1. Review existing breadcrumbs in the codebase
2. Use the generator tool for templates
3. Check validation output for errors
4. Consult the full breadcrumb guide
5. Ask the AROS development team

---

**Remember**: Good breadcrumbs make better AI models, which make better code suggestions, which help the AROS project grow!
