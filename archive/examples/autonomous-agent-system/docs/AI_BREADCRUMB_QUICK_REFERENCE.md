# AI Breadcrumb Quick Reference

Quick reference for the most commonly used AI breadcrumb tags in AROS development.

## Essential Tags (Always Required)

```c
// AI_PHASE: KERNEL_INIT | GRAPHICS_PIPELINE | DEVICE_DRIVER | etc.
// AI_STATUS: NOT_STARTED | PARTIAL | IMPLEMENTED | FIXED | NEEDS_REFACTOR
```

## Development Strategy

```c
// AI_STRATEGY: High-level approach description
// AI_DETAILS: Detailed implementation explanation
// AI_NOTE: Context, design decisions, or next steps
```

## Error Tracking (Critical for Learning)

```c
// COMPILER_ERR: exact error: message from compiler [-Wflag]
// RUNTIME_ERR: Crash or failure description
// FIX_REASON: Why the error occurred and how it was fixed
```

## Pattern and Version Tracking

```c
// AI_PATTERN: DESCRIPTIVE_PATTERN_NAME_V1
// AI_VERSION: 0.1 | 0.2 | ... | 1.0
// AI_TRAIN_HASH: sha256_hash_for_training_correlation
```

## Historical Context

```c
// AI_HISTORY: Description of previous implementations and iterations
// AI_CHANGE: Specific modifications made in this version
// CORRECTION_REF: Reference to version that fixed an issue
```

## External References

```c
// LINUX_REF: path/to/linux/source.c - function or pattern reference
// AMIGAOS_REF: AmigaOS reference source or documentation
// AROS_IMPL: AROS-specific implementation notes
```

## Issue and PR Tracking

```c
// REF_GITHUB_ISSUE: #123
// REF_PR: PR-456
// REF_TROUBLE_TICKET: TT-20250101-COMPONENT
```

## Machine-Readable Context

```c
// AI_CONTEXT: { "key": "value", "arch": "x86_64", "critical": true }
```

## Complete Example (Kernel Init)

```c
// AI_PHASE: KERNEL_INIT
// AI_STATUS: FIXED
// AI_PATTERN: MEMORY_POOL_INIT_V2
// AI_STRATEGY: Robust memory pool allocation with alignment validation
// AI_DETAILS: Complete implementation with validation and error handling
// FIX_REASON: Added size bounds checking to prevent overflow
// COMPILER_ERR: None
// RUNTIME_ERR: None - passed all test scenarios
// AI_NOTE: Production-ready implementation
// AI_HISTORY: Evolution from v0.1 (stub) → v0.4 (alignment) → v1.0 (complete)
// AI_CHANGE: Added size validation and improved comments
// AI_TRAIN_HASH: b8f4d3e0c2d9f5a7c4e8b0d3f2a9c5e7b8d0f3a4c6e9b2d5f8a0c3e6b9d2f5a8
// AI_VERSION: 1.0
// REF_GITHUB_ISSUE: #15
// REF_PR: PR-18
// LINUX_REF: mm/slab.c - Production kernel memory allocation
// AROS_IMPL: Complete implementation for exec.library integration
// AI_CONTEXT: { "arch": "x86_64", "critical": true, "production_ready": true }
static APTR kernel_init_memory(ULONG size)
{
    /* Implementation */
}
```

## Complete Example (Graphics Shader)

```c
// AI_PHASE: GRAPHICS_PIPELINE
// AI_STATUS: PARTIAL
// AI_PATTERN: SHADER_COMPILE_BASIC_V1
// AI_STRATEGY: Shader compilation with proper LLVM API includes
// AI_DETAILS: Added proto/rocm.h include for LLVM function declarations
// COMPILER_ERR: error: too few arguments to function 'CompileShaderLLVM'
// FIX_REASON: Fixed implicit declaration by including rocm.library prototypes
// AI_NOTE: Corrected missing include, but API usage still needs work
// AI_HISTORY: v0.2 had implicit declaration; v0.3 includes proper headers
// AI_CHANGE: Added #include <proto/rocm.h> for LLVM functions
// AI_TRAIN_HASH: c1e4f7a2b5d8e0c3f6a9b2d5e8c1f4a7b0d3e6c9f2a5b8d1e4f7a0c3e6b9d2f5
// AI_VERSION: 0.3
// REF_GITHUB_ISSUE: #45
// LINUX_REF: src/gallium/drivers/radeonsi/si_shader.c:1523
// AROS_IMPL: Using rocm.library CompileShaderLLVM() function
// AI_CONTEXT: { "hw_target": "radeon_gcn", "compiler": "llvm" }
static BOOL shader_compile(struct ShaderContext *ctx, const char *source)
{
    /* Implementation */
}
```

## Minimal Example (Simple Function)

```c
// AI_PHASE: UTILITY
// AI_STATUS: IMPLEMENTED
// AI_NOTE: Basic helper function for string manipulation
static BOOL string_helper(const char *input)
{
    /* Implementation */
}
```

## Status Progression

Typical AI development progression:

```
NOT_STARTED → PARTIAL → PARTIAL → IMPLEMENTED → FIXED
    v0.1        v0.2       v0.3        v0.7       v1.0
    
    [Plan]   [Compile]  [Runtime]   [Features] [Production]
             [Error]    [Error]
```

## Common Patterns

### Pattern: Compiler Error Fix
```c
// Previous version:
// COMPILER_ERR: implicit declaration of function 'foo'

// Fixed version:
// FIX_REASON: Added missing #include <proto/library.h>
// AI_CHANGE: Included proper header for foo() declaration
```

### Pattern: Runtime Error Fix
```c
// Previous version:
// RUNTIME_ERR: Segmentation fault at offset +0x234

// Fixed version:
// FIX_REASON: NULL pointer dereference - added validation
// AI_CHANGE: Added NULL check before dereferencing pointer
```

### Pattern: Feature Addition
```c
// Previous version:
// AI_NOTE: Basic implementation, missing debug support

// Updated version:
// AI_CHANGE: Added debug flag support from ctx->flags
// AI_HISTORY: v0.7 had basic compilation; v1.0 adds debug info
```

## Best Practices

1. **Always include AI_PHASE and AI_STATUS** - These are required
2. **Document all errors** - COMPILER_ERR and RUNTIME_ERR are learning signals
3. **Explain fixes** - FIX_REASON helps AI understand solutions
4. **Track versions** - AI_VERSION shows progression
5. **Use patterns** - AI_PATTERN enables code reuse
6. **Add context** - AI_CONTEXT provides machine-readable metadata
7. **Link references** - LINUX_REF and AMIGAOS_REF guide implementation

## Validation

Always validate your breadcrumbs:

```bash
./scripts/validate_ai_breadcrumbs.sh path/to/your/file.c
```

## More Information

- Full guide: [AI_BREADCRUMB_GUIDE.md](AI_BREADCRUMB_GUIDE.md)
- Seed examples: [examples/](examples/)
- Metadata spec: [compiler/include/aros/ai_metadata.h](compiler/include/aros/ai_metadata.h)
- Autonomous AI: [AI_AUTONOMOUS_DEVELOPMENT.md](AI_AUTONOMOUS_DEVELOPMENT.md)
