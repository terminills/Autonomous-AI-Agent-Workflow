# ACD Standard v1.0 Implementation Guide

**Version:** 1.0  
**Date:** October 20, 2025  
**Status:** Active Implementation

---

## Purpose

This guide provides step-by-step instructions for implementing the Autonomous Continuous Development (ACD) Standard v1.0 in the AROS project, based on the successful evaluation of the breadcrumb system used in RadeonSI driver development.

See [ACD_STANDARD_EVALUATION.md](ACD_STANDARD_EVALUATION.md) for the complete evaluation and justification.

---

## Quick Start

### For Developers Adding ACD Metadata

1. **Include the header:**
   ```c
   #include <aros/ai_metadata.h>
   ```

2. **Add metadata before functions:**
   ```c
   // AI_PHASE: MEMORY_ALLOCATION
   // AI_STATUS: IMPLEMENTED
   // AI_COMPLEXITY: MEDIUM
   // AI_NOTE: Allocates GPU memory with alignment
   // AI_DEPENDENCIES: GPU_INIT, PCI_MAPPING
   static void* allocate_gpu_memory(size_t size) {
       // Implementation...
   }
   ```

3. **Validate your code:**
   ```bash
   python3 scripts/validate_acd.py path/to/your/file.c
   ```

### For Debugging with GDB

1. **Load the extension:**
   ```
   (gdb) source scripts/gdb_acd.py
   ```

2. **View context at breakpoint:**
   ```
   (gdb) info ACD
   ```

3. **Get suggestions:**
   ```
   (gdb) ACD-suggest
   ```

---

## Implementation Phases

### Phase 1: Foundation (Immediate - Week 1-2)

#### 1.1 Formalize the Standard

- [x] Create ACD Standard v1.0 specification (see issue description)
- [x] Create evaluation document (ACD_STANDARD_EVALUATION.md)
- [x] Create implementation guide (this document)
- [ ] Update project documentation to reference ACD Standard

**Deliverable:** Official ACD Standard v1.0 documentation

#### 1.2 Create Validation Tooling

- [x] Implement Python validator (`scripts/validate_acd.py`)
  - Required tag validation
  - Status/complexity value validation
  - Recommended tag warnings
  - JSON/CSV export
  
**Test the validator:**
```bash
# Run on RadeonSI driver
python3 scripts/validate_acd.py workbench/hidds/radeonsi/

# Export metadata
python3 scripts/validate_acd.py workbench/hidds/radeonsi/ \
    --export radeonsi_metadata.json

# Current results:
# - 95 files scanned
# - 95 ACD blocks found
# - 0 errors (no required tag violations)
# - 100 warnings (missing recommended tags)
```

**Deliverable:** Working validator with CI integration

#### 1.3 Create Debugging Tooling

- [x] Implement GDB extension (`scripts/gdb_acd.py`)
  - `info ACD` command
  - `ACD-suggest` command
  - Automatic context detection
  
**Test the GDB extension:**
```bash
# In GDB session:
(gdb) source scripts/gdb_acd.py
(gdb) break radeonsi_init.c:150
(gdb) run
(gdb) info ACD
(gdb) ACD-suggest
```

**Deliverable:** GDB extension ready for testing

### Phase 2: Code Enhancement (Weeks 3-6)

#### 2.1 Enhance RadeonSI Driver Metadata

Current state (from validation):
- ✅ AI_PHASE: 86 instances
- ✅ AI_STATUS: 104 instances  
- ✅ AI_NOTE: 104 instances
- ❌ AI_COMPLEXITY: 0 instances
- ❌ AI_DEPENDENCIES: 0 instances
- ❌ AI_COMMIT: 0 instances

**Action Items:**

1. **Add AI_COMPLEXITY to all functions:**
   - CRITICAL: MMU code, interrupt handlers, command submission
   - HIGH: Memory allocation, shader compilation
   - MEDIUM: Device detection, resource management
   - LOW: Getters, simple utilities

2. **Add AI_DEPENDENCIES to all phases:**
   Example:
   ```c
   // AI_PHASE: GPU_MMU_INTEGRATION
   // AI_STATUS: IMPLEMENTED
   // AI_COMPLEXITY: CRITICAL
   // AI_DEPENDENCIES: PCI_MEMORY_MAPPING, DEVICE_ENUMERATION, VRAM_ALLOCATION
   // AI_NOTE: GPU MMU setup for virtual memory management
   ```

3. **Add AI_COMMIT to track current state:**
   ```bash
   # For each file being updated:
   git log -1 --format=%h path/to/file.c
   # Add that hash as AI_COMMIT
   ```

**Deliverable:** RadeonSI driver with complete ACD metadata

#### 2.2 Add AI_COMMIT_HISTORY

When modifying existing code with AI_COMMIT:
1. Copy current AI_COMMIT value
2. Add to AI_COMMIT_HISTORY (comma-separated, newest first)
3. Update AI_COMMIT with new commit hash

