# **Agentic AI Workflow for AROS Development**
## **AGENTIC_AI_WORKFLOW.md**
### *Complete Guide with Build Log Integration, Autonomous AI Phases, and Project-Scoped Build Capture*

---

## **Table of Contents**

1. [Overview](#overview)  
2. [Core Principles](#core-principles)  
3. [Phase 1: Discovery & Analysis](#phase-1-discovery--analysis)  
4. [Phase 2: The Master Plan](#phase-2-the-master-plan)  
5. [Phase 3: Task Segmentation](#phase-3-task-segmentation)  
6. [Phase 4: The Implementation Loop](#phase-4-the-implementation-loop)  
7. [Phase 5: Completion](#phase-5-completion)  
8. [Build Log Workflow](#build-log-workflow)  
9. [GitHub Issue Templates](#github-issue-templates)  
10. [Helper Scripts](#helper-scripts)  
11. [Appendices](#appendices)  

---

# **Overview**

This guide defines a structured, repeatable workflow for using AI agents—GitHub Copilot or any LLM—as an autonomous development assistant for AROS and non-AROS projects. The system is designed for **non-coders** and **coders alike**, enabling an AI-driven "zero-code start" where the agent:

- Analyzes the environment  
- Documents its findings  
- Plans the implementation  
- Writes the code  
- Iterates based on build logs  
- Tracks progress with metadata  
- Follows strict directory and documentation rules  

The human operator performs only:

- Triggering workflow phases  
- Running builds  
- Uploading logs (automated)  
- Reporting runtime/UI issues  

Everything else is delegated to the agent.

This workflow is **project-agnostic**, but uses AROS as a model environment due to its unique APIs, build system, and porting patterns.

---

# **Core Principles**

## **1. Read First — Code Later**
The AI must not jump into code generation.  
It must first:

- Explore the repo  
- Read the headers  
- Analyze contrib ports  
- Identify subsystem patterns  
- Map libraries and APIs  

This prevents hallucinated Linux-style solutions.

**Example workflow:**
```bash
# Agent first explores structure
find arch/m68k-amiga -name "*.h" | head -n 20
cat rom/exec/exec_intern.h
git log --oneline contrib/network/stacks/AROSTCP
```

---

## **2. Persistent Context via Metadata Blocks**
Every AI-generated file, issue, or analysis uses a standardized **metadata block** containing:

- Current phase  
- Status  
- Complexity  
- Dependencies  
- Commit hashes  
- API mappings  
- Strategy notes  
- Error/fix history  

This allows the AI to maintain context across multiple replies, days, or rebuilds.

**Metadata Format (Basic):**
```markdown
## AI_PHASE: DISCOVERY
## AI_STATUS: IN_PROGRESS
## AI_PROJECT: <project-name>
## AI_COMPLEXITY: HIGH
## AI_DEPENDENCIES: exec.library, dos.library
## AI_COMMIT: initial_exploration
## AI_API_MAPPING: POSIX->AROS
## AI_STRATEGY: Use AROS native APIs instead of POSIX wrappers
## AI_ERROR_HISTORY: None yet
## AI_FIX_HISTORY: None yet
## AI_HISTORY: socket_v1 [a3b2c1d] → socket_v2 [e4f5g6h] → socket_v3 [i7j8k9l]
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Analyzing AmigaOS 3.1 compatibility patterns
```

**Metadata Format (With Collaboration - ACD v1.1.0):**
```markdown
## AI_PHASE: IMPLEMENTATION
## AI_STATUS: IN_PROGRESS
## AI_PROJECT: network-stack
## AI_COMPLEXITY: HIGH
## AI_DEPENDENCIES: INIT_HOOKS, ERROR_HANDLING
## AI_COMMIT: e4f5g6h
## AI_COMMIT_HISTORY: a3b2c1d
## AI_HISTORY: socket_v1 [a3b2c1d] → socket_v2 [e4f5g6h]
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Porting POSIX socket to AROS bsdsocket.library

# Agent Collaboration (ACD v1.1.0)
## AI_ASSIGNED_TO: copilot-agent-1
## AI_ASSIGNED_BY: orchestrator
## AI_ASSIGNED_AT: 2025-12-08T16:30:00Z
## AI_ASSIGNMENT_REASON: Specialization in network stack porting
## AI_CONFIDENCE: UNCERTAIN
## AI_REQUEST: REQUEST_REVIEW
## AI_STATE: READY
## AI_QUEUE_PRIORITY: HIGH
## AI_QUEUE_STATUS: IN_PROGRESS
## AI_STARTED: 2025-12-08T16:31:00Z
## AI_ESTIMATED_COMPLETION: 2025-12-08T18:00:00Z
```

**Metadata Format (With Handoff - ACD v1.1.0):**
```markdown
## AI_PHASE: IMPLEMENTATION
## AI_STATUS: BLOCKED
## AI_PROJECT: network-stack
## AI_COMPLEXITY: CRITICAL
## AI_ASSIGNED_TO: copilot-agent-1
## AI_PREVIOUS_ASSIGNEE: local-agent-42
## AI_ASSIGNMENT_HISTORY: local-agent-42, copilot-agent-1

# Handoff Request
## AI_HANDOFF_REQUESTED: true
## AI_HANDOFF_REASON: Requires specialized knowledge of AROS kernel internals
## AI_HANDOFF_TO: aros-kernel-specialist
## AI_HANDOFF_TYPE: SPECIALIZATION
## AI_HANDOFF_STATUS: REQUESTED
## AI_HANDOFF_NOTES: Socket initialization causing kernel panic - needs deep AROS expertise
## AI_REQUIRED_CAPABILITIES: aros-kernel, memory-management, debugging
## AI_SKILL_LEVEL_REQUIRED: SPECIALIST
```

**Metadata Format (Dual-Agent Exchange - ACD v1.1.0):**
```markdown
## AI_PHASE: IMPLEMENTATION
## AI_STATUS: IN_PROGRESS
## AI_PROJECT: network-stack
## AI_EXCHANGE_ID: socket-impl-2025-12-08
## AI_ROUND: 2

# Generator Agent Output
## AI_ASSIGNED_TO: generator-agent
## AI_CONFIDENCE: CONFIDENT
## AI_STATE: READY

# Reviewer Agent Feedback
## AI_VALIDATION: ANALYZED
## AI_ISSUES: Missing error handling for NULL socket, Memory leak in error path
## AI_SUGGESTIONS: Add NULL check before CloseSocket(), Free allocated memory in all error paths
## AI_VALIDATION_RESULT: NEEDS_MORE_WORK

# Refinement
## AI_REFINEMENT: IN_PROGRESS
## AI_CHANGES: Added NULL checks, Fixed memory leak
## AI_RATIONALE: Prevents crashes and ensures proper cleanup
```

**Key fields:**
- `AI_PROJECT`: Identifies which project (e.g., "electron-v8", "radeonsi-driver")
- `AI_WORKFLOW`: Always set to "AGENTIC_AI_WORKFLOW"
- `AI_HISTORY`: Historical chain of API porting iterations with commit hashes (see Appendix E)
- **ACD v1.1.0 Fields**: Enable multi-agent collaboration, handoffs, and distributed coordination

---

## **3. Strict Documentation Locations**
All AI-written documents must be saved in the **per-project structure** under `docs/`:

```
docs/<project-name>/
```

**Per-project structure:**
```
docs/
├── AGENTIC_AI_WORKFLOW.md              # This file
├── README.md                            # Documentation index
├── <project-name>/                      # Your project
│   ├── README.md                        # Project overview
│   ├── specs/                           # Specifications
│   │   ├── ARCHITECTURE.md
│   │   ├── API_SPEC.md
│   │   └── REQUIREMENTS.md
│   ├── docs/                            # Implementation docs
│   │   ├── IMPLEMENTATION_GUIDE.md
│   │   ├── USER_GUIDE.md
│   │   └── STATUS_SUMMARY.md
│   └── phases/                          # Active agent sessions
│       ├── phase1/                      # Discovery
│       │   └── discovery_YYYYMMDD.md
│       ├── phase2/                      # Master Plan
│       │   └── plan_YYYYMMDD.md
│       ├── phase3/                      # Task Segmentation
│       │   └── tasks_YYYYMMDD.md
│       ├── phase4/                      # Implementation
│       │   ├── iteration_001.md
│       │   ├── iteration_002.md
│       │   └── build_logs/
│       │       ├── build_YYYYMMDD_HHmmss.log
│       │       └── error_analysis_001.md
│       └── phase5/                      # Completion
│           └── completion_YYYYMMDD.md
└── archive/                             # Archived projects
    └── <project-name>/
        └── session_YYYYMMDD/
```

**Rules:**
- Never place AI documents in the repository root
- Never place documents in source code folders
- Always use the per-project structure: `docs/<project-name>/`
- Each project maintains its own phase directories
- See `docs/README.md` for list of existing projects

---

# **Phase 1: Discovery & Analysis**

## **Objective**
The agent must understand the codebase before making any changes.

## **Steps**

### **1.1 Repository Structure Exploration**
```bash
# Explore top-level directories
ls -la

# Identify key subsystems
find . -type d -maxdepth 2

# Check build system
cat mmakefile
cat configure.in
```

**Document findings in:** `docs/phase1/discovery_YYYYMMDD.md`

### **1.2 Subsystem Identification**
The agent must map:
- **arch/**: Architecture-specific code
- **rom/**: ROM modules (exec, dos, intuition, etc.)
- **workbench/**: Applications and libraries
- **contrib/**: Third-party ports
- **external/**: External dependencies
- **compiler/**: AROS compiler wrappers

**Document subsystems in:** `docs/phase1/analysis_YYYYMMDD.md`

### **1.3 Header Analysis**
The agent must read key headers to understand:
- System structures
- Function prototypes
- Macro definitions
- API conventions

```bash
# Example: Explore exec.library
cat rom/exec/exec_intern.h
cat rom/exec/include/exec/tasks.h

# Example: Explore dos.library
cat rom/dos/dos_intern.h
cat rom/dos/include/dos/dosextens.h
```

### **1.4 Pattern Recognition**
The agent must identify:
- Naming conventions (e.g., `AROS_LH`, `AROS_LIBFUNC`)
- Memory management patterns (e.g., `AllocMem`, `FreeMem`)
- API wrapper patterns (e.g., POSIX → AROS translations)
- Build system patterns (e.g., `mmakefile` targets)

**Document patterns in:** `docs/phase1/patterns_YYYYMMDD.md`

### **1.5 Existing Port Analysis**
If porting software, the agent must analyze similar ports:

```bash
# Example: Study how other network stacks are ported
ls contrib/network/stacks/
cat contrib/network/stacks/AROSTCP/README
git log contrib/network/stacks/AROSTCP
```

**Document port analysis in:** `docs/phase1/port_analysis_YYYYMMDD.md`

### **1.6 Discovery Report**
The agent must generate a comprehensive discovery report including:
- Repository structure summary
- Subsystem map
- Key API discoveries
- Pattern catalog
- Similar port findings
- Potential challenges identified

**Save report as:** `docs/phase1/discovery_report_YYYYMMDD.md`

**Template:**
```markdown
## AI_PHASE: DISCOVERY
## AI_STATUS: COMPLETE
## AI_COMPLEXITY: HIGH
## AI_NOTE: Initial codebase analysis complete

# Discovery Report

## Date
[YYYY-MM-DD]

## Repository Structure
[Summary of directories and their purposes]

## Key Subsystems Identified
1. **exec.library**: [Description]
2. **dos.library**: [Description]
...

## API Conventions Discovered
- [Convention 1]
- [Convention 2]
...

## Build System Analysis
[How the build system works]

## Similar Ports Found
[List of similar projects and their approaches]

## Challenges Identified
1. [Challenge 1]: [Description and potential solution]
2. [Challenge 2]: [Description and potential solution]
...

## Next Steps
[Transition to Phase 2]
```

---

# **Phase 2: The Master Plan**

## **Objective**
Create a comprehensive implementation plan based on Phase 1 discoveries.

## **Steps**

### **2.1 Goal Definition**
Clearly state what needs to be accomplished.

**Example:**
```markdown
## Goal
Port libcurl to AROS, enabling HTTP/HTTPS networking for AROS applications.

## Success Criteria
1. libcurl compiles without errors
2. Basic HTTP GET requests work
3. HTTPS support (if OpenSSL available)
4. Integration with AROS networking stack
5. Example programs demonstrate functionality
```

### **2.2 Architecture Design**
Design the high-level architecture:
- Component diagram
- Data flow
- API interfaces
- Dependencies
- Integration points

**Document in:** `docs/phase2/architecture_YYYYMMDD.md`

### **2.3 API Mapping Strategy**
Map external APIs to AROS equivalents:

**Example:**
```markdown
## API Mappings

### POSIX → AROS
| POSIX Function | AROS Equivalent | Notes |
|----------------|-----------------|-------|
| socket()       | CloseSocket()   | Use bsdsocket.library |
| open()         | Open()          | Use dos.library |
| malloc()       | AllocMem()      | Use exec.library |
| pthread_*      | CreateTask()    | Use exec.library tasks |
```

### **2.4 Dependency Analysis**
List all dependencies and how to satisfy them:

```markdown
## Dependencies

1. **OpenSSL** (optional)
   - Status: Available in contrib/
   - Integration: Link against arosc SSL wrappers

2. **zlib**
   - Status: Available in compiler/
   - Integration: Use AROS zlib

3. **bsdsocket.library**
   - Status: Core AROS library
   - Integration: Use standard includes
```

### **2.5 Build Strategy**
Define how the software will be built:

```markdown
## Build Strategy

1. **Out-of-tree build**
   - Build directory: `build-linux-x86_64/`
   - Source directory: Unchanged

2. **Configure flags**
   ```bash
   ./configure --host=x86_64-aros \
               --disable-shared \
               --enable-static \
               --with-ssl=/path/to/aros/ssl
   ```

3. **Makefile integration**
   - Create `mmakefile` wrapper
   - Add to contrib/network/curl/
```

### **2.6 Testing Strategy**
Define how the port will be tested:

```markdown
## Testing Strategy

1. **Unit tests**
   - Port libcurl's test suite
   - Run tests on Linux-hosted AROS

2. **Integration tests**
   - HTTP GET test
   - HTTPS GET test
   - POST test
   - Cookie handling test

3. **Real-world validation**
   - Port wget using libcurl
   - Test with actual websites
```

### **2.7 Master Plan Document**
Generate the complete master plan.

**Save as:** `docs/phase2/master_plan_YYYYMMDD.md`

**Template:**
```markdown
## AI_PHASE: MASTER_PLAN
## AI_STATUS: COMPLETE
## AI_COMPLEXITY: HIGH
## AI_DEPENDENCIES: [List dependencies]
## AI_STRATEGY: [High-level strategy]
## AI_NOTE: Complete implementation plan

# Master Plan: [Project Name]

## Date
[YYYY-MM-DD]

## Goal
[Clear goal statement]

## Architecture
[Architecture diagram and description]

## API Mapping
[POSIX → AROS mappings]

## Dependencies
[List of dependencies and how to satisfy them]

## Build Strategy
[How to build the software]

## Testing Strategy
[How to validate the port]

## Implementation Phases
[Breakdown of work into phases]

## Risk Assessment
1. [Risk 1]: [Mitigation]
2. [Risk 2]: [Mitigation]

## Timeline Estimate
[Rough estimate of effort required]

## Next Steps
[Transition to Phase 3]
```

---

# **Phase 3: Task Segmentation**

## **Objective**
Break down the master plan into discrete, implementable tasks.

## **Steps**

### **3.1 Task Breakdown**
Divide work into small, manageable tasks:

**Example:**
```markdown
## Task List

### Preparation Tasks
- [ ] Task 1.1: Set up build environment
- [ ] Task 1.2: Create directory structure
- [ ] Task 1.3: Import libcurl sources

### Configuration Tasks
- [ ] Task 2.1: Create configure script wrapper
- [ ] Task 2.2: Generate config.h for AROS
- [ ] Task 2.3: Set up mmakefile

### Core Implementation Tasks
- [ ] Task 3.1: Port socket layer to bsdsocket.library
- [ ] Task 3.2: Implement POSIX compatibility wrappers
- [ ] Task 3.3: Fix thread handling for AROS tasks
- [ ] Task 3.4: Integrate OpenSSL (if available)

### Testing Tasks
- [ ] Task 4.1: Compile test programs
- [ ] Task 4.2: Run unit tests
- [ ] Task 4.3: Validate HTTP functionality
- [ ] Task 4.4: Validate HTTPS functionality

### Documentation Tasks
- [ ] Task 5.1: Write README.AROS
- [ ] Task 5.2: Document API differences
- [ ] Task 5.3: Create usage examples
```

### **3.2 Task Prioritization**
Order tasks by dependency and priority:

```markdown
## Task Order

### Phase 3A: Foundation (Must be done first)
1. Task 1.1 → Task 1.2 → Task 1.3
2. Task 2.1 → Task 2.2 → Task 2.3

### Phase 3B: Core Implementation (After foundation)
3. Task 3.1 → Task 3.2
4. Task 3.3
5. Task 3.4 (optional, can be parallel)

### Phase 3C: Validation (After implementation)
6. Task 4.1 → Task 4.2 → Task 4.3 → Task 4.4

### Phase 3D: Documentation (After validation)
7. Task 5.1 → Task 5.2 → Task 5.3
```

### **3.3 Task Detail Sheets**
For each task, create a detail sheet:

**Template:**
```markdown
## Task 3.1: Port socket layer to bsdsocket.library

### AI_TASK: SOCKET_LAYER_PORT
### AI_STATUS: PENDING
### AI_COMPLEXITY: HIGH
### AI_DEPENDENCIES: bsdsocket.library headers
### AI_ESTIMATE: 4 hours
### AI_PRIORITY: CRITICAL

### Description
Replace POSIX socket calls with AROS bsdsocket.library equivalents.

### Input
- libcurl source files using socket()
- AROS bsdsocket.library headers

### Output
- Modified source files with AROS socket calls
- Wrapper layer if needed

### Steps
1. Identify all POSIX socket calls in libcurl
2. Create mapping table: POSIX → bsdsocket
3. Implement wrapper functions
4. Replace calls in source
5. Test compilation

### Success Criteria
- Code compiles without socket-related errors
- Socket functionality works in test program

### Risks
- bsdsocket API might be missing some POSIX features
- Mitigation: Implement compatibility layer
```

### **3.4 Task Segmentation Document**
Generate the complete task list.

**Save as:** `docs/phase3/tasks_YYYYMMDD.md`

---

# **Phase 4: The Implementation Loop**

## **Objective**
Implement tasks iteratively, fixing build errors as they arise.

## **Steps**

### **4.1 Task Implementation Cycle**

For each task:

```
1. Read Task Detail Sheet
2. Implement Code Changes
3. Build (capture log)
4. Analyze Build Log
5. Fix Errors (if any)
6. Rebuild
7. Repeat until success
8. Mark Task Complete
9. Commit Changes
```

### **4.2 Build Log Capture**

**Every build must be logged:**

```bash
# Capture full build output
make 2>&1 | tee docs/phase4/build_logs/build_$(date +%Y%m%d_%H%M%S).log
```

**Build log metadata:**
```markdown
## AI_BUILD: build_20231207_143022
## AI_STATUS: FAILED
## AI_ERRORS: 5
## AI_WARNINGS: 12
## AI_TASK: SOCKET_LAYER_PORT
## AI_ITERATION: 3
```

### **4.3 Error Analysis**

For each build failure, the agent must:

1. **Extract error messages**
2. **Identify root cause**
3. **Consult Phase 1 discoveries**
4. **Propose fix**
5. **Document reasoning**

**Save as:** `docs/phase4/build_logs/error_analysis_XXX.md`

**Template:**
```markdown
## AI_ERROR_ANALYSIS: 001
## AI_BUILD: build_20231207_143022
## AI_STATUS: ANALYZED
## AI_TASK: SOCKET_LAYER_PORT

# Error Analysis

## Error Message
```
socket.c:45: error: 'AF_INET' undeclared
```

## Root Cause
Missing include for bsdsocket.library headers.

## Discovery Reference
Phase 1 analysis identified that AROS uses `<sys/socket.h>` from bsdsocket.library, not POSIX.

## Proposed Fix
Add:
```c
#include <sys/socket.h>
#include <netinet/in.h>
```

## Implementation
[Specific code changes]

## Testing
Recompile and verify error is resolved.

## Commit
Git commit with AI_COMMIT tag referencing this analysis.
```

### **4.4 Fix Implementation**

**Every fix must:**
1. Be minimal and targeted
2. Reference error analysis
3. Include AI_COMMIT metadata
4. Be tested immediately

**Commit message format:**
```
AI_COMMIT: Fix AF_INET undeclared error

- Added bsdsocket.library headers
- Ref: error_analysis_001.md
- Task: SOCKET_LAYER_PORT
- Iteration: 3
```

### **4.5 Iteration Tracking**

Track each build/fix iteration:

**Save as:** `docs/phase4/iteration_XXX.md`

**Template:**
```markdown
## AI_ITERATION: 003
## AI_TASK: SOCKET_LAYER_PORT
## AI_STATUS: IN_PROGRESS
## AI_BUILD: build_20231207_143022

# Iteration 3

## Changes Made
- Added bsdsocket.library headers
- Fixed AF_INET declaration

## Build Result
- Status: FAILED
- Errors: 3 (down from 5)
- Warnings: 12

## Errors Resolved
1. AF_INET undeclared

## Errors Remaining
1. socket() not found
2. bind() not found
3. listen() not found

## Next Steps
Create wrapper functions for socket/bind/listen using bsdsocket.library equivalents.

## Files Modified
- contrib/network/curl/lib/socket.c
```

### **4.6 Success Criteria**

A task is complete when:
- Code compiles without errors
- Tests pass (if applicable)
- Functionality is verified
- Documentation is updated
- Changes are committed

Mark task complete in `docs/phase3/tasks_YYYYMMDD.md`

---

# **Phase 5: Completion**

## **Objective**
Finalize the implementation and document results.

## **Steps**

### **5.1 Final Build Verification**

Perform a clean build:

```bash
# Clean build
make clean

# Full rebuild with logging
make 2>&1 | tee docs/phase5/final_build_$(date +%Y%m%d).log
```

### **5.2 Testing Report**

Run all tests and document results:

**Save as:** `docs/phase5/testing_report_YYYYMMDD.md`

**Template:**
```markdown
## AI_PHASE: COMPLETION
## AI_STATUS: TESTING
## AI_NOTE: Final validation

# Testing Report

## Date
[YYYY-MM-DD]

## Test Summary
- Total Tests: 25
- Passed: 23
- Failed: 2
- Skipped: 0

## Test Results

### Unit Tests
✅ HTTP GET test - PASSED
✅ HTTP POST test - PASSED
✅ Cookie handling - PASSED
❌ HTTPS GET test - FAILED (OpenSSL not available)
...

### Integration Tests
✅ wget port using libcurl - PASSED
✅ Real-world HTTP download - PASSED
...

## Known Issues
1. HTTPS not working - OpenSSL dependency missing
2. IPv6 support incomplete - bsdsocket.library limitation

## Workarounds
[Document any workarounds needed]
```

### **5.3 Documentation Finalization**

Create end-user documentation:

**Files to create:**
- `README.AROS` - AROS-specific information
- `INSTALL.AROS` - Installation instructions
- `PORTING_NOTES.md` - Technical porting details
- `CHANGELOG.AROS` - Changes made for AROS

**Example README.AROS:**
```markdown
# libcurl for AROS

## AI_PHASE: COMPLETION
## AI_STATUS: DOCUMENTED
## AI_VERSION: 1.0

## Overview
This is a port of libcurl to AROS, enabling HTTP/HTTPS networking.

## Building
```bash
cd contrib/network/curl
mmake
```

## Usage
See `examples/` directory for usage examples.

## Known Limitations
- HTTPS requires OpenSSL (not yet ported)
- IPv6 support limited

## API Differences
See `docs/PORTING_NOTES.md` for POSIX → AROS API mappings.
```

### **5.4 Completion Report**

Generate final completion report:

**Save as:** `docs/phase5/completion_report_YYYYMMDD.md`

**Template:**
```markdown
## AI_PHASE: COMPLETION
## AI_STATUS: COMPLETE
## AI_COMPLEXITY: HIGH
## AI_SUCCESS: YES
## AI_NOTE: Project successfully completed

# Completion Report: [Project Name]

## Date
[YYYY-MM-DD]

## Goal Achievement
✅ Goal 1: [Achieved]
✅ Goal 2: [Achieved]
⚠️ Goal 3: [Partially achieved - see notes]

## Implementation Summary
- Total Tasks: 15
- Completed: 15
- Iterations: 47
- Build Errors Fixed: 83
- Final Build: SUCCESS

## Key Challenges Overcome
1. [Challenge 1]: [How it was solved]
2. [Challenge 2]: [How it was solved]

## Code Statistics
- Files Modified: 45
- Lines Added: 1,234
- Lines Removed: 567
- Commits: 23

## Testing Results
- Tests Passed: 23/25 (92%)
- Known Issues: 2 (documented)

## Documentation Created
- README.AROS
- INSTALL.AROS
- PORTING_NOTES.md
- CHANGELOG.AROS
- API reference updates

## Lessons Learned
[What the AI learned during this process]

## Future Work
[Optional improvements or enhancements]

## Project Status
**COMPLETE** - Ready for production use with documented limitations.
```

### **5.5 Archive Session**

Move all phase documents to archive:

```bash
mkdir -p docs/archive/session_$(date +%Y%m%d)
mv docs/phase1 docs/phase2 docs/phase3 docs/phase4 docs/phase5 \
   docs/archive/session_$(date +%Y%m%d)/
```

---

# **Multi-Agent Collaboration (ACD v1.1.0)**

The AGENTIC_AI_WORKFLOW supports multi-agent collaboration using the [ACD Standard v1.1.0](../acd-system/docs/ACD_SPECIFICATION_V1.md) communication protocol.

## **Agent Collaboration Patterns**

### **1. Task Assignment**

When assigning tasks between agents:

```markdown
## AI_ASSIGNED_TO: copilot-github
## AI_ASSIGNED_BY: orchestrator-system
## AI_ASSIGNED_AT: 2025-12-08T16:00:00Z
## AI_ASSIGNMENT_REASON: Expertise in GitHub API integration
## AI_QUEUE_PRIORITY: HIGH
## AI_QUEUE_STATUS: ASSIGNED
```

### **2. Confidence Signaling**

Agents communicate their confidence level:

```markdown
## AI_CONFIDENCE: UNCERTAIN
## AI_REQUEST: REQUEST_REVIEW
## AI_NOTE_CONFIDENCE: Unsure about memory management approach - needs validation
```

**Confidence Levels:**
- `CONFIDENT` - Agent is certain about the solution
- `UNCERTAIN` - Agent needs validation or review
- `HYPOTHESIS` - Experimental approach, needs testing
- `VALIDATED` - Solution has been tested and confirmed
- `EXPERIMENTAL` - Trying new approach, high risk

### **3. Agent Handoff**

When an agent needs to transfer work:

```markdown
## AI_HANDOFF_REQUESTED: true
## AI_HANDOFF_TYPE: SPECIALIZATION
## AI_HANDOFF_TO: aros-expert-agent
## AI_HANDOFF_REASON: Requires deep AROS kernel knowledge
## AI_HANDOFF_NOTES: Stuck on exec.library initialization - need specialist
## AI_REQUIRED_CAPABILITIES: aros-kernel, exec-library, memory-pools
## AI_SKILL_LEVEL_REQUIRED: SPECIALIST
```

**Handoff Types:**
- `ESCALATION` - Problem too complex for current agent
- `SPECIALIZATION` - Needs specific expertise
- `LOAD_BALANCE` - Redistribute work across agents
- `FAILURE` - Current agent unable to proceed
- `COMPLETION` - Task finished, handoff for review
- `COLLABORATION` - Joint work with another agent

### **4. Dual-Agent Exchange**

For generate-review-refine workflows:

```markdown
## AI_EXCHANGE_ID: network-impl-session-123
## AI_ROUND: 1

# Generator produces solution
## AI_ASSIGNED_TO: generator-copilot
## AI_STATE: READY
## AI_CONFIDENCE: CONFIDENT

# Reviewer analyzes
## AI_VALIDATION: ANALYZED
## AI_ISSUES: Buffer overflow risk, Missing NULL check
## AI_SUGGESTIONS: Add bounds checking, Validate pointers
## AI_VALIDATION_RESULT: NEEDS_MORE_WORK

# Generator refines
## AI_ROUND: 2
## AI_REFINEMENT: APPLIED
## AI_CHANGES: Added bounds checking and NULL validation
## AI_RATIONALE: Prevents buffer overflow and crash scenarios

# Reviewer validates
## AI_VALIDATION_RESULT: APPROVED
## AI_APPROVAL: YES
```

### **5. Queue Management**

Track task progress through processing queue:

```markdown
## AI_QUEUE_STATUS: IN_PROGRESS
## AI_QUEUE_PRIORITY: CRITICAL
## AI_STARTED: 2025-12-08T16:30:00Z
## AI_ESTIMATED_COMPLETION: 2025-12-08T18:00:00Z
## AI_QUEUE_REASON: Blocking build failure - immediate fix required
```

**Queue Status Values:**
- `QUEUED` - Waiting for assignment
- `ASSIGNED` - Agent selected
- `IN_PROGRESS` - Agent actively working
- `REVIEW_PENDING` - Waiting for review
- `REVIEW_IN_PROGRESS` - Under review
- `APPROVED` - Review passed
- `REJECTED` - Review failed
- `COMPLETED` - Task finished
- `ABANDONED` - Task cancelled

### **6. State Communication**

Agents signal their current processing state:

```markdown
## AI_STATE: BLOCKED
## AI_REQUEST: WAITING_FOR_INPUT
## AI_REQUEST_FROM: human-reviewer
## AI_NOTE_REQUEST: Need clarification on API requirements
```

**State Values:**
- `PROCESSING` - Agent actively working
- `READY` - Work complete, ready for next step
- `DONE` - Task fully completed
- `BLOCKED` - Cannot proceed without input
- `PAUSED` - Temporarily suspended
- `FAILED` - Encountered fatal error
- `CANCELLED` - Task aborted

## **Multi-Agent Workflow Example**

**Scenario:** Porting a complex POSIX API to AROS

### **Step 1: Initial Assignment**
```markdown
## AI_PHASE: DISCOVERY
## AI_PROJECT: posix-port
## AI_ASSIGNED_TO: discovery-agent
## AI_ASSIGNED_BY: orchestrator
## AI_QUEUE_STATUS: IN_PROGRESS
## AI_STATE: PROCESSING
```

### **Step 2: Discovery Complete, Request Review**
```markdown
## AI_PHASE: DISCOVERY
## AI_STATUS: COMPLETE
## AI_STATE: READY
## AI_CONFIDENCE: CONFIDENT
## AI_REQUEST: REQUEST_REVIEW
```

### **Step 3: Handoff to Implementation Specialist**
```markdown
## AI_HANDOFF_REQUESTED: true
## AI_HANDOFF_TYPE: SPECIALIZATION
## AI_HANDOFF_TO: aros-implementation-agent
## AI_HANDOFF_STATUS: ACCEPTED
## AI_PREVIOUS_ASSIGNEE: discovery-agent
## AI_ASSIGNED_TO: aros-implementation-agent
```

### **Step 4: Implementation with Dual-Agent Review**
```markdown
## AI_PHASE: IMPLEMENTATION
## AI_EXCHANGE_ID: posix-port-impl
## AI_ROUND: 1
## AI_ASSIGNED_TO: aros-implementation-agent
## AI_CONFIDENCE: UNCERTAIN
## AI_REQUEST: REQUEST_REVIEW

# Reviewer feedback
## AI_VALIDATION: ANALYZED
## AI_ISSUES: Memory leak, Missing error handling
## AI_VALIDATION_RESULT: NEEDS_MORE_WORK

# Refinement
## AI_ROUND: 2
## AI_REFINEMENT: APPLIED
## AI_CHANGES: Fixed memory leak, added error handling
## AI_VALIDATION_RESULT: APPROVED
```

### **Step 5: Escalation for Critical Issue**
```markdown
## AI_STATE: BLOCKED
## AI_HANDOFF_REQUESTED: true
## AI_HANDOFF_TYPE: ESCALATION
## AI_HANDOFF_REASON: Kernel panic on initialization
## AI_HANDOFF_TO: kernel-specialist
## AI_SKILL_LEVEL_REQUIRED: SPECIALIST
## AI_QUEUE_PRIORITY: CRITICAL
```

### **Step 6: Resolution and Completion**
```markdown
## AI_STATE: DONE
## AI_QUEUE_STATUS: COMPLETED
## AI_VALIDATION_RESULT: APPROVED
## AI_APPROVAL: YES
## AI_HANDOFF_TYPE: COMPLETION
```

## **Best Practices**

1. **Always Signal Confidence** - Let other agents know if you're uncertain
2. **Request Review When Needed** - Use `AI_REQUEST` fields appropriately
3. **Document Handoff Reasons** - Help the next agent understand context
4. **Track Assignment History** - Maintain full chain in `AI_ASSIGNMENT_HISTORY`
5. **Use Appropriate Queue Priority** - `CRITICAL` only for blocking issues
6. **Maintain Exchange IDs** - Keep dual-agent sessions identifiable
7. **Update State Accurately** - Let orchestrators know your current status

---

# **Build Log Workflow**

## **Automated Build Log Capture**

### **Helper Script: capture_build.sh**

**Location:** `scripts/capture_build.sh`

```bash
#!/bin/bash
# AI_SCRIPT: capture_build.sh
# AI_PURPOSE: Capture build output with metadata
# AI_USAGE: ./scripts/capture_build.sh [build_command]

set -e

# Configuration
LOG_DIR="docs/phase4/build_logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/build_${TIMESTAMP}.log"

# Create log directory if needed
mkdir -p "$LOG_DIR"

# Capture metadata
echo "## AI_BUILD: build_${TIMESTAMP}" > "$LOG_FILE"
echo "## AI_DATE: $(date -Iseconds)" >> "$LOG_FILE"
echo "## AI_COMMAND: $@" >> "$LOG_FILE"
echo "## AI_HOST: $(uname -a)" >> "$LOG_FILE"
echo "## AI_BRANCH: $(git branch --show-current)" >> "$LOG_FILE"
echo "## AI_COMMIT: $(git rev-parse HEAD)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Run build and capture output
echo "Starting build..."
if eval "$@" 2>&1 | tee -a "$LOG_FILE"; then
    BUILD_STATUS="SUCCESS"
    EXIT_CODE=0
else
    BUILD_STATUS="FAILED"
    EXIT_CODE=$?
fi

# Add status metadata
echo "" >> "$LOG_FILE"
echo "## AI_STATUS: $BUILD_STATUS" >> "$LOG_FILE"
echo "## AI_EXIT_CODE: $EXIT_CODE" >> "$LOG_FILE"

# Count errors and warnings
ERROR_COUNT=$(grep -c "error:" "$LOG_FILE" || true)
WARNING_COUNT=$(grep -c "warning:" "$LOG_FILE" || true)

echo "## AI_ERRORS: $ERROR_COUNT" >> "$LOG_FILE"
echo "## AI_WARNINGS: $WARNING_COUNT" >> "$LOG_FILE"

echo ""
echo "Build log saved: $LOG_FILE"
echo "Status: $BUILD_STATUS"
echo "Errors: $ERROR_COUNT"
echo "Warnings: $WARNING_COUNT"

exit $EXIT_CODE
```

### **Usage**

```bash
# Capture AROS build
./scripts/capture_build.sh "make"

# Capture configure
./scripts/capture_build.sh "./configure --host=x86_64-aros"

# Capture test run
./scripts/capture_build.sh "make test"
```

### **Build Log Analysis Script**

**Location:** `scripts/analyze_build_log.sh`

```bash
#!/bin/bash
# AI_SCRIPT: analyze_build_log.sh
# AI_PURPOSE: Extract and categorize errors from build log
# AI_USAGE: ./scripts/analyze_build_log.sh [log_file]

LOG_FILE=$1

if [ -z "$LOG_FILE" ]; then
    echo "Usage: $0 <build_log_file>"
    exit 1
fi

ANALYSIS_FILE="${LOG_FILE%.log}_analysis.md"

cat > "$ANALYSIS_FILE" << EOF
## AI_ERROR_ANALYSIS: $(basename ${LOG_FILE%.log})
## AI_DATE: $(date -Iseconds)
## AI_STATUS: ANALYZED

# Build Error Analysis

## Summary
EOF

# Extract metadata
grep "^## AI_" "$LOG_FILE" >> "$ANALYSIS_FILE"

echo "" >> "$ANALYSIS_FILE"
echo "## Errors Found" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"

# Extract errors
grep "error:" "$LOG_FILE" | sort -u >> "$ANALYSIS_FILE" || echo "No errors found" >> "$ANALYSIS_FILE"

echo "" >> "$ANALYSIS_FILE"
echo "## Warnings Found" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"

# Extract warnings
grep "warning:" "$LOG_FILE" | sort -u | head -20 >> "$ANALYSIS_FILE" || echo "No warnings found" >> "$ANALYSIS_FILE"

echo ""
echo "Analysis saved: $ANALYSIS_FILE"
```

---

# **GitHub Issue Templates**

## **Template: Agent Task**

**Location:** `.github/ISSUE_TEMPLATE/agent_task.md`

```markdown
---
name: Agent Task
about: Task for autonomous AI agent
title: '[AGENT] '
labels: 'ai-agent, task'
assignees: ''
---

## AI_PHASE: [DISCOVERY|MASTER_PLAN|TASK_SEGMENTATION|IMPLEMENTATION|COMPLETION]
## AI_STATUS: [PENDING|IN_PROGRESS|BLOCKED|COMPLETE]
## AI_COMPLEXITY: [LOW|MEDIUM|HIGH|CRITICAL]
## AI_PRIORITY: [LOW|MEDIUM|HIGH|CRITICAL]
## AI_ASSIGNED_TO: [Agent identifier]

## Task Description
[Clear description of what needs to be accomplished]

## Context
[Background information and references to discovery/planning documents]

## Dependencies
- [ ] Dependency 1
- [ ] Dependency 2

## Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Documentation Location
[Path to relevant phase documents in docs/]

## Build Logs
[Links to build logs if applicable]

## Notes
[Additional information for the agent]
```

## **Template: Build Log Upload**

**Location:** `.github/ISSUE_TEMPLATE/build_log.md`

```markdown
---
name: Build Log
about: Report build failure with logs
title: '[BUILD] '
labels: 'build, logs'
assignees: ''
---

## AI_BUILD: [build_identifier]
## AI_STATUS: FAILED
## AI_ERRORS: [count]
## AI_WARNINGS: [count]
## AI_TASK: [related_task]

## Build Information
- **Date:** [YYYY-MM-DD HH:MM:SS]
- **Branch:** [git branch]
- **Commit:** [git commit hash]
- **Platform:** [build platform]

## Build Command
```bash
[command used to build]
```

## Error Summary
[Brief description of errors]

## Build Log
```
[Paste build log or link to uploaded log file]
```

## Analysis Request
[What you want the agent to investigate]
```

## **Template: Progress Update**

**Location:** `.github/ISSUE_TEMPLATE/progress_update.md`

```markdown
---
name: Progress Update
about: Update on agent task progress
title: '[PROGRESS] '
labels: 'progress, ai-agent'
assignees: ''
---

## AI_PHASE: [current_phase]
## AI_STATUS: IN_PROGRESS
## AI_ITERATION: [number]
## AI_TASK: [task_identifier]

## Progress Summary
[High-level summary of what has been accomplished]

## Tasks Completed
- [x] Task 1
- [x] Task 2

## Tasks In Progress
- [ ] Task 3 (50%)
- [ ] Task 4 (25%)

## Tasks Pending
- [ ] Task 5
- [ ] Task 6

## Challenges Encountered
1. [Challenge 1]: [Resolution or status]
2. [Challenge 2]: [Resolution or status]

## Build Status
- Last Build: [SUCCESS|FAILED]
- Errors: [count]
- Warnings: [count]
- Log: [link]

## Next Steps
[What will be done next]

## Estimated Completion
[Date or "blocked" with reason]
```

---

# **Helper Scripts**

## **Script: validate_metadata.sh**

**Location:** `scripts/validate_metadata.sh`

**Purpose:** Ensure all AI documents have proper metadata blocks.

```bash
#!/bin/bash
# AI_SCRIPT: validate_metadata.sh
# AI_PURPOSE: Validate metadata in AI-generated documents
# AI_USAGE: ./scripts/validate_metadata.sh [file_or_directory]

TARGET=$1

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <file_or_directory>"
    exit 1
fi

# Required metadata fields
REQUIRED_FIELDS=(
    "AI_PHASE"
    "AI_STATUS"
)

# Optional but recommended fields
RECOMMENDED_FIELDS=(
    "AI_COMPLEXITY"
    "AI_NOTE"
    "AI_DATE"
)

validate_file() {
    local file=$1
    local missing_required=()
    local missing_recommended=()
    
    # Check required fields
    for field in "${REQUIRED_FIELDS[@]}"; do
        if ! grep -q "^## $field:" "$file"; then
            missing_required+=("$field")
        fi
    done
    
    # Check recommended fields
    for field in "${RECOMMENDED_FIELDS[@]}"; do
        if ! grep -q "^## $field:" "$file"; then
            missing_recommended+=("$field")
        fi
    done
    
    # Report results
    if [ ${#missing_required[@]} -eq 0 ]; then
        echo "✅ $file - Valid metadata"
    else
        echo "❌ $file - Missing required fields: ${missing_required[*]}"
    fi
    
    if [ ${#missing_recommended[@]} -gt 0 ]; then
        echo "⚠️  $file - Missing recommended fields: ${missing_recommended[*]}"
    fi
}

if [ -f "$TARGET" ]; then
    validate_file "$TARGET"
elif [ -d "$TARGET" ]; then
    find "$TARGET" -name "*.md" -type f | while read file; do
        validate_file "$file"
    done
else
    echo "Error: $TARGET is not a file or directory"
    exit 1
fi
```

## **Script: create_phase_structure.sh**

**Location:** `scripts/create_phase_structure.sh`

**Purpose:** Set up proper directory structure for a new agent session.

```bash
#!/bin/bash
# AI_SCRIPT: create_phase_structure.sh
# AI_PURPOSE: Create directory structure for new agent session
# AI_USAGE: ./scripts/create_phase_structure.sh

TIMESTAMP=$(date +%Y%m%d)
SESSION_NAME="session_${TIMESTAMP}"

echo "Creating structure for: $SESSION_NAME"

# Create phase directories
mkdir -p docs/phase1
mkdir -p docs/phase2
mkdir -p docs/phase3
mkdir -p docs/phase4/build_logs
mkdir -p docs/phase5

# Create template files
cat > docs/phase1/discovery_${TIMESTAMP}.md << EOF
## AI_PHASE: DISCOVERY
## AI_STATUS: IN_PROGRESS
## AI_DATE: $(date -Iseconds)
## AI_SESSION: $SESSION_NAME

# Discovery Phase

[Agent will populate this document]
EOF

cat > docs/phase2/plan_${TIMESTAMP}.md << EOF
## AI_PHASE: MASTER_PLAN
## AI_STATUS: PENDING
## AI_DATE: $(date -Iseconds)
## AI_SESSION: $SESSION_NAME

# Master Plan

[Agent will populate this document after discovery]
EOF

cat > docs/phase3/tasks_${TIMESTAMP}.md << EOF
## AI_PHASE: TASK_SEGMENTATION
## AI_STATUS: PENDING
## AI_DATE: $(date -Iseconds)
## AI_SESSION: $SESSION_NAME

# Task List

[Agent will populate this document after planning]
EOF

echo "✅ Phase structure created"
echo "📁 Base directory: docs/"
echo "📄 Discovery template: docs/phase1/discovery_${TIMESTAMP}.md"
echo "📄 Plan template: docs/phase2/plan_${TIMESTAMP}.md"
echo "📄 Task template: docs/phase3/tasks_${TIMESTAMP}.md"
```

---

# **Appendices**

## **Appendix A: Metadata Field Reference**

### **Core Fields**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_PHASE | DISCOVERY, MASTER_PLAN, TASK_SEGMENTATION, IMPLEMENTATION, COMPLETION | Yes | Current workflow phase |
| AI_STATUS | PENDING, IN_PROGRESS, BLOCKED, COMPLETE, FAILED | Yes | Current status |
| AI_COMPLEXITY | LOW, MEDIUM, HIGH, CRITICAL | Recommended | Task complexity level |
| AI_NOTE | Free text | Recommended | Brief description |

### **Task Fields**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_TASK | Identifier | For tasks | Unique task identifier |
| AI_PRIORITY | LOW, MEDIUM, HIGH, CRITICAL | For tasks | Task priority |
| AI_ESTIMATE | Hours/days | For tasks | Time estimate |
| AI_DEPENDENCIES | List | For tasks | Dependencies |

### **Build Fields**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_BUILD | Identifier | For builds | Build identifier |
| AI_ERRORS | Number | For builds | Error count |
| AI_WARNINGS | Number | For builds | Warning count |
| AI_EXIT_CODE | Number | For builds | Build exit code |

### **Commit Fields**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_COMMIT | Identifier | For commits | Commit reference |
| AI_BRANCH | Branch name | For commits | Git branch |
| AI_FIX_HISTORY | List | For fixes | Previous fixes |
| AI_ERROR_HISTORY | List | For fixes | Error history |

### **History Fields**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_HISTORY | Commit chain | For API porting | Historical trace of function/API evolution with commits |
| AI_HISTORY_STATUS | SUCCESS, SUPERSEDED | For API porting | Success = last in chain, Superseded = replaced by newer version |
| AI_HISTORY_TAG | Function/API name | For API porting | Tag to group related history entries (e.g., "socket_impl", "file_io") |

### **Agent Collaboration Fields (ACD v1.1.0)**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_ASSIGNED_TO | Agent name | For task tracking | Current agent assigned to this task |
| AI_ASSIGNED_BY | Agent/system name | For task tracking | Agent or system that made the assignment |
| AI_ASSIGNED_AT | ISO 8601 timestamp | For task tracking | When task was assigned |
| AI_ASSIGNMENT_REASON | Free text | For task tracking | Why this agent was chosen |
| AI_PREVIOUS_ASSIGNEE | Agent name | For handoff tracking | Previous agent (for handoff tracking) |
| AI_ASSIGNMENT_HISTORY | Agent list | For handoff tracking | Complete assignment chain in chronological order |

### **Agent Handoff Fields (ACD v1.1.0)**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_HANDOFF_REQUESTED | Boolean | For handoffs | Whether handoff is requested |
| AI_HANDOFF_REASON | Free text | For handoffs | Reason for handoff request |
| AI_HANDOFF_TO | Agent name | For handoffs | Specific agent requested for handoff |
| AI_HANDOFF_TYPE | ESCALATION, SPECIALIZATION, LOAD_BALANCE, FAILURE, COMPLETION, COLLABORATION | For handoffs | Type of handoff |
| AI_HANDOFF_AT | ISO 8601 timestamp | For handoffs | When handoff occurred |
| AI_HANDOFF_NOTES | Free text | For handoffs | Context for next agent |
| AI_HANDOFF_STATUS | REQUESTED, ACCEPTED, REJECTED, COMPLETED | For handoffs | Handoff workflow state |

### **Communication Flags (ACD v1.1.0)**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_CONFIDENCE | CONFIDENT, UNCERTAIN, HYPOTHESIS, VALIDATED, EXPERIMENTAL | For collaboration | Agent's confidence level in the output |
| AI_REQUEST | REQUEST_FEEDBACK, REQUEST_REVIEW, WAITING_FOR_INPUT, NEEDS_VALIDATION, NEEDS_APPROVAL, REQUEST_ASSISTANCE | For collaboration | Signals need for feedback or action |
| AI_STATE | PROCESSING, READY, DONE, BLOCKED, PAUSED, FAILED, CANCELLED | For collaboration | Current processing state |
| AI_NOTE_CONFIDENCE | Free text | For collaboration | Additional notes about confidence level |
| AI_REQUEST_FROM | Agent/human name | For collaboration | Specific agent or human requested for feedback |
| AI_NOTE_REQUEST | Free text | For collaboration | Details about the request |

### **Queuing Flags (ACD v1.1.0)**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_QUEUE_PRIORITY | CRITICAL, HIGH, NORMAL, LOW, DEFERRED | For queue management | Task priority level |
| AI_QUEUE_STATUS | QUEUED, ASSIGNED, IN_PROGRESS, REVIEW_PENDING, REVIEW_IN_PROGRESS, APPROVED, REJECTED, COMPLETED, ABANDONED | For queue management | Task progress through processing queue |
| AI_QUEUE_REASON | Free text | For queue management | Reason for priority level or queue status |
| AI_STARTED | ISO 8601 timestamp | For queue management | When task processing started |
| AI_ESTIMATED_COMPLETION | ISO 8601 timestamp | For queue management | Estimated completion time |

### **Dual-Agent Exchange Fields (ACD v1.1.0)**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_VALIDATION | ANALYZED, APPROVED, REJECTED, PENDING | For dual-agent | Validation status from reviewer agent |
| AI_ISSUES | Array of strings | For dual-agent | Issues identified by reviewer |
| AI_SUGGESTIONS | Array of strings | For dual-agent | Suggestions from reviewer |
| AI_REFINEMENT | APPLIED, IN_PROGRESS, PENDING, NOT_NEEDED | For dual-agent | Refinement status |
| AI_CHANGES | Free text | For dual-agent | Changes made during refinement |
| AI_RATIONALE | Free text | For dual-agent | Reasoning for changes |
| AI_VALIDATION_RESULT | APPROVED, NEEDS_MORE_WORK, REJECTED | For dual-agent | Final validation result |
| AI_APPROVAL | YES, NO, CONDITIONAL | For dual-agent | Approval status |
| AI_EXCHANGE_ID | String | For dual-agent | Unique exchange session identifier |
| AI_ROUND | Integer | For dual-agent | Exchange iteration number |

### **Capability Matching Fields (ACD v1.1.0)**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_REQUIRED_CAPABILITIES | Array of strings | For matching | Required agent capabilities |
| AI_PREFERRED_AGENT_TYPE | String | For matching | Preferred agent specialization |
| AI_AGENT_POOL | Array of strings | For matching | Eligible agents for assignment |
| AI_SKILL_LEVEL_REQUIRED | NOVICE, INTERMEDIATE, EXPERT, SPECIALIST | For matching | Minimum skill level needed |

### **Distributed Coordination Fields (ACD v1.1.0)**
| Field | Values | Required | Description |
|-------|--------|----------|-------------|
| AI_TIMEOUT | Integer (seconds) | For coordination | Timeout for task completion |
| AI_MAX_RETRIES | Integer | For coordination | Maximum retry attempts |

## **Appendix B: AROS-Specific Patterns**

### **API Wrapper Pattern**
```c
// POSIX code (Linux)
int fd = open("/path/to/file", O_RDONLY);

// AROS equivalent
BPTR fh = Open("/path/to/file", MODE_OLDFILE);
```

### **Memory Management Pattern**
```c
// POSIX code
void *ptr = malloc(size);
free(ptr);

// AROS equivalent
APTR ptr = AllocMem(size, MEMF_ANY);
FreeMem(ptr, size);
```

### **Thread Pattern**
```c
// POSIX code
pthread_create(&thread, NULL, func, arg);

// AROS equivalent
CreateTask("TaskName", priority, func, STACK_SIZE);
```

## **Appendix C: Build System Reference**

### **mmakefile Structure**
```makefile
# Metadata
#MM- contrib-network : contrib-network-curl

# Variables
CURL_VERSION := 7.88.1
CURL_DIR := $(PORTSDIR)/curl/curl-$(CURL_VERSION)

# Targets
#MM contrib-network-curl : includes linklibs
contrib-network-curl:
    %fetch_and_build_gnu_development curl \
        version=$(CURL_VERSION) \
        extraoptions="--host=$(AROS_TARGET_CPU)-aros"
```

### **Configure Flags**
```bash
./configure \
    --host=$(AROS_TARGET_CPU)-aros \
    --prefix=/usr/local \
    --disable-shared \
    --enable-static \
    --with-ssl=$(AROS_DEVELOPER)/include
```

## **Appendix D: Example Session Flow**

```
Day 1: Discovery
├── Agent explores repository
├── Identifies libcurl needs porting
├── Analyzes similar ports (AROSTCP)
├── Maps POSIX → AROS APIs
└── Generates discovery_20231207.md

Day 2: Planning
├── Designs architecture
├── Defines dependencies (OpenSSL, zlib)
├── Creates build strategy
├── Estimates 15 tasks, 40 hours
└── Generates master_plan_20231207.md

Day 3: Task Segmentation
├── Breaks down into 15 tasks
├── Prioritizes by dependency
├── Creates detail sheets
└── Generates tasks_20231207.md

Days 4-8: Implementation
├── Task 1: Setup environment
│   ├── Iteration 1: Configure → Error
│   ├── Iteration 2: Fix config → Success
│   └── Commit + Document
├── Task 2: Port socket layer
│   ├── Iteration 1: Compile → 5 errors
│   ├── Iteration 2: Fix headers → 3 errors
│   ├── Iteration 3: Add wrappers → Success
│   └── Commit + Document
├── [Tasks 3-14...]
└── All tasks complete

Day 9: Completion
├── Clean build → Success
├── Run tests → 23/25 pass
├── Document known issues
├── Write README.AROS
├── Generate completion_report_20231216.md
└── Archive session
```

---

## **Appendix E: API Porting History & Evolution Tracking**

### **Purpose**

The **AI_HISTORY** field provides a searchable, traceable record of how APIs and functions evolved during porting. This creates institutional memory that can be searched via documentation and `git blame`, enabling agents to understand:

- How an API was successfully ported
- What approaches were tried and failed
- What commit chain represents the evolution
- Whether this is the final successful version or a superseded attempt

### **AI_HISTORY Metadata Fields**

| Field | Format | Required | Description |
|-------|--------|----------|-------------|
| `AI_HISTORY` | Commit chain | For API changes | Historical trace of function/API evolution: `tag_v1 [commit] → tag_v2 [commit] → tag_v3 [commit]` |
| `AI_HISTORY_STATUS` | Enum | For API changes | `SUCCESS` = final working version (last in chain), `SUPERSEDED` = replaced by newer approach |
| `AI_HISTORY_TAG` | String | For API changes | Grouping tag for related implementations (e.g., `socket_impl`, `file_io_posix`) |
| `AI_COMMIT_HISTORY` | Commit list | Recommended | ACD-compliant: Comma-separated previous commits (newest first), per [ACD Specification](../acd-system/docs/ACD_SPECIFICATION_V1.md) |

### **History Chain Format**

```markdown
## AI_HISTORY: socket_v1 [a3b2c1d] → socket_v2 [e4f5g6h] → socket_v3 [i7j8k9l]
## AI_HISTORY_STATUS: SUCCESS
## AI_HISTORY_TAG: socket_impl
## AI_COMMIT_HISTORY: e4f5g6h, a3b2c1d
```

**Interpretation:**
- Three attempts to port socket functionality
- Final version (socket_v3) at commit `i7j8k9l` is marked `SUCCESS`
- Can search for `socket_impl` to find all related porting attempts
- Can use `git show a3b2c1d` to see what was tried in v1
- Can use `git blame` to trace the evolution of the code

### **Success vs. Superseded**

**SUCCESS** - Last in chain, currently active:
```markdown
## AI_HISTORY: memory_v1 [abc123] → memory_v2 [def456]
## AI_HISTORY_STATUS: SUCCESS
## AI_HISTORY_TAG: memory_management
## AI_NOTE: Final implementation using AllocMem/FreeMem pattern
```

**SUPERSEDED** - Replaced by better approach:
```markdown
## AI_HISTORY: memory_v1 [abc123]
## AI_HISTORY_STATUS: SUPERSEDED
## AI_HISTORY_TAG: memory_management
## AI_NOTE: Initial malloc/free approach - superseded by v2 using native AROS calls
```

### **Documentation Requirements**

For each API porting iteration, create a porting document:

**Location:** `docs/<project-name>/docs/PORTING_HISTORY_<api-name>.md`

**Template:**
```markdown
## AI_PHASE: IMPLEMENTATION
## AI_STATUS: COMPLETE
## AI_PROJECT: <project-name>
## AI_HISTORY_TAG: <function-tag>
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW

# API Porting History: <function-name>

## Porting Chain

### Version 1 - Initial Attempt
- **Commit:** [a3b2c1d](commit-url)
- **Date:** 2025-01-15
- **Approach:** Direct POSIX wrapper
- **Status:** SUPERSEDED
- **Reason:** Performance issues with constant syscall overhead
- **Key Learning:** AROS native APIs provide better performance

### Version 2 - Native API Integration
- **Commit:** [e4f5g6h](commit-url)
- **Date:** 2025-01-18
- **Approach:** Use AROS dos.library directly
- **Status:** SUPERSEDED
- **Reason:** Missing error handling for edge cases
- **Key Learning:** Must handle MODE_OLDFILE vs MODE_NEWFILE properly

### Version 3 - Final Implementation
- **Commit:** [i7j8k9l](commit-url)
- **Date:** 2025-01-20
- **Approach:** Native dos.library with comprehensive error handling
- **Status:** SUCCESS
- **Key Learning:** Always check IoErr() after Open() failure
- **Code:** [Link to final implementation]

## API Mapping

### Source (POSIX)
```c
int fd = open(path, O_RDONLY);
if (fd < 0) {
    perror("open failed");
    return -1;
}
```

### Target (AROS)
```c
BPTR fh = Open(path, MODE_OLDFILE);
if (!fh) {
    LONG err = IoErr();
    Printf("Open failed: %ld\n", err);
    return RETURN_ERROR;
}
```

## Searchability

**Git Commands:**
```bash
# View version 1
git show a3b2c1d -- path/to/file.c

# View version 2
git show e4f5g6h -- path/to/file.c

# View version 3 (current)
git show i7j8k9l -- path/to/file.c

# Trace full evolution
git log --oneline a3b2c1d..i7j8k9l -- path/to/file.c

# Find all uses of this tag
grep -r "AI_HISTORY_TAG: file_io" docs/
```

## Success Criteria Met
- ✅ Performance matches native AROS applications
- ✅ All error cases handled properly
- ✅ Memory management correct (no leaks)
- ✅ Documentation complete
- ✅ Tests passing

## Related APIs
- `Close()` - [PORTING_HISTORY_close.md](PORTING_HISTORY_close.md)
- `Read()` - [PORTING_HISTORY_read.md](PORTING_HISTORY_read.md)
- `Write()` - [PORTING_HISTORY_write.md](PORTING_HISTORY_write.md)
```

### **Searching Porting History**

**By Tag:**
```bash
# Find all socket implementations
grep -r "AI_HISTORY_TAG: socket_impl" docs/

# Find all memory management implementations
grep -r "AI_HISTORY_TAG: memory_management" docs/
```

**By Commit:**
```bash
# Show what was changed in a specific iteration
git show abc123

# Show the commit message and reasoning
git log -1 abc123

# Use git blame to trace current code back through history
git blame path/to/file.c | grep "socket_impl"
```

**By Status:**
```bash
# Find all successful implementations
grep -r "AI_HISTORY_STATUS: SUCCESS" docs/

# Find all superseded attempts (for learning)
grep -r "AI_HISTORY_STATUS: SUPERSEDED" docs/
```

### **Integration with ACD Standard**

This workflow integrates with the [ACD Standard Specification](../acd-system/docs/ACD_SPECIFICATION_V1.md):

- **AI_COMMIT_HISTORY** (ACD) = Complete commit trail for a code segment
- **AI_HISTORY** (AGENTIC_AI_WORKFLOW) = High-level porting evolution chain
- **AI_HISTORY_TAG** (AGENTIC_AI_WORKFLOW) = Grouping identifier for related changes

**Use both together:**
```markdown
## AI_PHASE: IMPLEMENTATION
## AI_STATUS: IMPLEMENTED
## AI_PROJECT: network-stack
## AI_COMMIT: i7j8k9l
## AI_COMMIT_HISTORY: e4f5g6h, a3b2c1d
## AI_HISTORY: socket_v1 [a3b2c1d] → socket_v2 [e4f5g6h] → socket_v3 [i7j8k9l]
## AI_HISTORY_STATUS: SUCCESS
## AI_HISTORY_TAG: socket_impl
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
```

### **Benefits**

✅ **Complete Traceability** - Every API change is documented with reasoning
✅ **Searchable History** - Find all attempts via tags, commits, or status
✅ **Learning from Failures** - Understand why approaches were superseded
✅ **Pattern Recognition** - Identify successful porting patterns
✅ **Institutional Memory** - New agents can learn from past work
✅ **Git Integration** - Full integration with version control
✅ **ACD Compliance** - Compatible with ACD Standard Specification

### **Example: Complete File Header**

```c
/*
 * AI_PHASE: NETWORK_TRANSLATION
 * AI_STATUS: IMPLEMENTED
 * AI_PROJECT: network-stack
 * AI_COMPLEXITY: HIGH
 * AI_NOTE: POSIX socket → AROS bsdsocket.library translation layer
 * AI_DEPENDENCIES: INIT_HOOKS, ERROR_HANDLING
 * AI_COMMIT: i7j8k9l
 * AI_COMMIT_HISTORY: e4f5g6h, a3b2c1d
 * AI_HISTORY: socket_v1 [a3b2c1d] → socket_v2 [e4f5g6h] → socket_v3 [i7j8k9l]
 * AI_HISTORY_STATUS: SUCCESS
 * AI_HISTORY_TAG: socket_impl
 * AI_WORKFLOW: AGENTIC_AI_WORKFLOW
 * SOURCE_API_REF: socket() - POSIX sys/socket.h
 * TARGET_API_REF: CloseSocket() - AROS bsdsocket/socketbasetags.h
 */
```

---

## **Final Notes**

This workflow ensures:
- ✅ Consistent documentation across sessions
- ✅ Traceable decision-making process
- ✅ Automated build log capture
- ✅ Structured error analysis
- ✅ Clear phase transitions
- ✅ Minimal human intervention
- ✅ Compatible with GitHub Copilot and local LLMs
- ✅ Scalable to any project (not just AROS)
- ✅ Complete API porting history with success/failure tracking
- ✅ Integration with ACD Standard for institutional memory

The agent should follow this workflow strictly, documenting every step and maintaining metadata throughout the process. This enables continuity across sessions, even with different AI models or agents.

**Remember:** Read first, code later. Document everything. Let the build logs guide the fixes. Track every iteration with AI_HISTORY for future reference.
