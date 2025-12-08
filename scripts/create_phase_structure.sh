#!/bin/bash
# AI_SCRIPT: create_phase_structure.sh
# AI_PURPOSE: Create directory structure for new agent session following AGENTIC_AI_WORKFLOW
# AI_USAGE: ./scripts/create_phase_structure.sh [session_name]
# AI_NOTE: Sets up proper docs/ structure for autonomous agent workflow

TIMESTAMP=$(date +%Y%m%d)
SESSION_NAME=${1:-"session_${TIMESTAMP}"}

echo "========================================="
echo "Creating Phase Structure"
echo "========================================="
echo "Session: $SESSION_NAME"
echo "Workflow: AGENTIC_AI_WORKFLOW"
echo ""

# Create phase directories
echo "Creating directories..."
mkdir -p docs/phase1
mkdir -p docs/phase2
mkdir -p docs/phase3
mkdir -p docs/phase4/build_logs
mkdir -p docs/phase5
mkdir -p docs/archive

# Create Phase 1 template
cat > docs/phase1/discovery_${TIMESTAMP}.md << EOF
## AI_PHASE: DISCOVERY
## AI_STATUS: IN_PROGRESS
## AI_DATE: $(date -Iseconds)
## AI_SESSION: $SESSION_NAME
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Initial repository exploration and analysis

# Discovery Phase

## Session Information
- **Session ID:** $SESSION_NAME
- **Started:** $(date)
- **Workflow:** AGENTIC_AI_WORKFLOW

## Objectives
1. Explore repository structure
2. Identify key subsystems
3. Analyze headers and APIs
4. Document patterns and conventions
5. Review similar ports (if applicable)

## Repository Structure
[Agent will document directory layout here]

## Key Subsystems
[Agent will identify and describe main subsystems]

## API Patterns Discovered
[Agent will document AROS API patterns and conventions]

## Build System Analysis
[Agent will analyze build configuration and makefiles]

## Similar Ports
[Agent will examine related ports for reference]

## Challenges Identified
[Agent will list potential implementation challenges]

## Next Steps
[Transition to Phase 2: Master Plan]

---
*This document follows AGENTIC_AI_WORKFLOW standards*
*See: docs/AGENTIC_AI_WORKFLOW.md*
EOF

# Create Phase 2 template
cat > docs/phase2/plan_${TIMESTAMP}.md << EOF
## AI_PHASE: MASTER_PLAN
## AI_STATUS: PENDING
## AI_DATE: $(date -Iseconds)
## AI_SESSION: $SESSION_NAME
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Comprehensive implementation plan

# Master Plan

## Session Information
- **Session ID:** $SESSION_NAME
- **Date:** $(date)
- **Prerequisite:** Phase 1 Discovery completed
- **Workflow:** AGENTIC_AI_WORKFLOW

## Goal
[Agent will define clear implementation goal]

## Success Criteria
[Agent will list measurable success criteria]

## Architecture Design
[Agent will describe high-level architecture]

## API Mapping Strategy
[Agent will map external APIs to AROS equivalents]

## Dependencies
[Agent will list all dependencies and how to satisfy them]

## Build Strategy
[Agent will define how to build the software]

## Testing Strategy
[Agent will define how to validate the implementation]

## Risk Assessment
[Agent will identify risks and mitigation strategies]

## Timeline Estimate
[Agent will provide rough effort estimate]

## Next Steps
[Transition to Phase 3: Task Segmentation]

---
*This document follows AGENTIC_AI_WORKFLOW standards*
*See: docs/AGENTIC_AI_WORKFLOW.md*
EOF

# Create Phase 3 template
cat > docs/phase3/tasks_${TIMESTAMP}.md << EOF
## AI_PHASE: TASK_SEGMENTATION
## AI_STATUS: PENDING
## AI_DATE: $(date -Iseconds)
## AI_SESSION: $SESSION_NAME
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Breakdown of work into discrete tasks

# Task List

## Session Information
- **Session ID:** $SESSION_NAME
- **Date:** $(date)
- **Prerequisite:** Phase 2 Master Plan completed
- **Workflow:** AGENTIC_AI_WORKFLOW

## Task Breakdown

### Preparation Tasks
- [ ] Task 1.1: [Description]
- [ ] Task 1.2: [Description]

### Configuration Tasks
- [ ] Task 2.1: [Description]
- [ ] Task 2.2: [Description]