Example:
```c
// Before modification:
// AI_COMMIT: a3f2d9c

// After modification:
// AI_COMMIT: b4e1f2a
// AI_COMMIT_HISTORY: a3f2d9c, e4f9a2d, c7b3e1a
```

**Deliverable:** Historical tracking enabled

#### 2.3 Update Documentation

Files to update:
- [ ] `AI_BREADCRUMB_GUIDE.md` → Align with ACD Standard v1.0
- [ ] `BREADCRUMB_IMPLEMENTATION_GUIDE.md` → Update examples
- [ ] `CONTRIBUTING.md` → Add ACD Standard requirements
- [ ] Update header file: `compiler/include/aros/ai_metadata.h`

**Deliverable:** Consistent documentation

### Phase 3: Infrastructure (Weeks 7-10)

#### 3.1 Create THS (Traceability & History) Infrastructure

**Directory Structure:**
```
/acd_artifacts/
  /fix_summaries/
    FIX_SUMMARY_GPU_MMU_INIT.md
    FIX_SUMMARY_INTERRUPT_ORDERING.md
    ...
  /trace_artifacts/
    trace_20251020_143000.json
    ...
  /validation_reports/
    validation_radeonsi_20251020.txt
    ...
```

**Fix Summary Template:**
```markdown
# Fix Summary: [Title]

## Issue Description
[What problem was encountered]

## Root Cause
- AI_PHASE: [Affected phases]
- AI_STATUS: [Status at time of failure]
- [Technical analysis]

## Solution
[Implementation details]

## Verification
[How the fix was tested]

## Related ACD Phases
- [PHASE_1] (AI_STATUS: [status])
- [PHASE_2] (AI_STATUS: [status])

## Commit References
- Main fix: [commit hash]
- Follow-up: [commit hash]
```

**Create first fix summaries:**
- Document 3-5 major issues solved during RadeonSI development
- Use git history to reconstruct the story
- Link to specific commits

**Deliverable:** Fix summary library started

#### 3.2 Create Automated Trace Artifact Generation

**Script: `scripts/generate_trace_artifact.py`**

Features:
- Capture diagnostic information
- Extract ACD context from source
- Link to relevant fix summaries
- Generate JSON trace artifact

**Deliverable:** Automated trace generation

#### 3.3 Integrate with CI/CD

**Add to CI pipeline:**
```yaml
# .github/workflows/acd-validation.yml
name: ACD Metadata Validation

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate ACD Metadata
        run: python3 scripts/validate_acd.py workbench/
      - name: Export Metadata
        run: |
          python3 scripts/validate_acd.py workbench/ \
            --export acd_metadata.json
      - name: Upload Artifact
        uses: actions/upload-artifact@v2
        with:
          name: acd-metadata
          path: acd_metadata.json
```

**Deliverable:** CI integration

### Phase 4: Advanced Features (Weeks 11-14)

#### 4.1 Compiler Error Enrichment

**Script: `scripts/enrich_compiler_errors.py`**

Intercepts compiler errors and adds ACD context:
```
Before:
  radeonsi_gpu.c:145: error: undeclared variable 'mmu_base'

After:
  radeonsi_gpu.c:145: error: undeclared variable 'mmu_base'
  
  ACD Context:
  - Phase: GPU_MMU_INTEGRATION
  - Status: PARTIAL (in development)
  - Complexity: CRITICAL
  - Note: GPU MMU setup for virtual memory management
  - Suggestion: Check if MMU initialization is complete
```

**Deliverable:** Enhanced compiler errors

#### 4.2 Dependency Validation

**Script: `scripts/validate_dependencies.py`**

Features:
- Parse all AI_DEPENDENCIES tags
- Build dependency graph
- Detect cycles
- Verify initialization order
- Generate visualization

**Example output:**
```
Dependency Graph Analysis
=========================
Phases: 84
Dependencies: 156
Cycles Detected: 0

Initialization Order:
  1. PCI_DEVICE_ENUMERATION
  2. PCI_MEMORY_MAPPING
  3. DEVICE_SUPPORT_DETECTION
  4. HARDWARE_INITIALIZATION
  5. GPU_MMU_INTEGRATION
  ...

Potential Issues:
  ⚠️  SHADER_COMPILATION depends on LLVM_INIT but no explicit ordering
```

**Deliverable:** Dependency validation tool

#### 4.3 Historical Analysis

**Script: `scripts/analyze_history.py`**

Features:
- Analyze AI_COMMIT_HISTORY across codebase
- Identify most-modified functions
- Track evolution of implementation approaches
- Generate "hot spots" report

**Deliverable:** Historical analysis tools

---

## Validation Criteria

### Phase 1 Complete When:
- [x] Validator runs without errors
- [x] GDB extension loads successfully
- [ ] Documentation updated
- [ ] Team trained on tools

