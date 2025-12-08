# Dual-Agent Workflow Example

## AI_PHASE: WORKFLOW_EXAMPLE
## AI_STATUS: COMPLETE
## AI_COMPLEXITY: LOW
## AI_NOTE: Visual example of dual-agent collaboration on a real problem

---

## 🎯 Example: Fixing a Build Error

Let's walk through a real example of how the dual-agent system solves a build error.

### Initial Problem

```c
// File: test_program.c
int main() {
    printf("Hello, World!\n");
    return 0;
}
```

**Error:**
```
test_program.c:2:5: error: 'printf' undeclared (first use in this function)
```

---

## 🔄 Exchange Cycle

### Iteration 1

#### Phase 1: Generation 🎨

**Generator Agent** (richardyoung/uigen-x-30b-moe:q6_k on GPU 0):

```
🤔 Analyzing problem: 'printf' undeclared
💡 Generating solution...
```

**Generated Code:**
```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

**Flags:** `UNCERTAIN`, `NEEDS_VALIDATION`, `READY`

**ACD Tags:**
```yaml
AI_PHASE: CODE_GENERATION
AI_STATUS: GENERATED
AI_NOTE: Added stdio.h include for printf
AI_COMPLEXITY: LOW
```

---

#### Phase 2: Reasoning 🧠

**Reasoning Agent** (huihui_ai/gpt-oss-abliterated on GPU 1):

```
🔍 Analyzing generated code...
📝 Checking for issues...
```

**Analysis Result:**
```json
{
  "validation": "NEEDS_WORK",
  "issues": [
    "No error handling for printf failure",
    "Missing error return code",
    "No input validation"
  ],
  "suggestions": [
    "Add error checking for printf return value",
    "Use EXIT_SUCCESS/EXIT_FAILURE constants",
    "Add proper error handling"
  ],
  "confidence": 0.7
}
```

**Flags:** `UNCERTAIN`, `REQUEST_FEEDBACK`, `READY`

**ACD Tags:**
```yaml
AI_VALIDATION: ANALYZED
AI_ISSUES: Missing error handling
AI_SUGGESTIONS: Add printf error checking
```

---

#### Phase 3: Refinement 🔧

**Generator Agent** (refining based on feedback):

```
🔄 Processing feedback...
✏️  Refining code with error handling...
```

**Refined Code:**
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    if (printf("Hello, World!\n") < 0) {
        fprintf(stderr, "Error: Failed to write to stdout\n");
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
```

**Flags:** `CONFIDENT`, `NEEDS_VALIDATION`, `READY`

**ACD Tags:**
```yaml
AI_REFINEMENT: APPLIED
AI_CHANGES: Added error handling, proper return codes
AI_RATIONALE: Addressed issues identified by reasoner
```

---

#### Phase 4: Validation ✓

**Reasoning Agent** (final validation):

```
✓ Validating refined code...
✓ Checking all issues addressed...
```

**Validation Result:**
```json
{
  "validation": "APPROVED",
  "confidence": 0.9,
  "remaining_issues": [],
  "strengths": [
    "Proper error handling",
    "Uses stdlib constants",
    "Good error messaging"
  ]
}
```

**Flags:** `CONFIDENT`, `DONE`

**ACD Tags:**
```yaml
AI_VALIDATION_RESULT: APPROVED
AI_APPROVAL: YES
```

---

## ✅ Result

**Final Code (Approved):**
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    if (printf("Hello, World!\n") < 0) {
        fprintf(stderr, "Error: Failed to write to stdout\n");
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
```

**Metrics:**
- **Iterations:** 1
- **Time:** ~30 seconds
- **Status:** ✅ Approved
- **Confidence:** 0.9

---

## 📊 Communication Timeline

```
Time  Agent      Phase          State        Confidence
----  ---------  -------------  -----------  -----------
0s    Generator  generation     PROCESSING   -
5s    Generator  generation     READY        UNCERTAIN
5s    Reasoner   reasoning      PROCESSING   -
12s   Reasoner   reasoning      READY        UNCERTAIN
12s   Generator  refinement     PROCESSING   -
20s   Generator  refinement     READY        CONFIDENT
20s   Reasoner   validation     PROCESSING   -
28s   Reasoner   validation     DONE         CONFIDENT
```

---

## 🎯 Key Observations

### Generator Agent
- **Strength:** Quick initial solution generation
- **Improvement:** Refinement based on feedback
- **Confidence:** Increased from UNCERTAIN to CONFIDENT

### Reasoning Agent
- **Strength:** Identified missing error handling
- **Analysis:** Comprehensive issue detection
- **Validation:** Thorough final approval

### Communication
- **Exchange:** Clear, structured messages
- **Flags:** Effective state signaling
- **ACD Tags:** Rich contextual metadata

---

## 💡 What Made This Work

### 1. Specialized Roles
- **Generator:** Focused on code creation
- **Reasoner:** Focused on validation
- **Result:** Better than single-agent approach

### 2. ACD Exchange Protocol
- **Structured:** Clear phases and expectations
- **Metadata:** Rich context preservation
- **Flags:** Explicit state communication

### 3. Iterative Refinement
- **Feedback Loop:** Generator learns from reasoner
- **Improvement:** Each iteration improves quality
- **Convergence:** Reaches approval efficiently

### 4. GPU Parallelism
- **Performance:** Both agents ready when needed
- **Efficiency:** No waiting for GPU allocation
- **Scalability:** Can handle multiple problems

---

## 🚀 Try It Yourself

Run this exact example:

```bash
cd /home/runner/work/AROS/AROS

python3 scripts/dual_agent_orchestrator.py \
    --problem "Fix error: 'printf' undeclared in test_program.c" \
    --output results.json

# View results
cat results.json | python3 -m json.tool
```

Or use the interactive example:

```bash
python3 scripts/dual_agent_example.py
# Select option 1
```

---

## 📚 Learn More

- [Quick Start Guide](DUAL_AGENT_QUICKSTART.md)
- [Full Documentation](DUAL_AGENT_SYSTEM.md)
- [ACD Standard](ACD_README.md)
- [Implementation Summary](DUAL_AGENT_IMPLEMENTATION_SUMMARY.md)

---

*Example Status: Complete ✅*
*Date: November 1, 2025*
*Version: 1.0*