### Core Implementation Tasks
- [ ] Task 3.1: [Description]
- [ ] Task 3.2: [Description]

### Testing Tasks
- [ ] Task 4.1: [Description]
- [ ] Task 4.2: [Description]

### Documentation Tasks
- [ ] Task 5.1: [Description]
- [ ] Task 5.2: [Description]

## Task Dependencies
[Agent will define task order and dependencies]

## Task Details
[Agent will create detail sheets for each task]

## Next Steps
[Transition to Phase 4: Implementation Loop]

---
*This document follows AGENTIC_AI_WORKFLOW standards*
*See: docs/AGENTIC_AI_WORKFLOW.md*
EOF

# Create Phase 4 README
cat > docs/phase4/README.md << EOF
## AI_PHASE: IMPLEMENTATION
## AI_STATUS: PENDING
## AI_DATE: $(date -Iseconds)
## AI_SESSION: $SESSION_NAME
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW

# Implementation Phase

This directory contains implementation iteration logs and build logs.

## Directory Structure
\`\`\`
phase4/
├── README.md                    # This file
├── iteration_001.md            # First iteration log
├── iteration_002.md            # Second iteration log
├── ...
└── build_logs/                 # Build log directory
    ├── build_YYYYMMDD_HHmmss.log
    ├── build_YYYYMMDD_HHmmss_analysis.md
    └── error_analysis_001.md
\`\`\`

## Usage

### Capture Build Logs
\`\`\`bash
./scripts/capture_build.sh "make"
\`\`\`

### Analyze Build Failures
\`\`\`bash
./scripts/analyze_build_log.sh docs/phase4/build_logs/build_YYYYMMDD_HHmmss.log
\`\`\`

### Track Iterations
Create iteration_XXX.md files to document each build/fix cycle.

---
*This directory follows AGENTIC_AI_WORKFLOW standards*
*See: docs/AGENTIC_AI_WORKFLOW.md*
EOF

# Create Phase 5 template
cat > docs/phase5/completion_${TIMESTAMP}.md << EOF
## AI_PHASE: COMPLETION
## AI_STATUS: PENDING
## AI_DATE: $(date -Iseconds)
## AI_SESSION: $SESSION_NAME
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Final validation and documentation

# Completion Phase

## Session Information
- **Session ID:** $SESSION_NAME
- **Date:** $(date)
- **Prerequisite:** Phase 4 Implementation completed
- **Workflow:** AGENTIC_AI_WORKFLOW

## Goal Achievement
[Agent will verify success criteria from Phase 2]

## Final Build Verification
[Agent will document final clean build results]

## Testing Report
[Agent will summarize all test results]

## Known Issues
[Agent will document any remaining issues]

## Documentation Created
[Agent will list all documentation files]

## Code Statistics
[Agent will provide statistics on changes made]

## Lessons Learned
[Agent will document insights gained]

## Future Work
[Agent will suggest optional improvements]

## Project Status
[Agent will declare final status: COMPLETE, PARTIAL, etc.]

---
*This document follows AGENTIC_AI_WORKFLOW standards*
*See: docs/AGENTIC_AI_WORKFLOW.md*
EOF

echo "✅ Directory structure created"
echo ""
echo "Phase Templates Created:"
echo "  📄 docs/phase1/discovery_${TIMESTAMP}.md"
echo "  📄 docs/phase2/plan_${TIMESTAMP}.md"
echo "  📄 docs/phase3/tasks_${TIMESTAMP}.md"
echo "  📄 docs/phase4/README.md"
echo "  📄 docs/phase5/completion_${TIMESTAMP}.md"
echo ""
echo "Helper Scripts Available:"
echo "  🔧 ./scripts/capture_build.sh - Capture build logs with metadata"
echo "  🔍 ./scripts/analyze_build_log.sh - Analyze build failures"
echo "  ✓  ./scripts/validate_metadata.sh - Validate document metadata"
echo ""
echo "Next Steps:"
echo "  1. Start with Phase 1: Edit docs/phase1/discovery_${TIMESTAMP}.md"
echo "  2. Follow AGENTIC_AI_WORKFLOW phases in order"
echo "  3. Use helper scripts for builds and analysis"
echo "  4. Maintain metadata blocks in all documents"
echo ""
echo "Reference: docs/AGENTIC_AI_WORKFLOW.md"
echo "========================================="