### Phase 2 Complete When:
- [ ] All RadeonSI code has AI_COMPLEXITY
- [ ] All phases have AI_DEPENDENCIES
- [ ] Validation shows 0 errors, <10 warnings
- [ ] Sample functions have AI_COMMIT_HISTORY

### Phase 3 Complete When:
- [ ] 10+ fix summaries documented
- [ ] Trace artifact generation working
- [ ] CI pipeline validates on every PR
- [ ] `/acd_artifacts` structure established

### Phase 4 Complete When:
- [ ] Compiler error enrichment working
- [ ] Dependency graph validates
- [ ] Historical analysis generates insights
- [ ] Tools documented and tested

---

## Team Training

### For New Contributors

**Required Reading:**
1. ACD_STANDARD_EVALUATION.md (Why we use ACD)
2. This document (How to use ACD)
3. AI_BREADCRUMB_GUIDE.md (Existing context)

**Hands-on Training:**
1. Add ACD metadata to a simple function
2. Run validator and fix warnings
3. Use GDB extension to view context
4. Create a fix summary

**Estimated Time:** 2 hours

### For Existing Developers

**Migration Guide:**
1. Review existing breadcrumbs in your code
2. Add missing recommended tags:
   - AI_COMPLEXITY (assess your function)
   - AI_DEPENDENCIES (what must be ready first?)
   - AI_COMMIT (current git hash)
3. Run validator to check
4. Test GDB extension on your code

**Estimated Time:** 1 hour per major component

---

## Best Practices

### DO:
✅ Add ACD metadata to all non-trivial functions  
✅ Keep AI_NOTE concise but informative  
✅ Update AI_COMMIT when making significant changes  
✅ Maintain AI_COMMIT_HISTORY chronologically  
✅ Use consistent phase names across project  
✅ Run validator before committing  
✅ Document complex dependencies  

### DON'T:
❌ Add metadata to trivial getters/setters  
❌ Use vague phase names ("MISC", "UTILS")  
❌ Mark code as IMPLEMENTED if untested  
❌ Skip AI_COMPLEXITY for critical code  
❌ Forget to update AI_COMMIT_HISTORY  
❌ Make up commit hashes  

---

## FAQ

**Q: Do I need ACD metadata for every function?**  
A: No. Focus on:
- AI-generated or AI-modified code
- Complex logic
- Known problematic areas
- API boundaries
- Hardware interaction
- Critical paths

**Q: What if I don't know the complexity?**  
A: Start with MEDIUM and adjust based on:
- LOW: Simple, direct logic, few variables
- MEDIUM: Moderate state, some branching
- HIGH: Complex state, async operations
- CRITICAL: Hardware state, memory safety, race conditions

**Q: How do I find dependencies?**  
A: Ask yourself: "What must be initialized before this code can work?"
- Hardware: PCI mapping before MMIO access
- State: Init before use
- Resources: Allocation before operations

**Q: Should I update AI_COMMIT on every small change?**  
A: Only on "semantic" changes:
- Algorithm changes
- Bug fixes
- Feature additions
Not for:
- Formatting
- Comment updates
- Minor refactoring

**Q: What if validation shows warnings?**  
A: Warnings are acceptable if:
- Code is trivial (simple getter)
- Tags not applicable (no dependencies)
- Historical code (add tags gradually)

For new code, aim for zero warnings.

---

## Support

**Tools:**
- Validator: `python3 scripts/validate_acd.py --help`
- GDB: `(gdb) help info ACD`

**Documentation:**
- Specification: Issue description / to be formalized
- Evaluation: ACD_STANDARD_EVALUATION.md
- This guide: ACD_IMPLEMENTATION_GUIDE.md

**Questions:**
- Open an issue tagged with `acd-standard`
- Discuss in development meetings

---

## Success Metrics

Track these metrics quarterly:

1. **Metadata Coverage:**
   - Goal: >80% of driver code
   - Current: 9.5% (RadeonSI)

2. **Validation Status:**
   - Goal: 0 errors, <5% warnings
   - Current: 0 errors, 100 warnings

3. **Historical Tracking:**
   - Goal: All modified code has AI_COMMIT_HISTORY
   - Current: 0% (not yet implemented)

4. **Fix Summary Library:**
   - Goal: >50 documented fixes
   - Current: 0 (not yet implemented)

5. **Tool Usage:**
   - GDB extension: Track usage in debug sessions
   - Validator: Track in CI metrics

---

## Timeline Summary

```
Week 1-2:   Phase 1 - Foundation (Tools & Docs)        [DONE]
Week 3-6:   Phase 2 - Code Enhancement (Add tags)      [IN PROGRESS]
Week 7-10:  Phase 3 - Infrastructure (THS, CI)         [PLANNED]
Week 11-14: Phase 4 - Advanced Features (Analysis)     [PLANNED]
```

**Next Steps:**
1. Review this implementation plan
2. Assign phase ownership
3. Begin Phase 2: Add missing tags to RadeonSI
4. Continue tool development

---

*Last Updated: October 20, 2025*
