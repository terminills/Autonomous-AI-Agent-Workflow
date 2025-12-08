#!/bin/bash
# AI_SCRIPT: analyze_build_log.sh
# AI_PURPOSE: Extract and categorize errors from build log for AGENTIC_AI_WORKFLOW
# AI_USAGE: ./scripts/analyze_build_log.sh [log_file]
# AI_NOTE: Creates structured error analysis for AI agent

LOG_FILE=$1

if [ -z "$LOG_FILE" ]; then
    echo "Usage: $0 <build_log_file>"
    echo "Example: $0 docs/phase4/build_logs/build_20231207_143022.log"
    exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found: $LOG_FILE"
    exit 1
fi

# Generate analysis filename
BUILD_ID=$(basename "${LOG_FILE%.log}" | sed 's/build_//')
ANALYSIS_FILE="${LOG_FILE%.log}_analysis.md"
ANALYSIS_NUM=$(ls -1 docs/phase4/build_logs/error_analysis_*.md 2>/dev/null | wc -l)
ANALYSIS_NUM=$((ANALYSIS_NUM + 1))
ANALYSIS_ID=$(printf "%03d" $ANALYSIS_NUM)

cat > "$ANALYSIS_FILE" << EOF
## AI_ERROR_ANALYSIS: ${ANALYSIS_ID}
## AI_BUILD: build_${BUILD_ID}
## AI_DATE: $(date -Iseconds)
## AI_STATUS: ANALYZED
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW

# Build Error Analysis

## Build Information
EOF

# Extract and display metadata from log
echo "" >> "$ANALYSIS_FILE"
grep "^## AI_" "$LOG_FILE" | grep -v "^## AI_ERROR_ANALYSIS" >> "$ANALYSIS_FILE"

# Get error statistics
ERROR_COUNT=$(grep -c "error:" "$LOG_FILE" 2>/dev/null || echo "0")
WARNING_COUNT=$(grep -c "warning:" "$LOG_FILE" 2>/dev/null || echo "0")

echo "" >> "$ANALYSIS_FILE"
echo "## Summary Statistics" >> "$ANALYSIS_FILE"
echo "- **Total Errors:** $ERROR_COUNT" >> "$ANALYSIS_FILE"
echo "- **Total Warnings:** $WARNING_COUNT" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"

echo "## Errors Found" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"

if [ "$ERROR_COUNT" -gt 0 ]; then
    # Extract unique errors
    grep "error:" "$LOG_FILE" | sort -u >> "$ANALYSIS_FILE"
    
    echo "" >> "$ANALYSIS_FILE"
    echo "## Error Categories" >> "$ANALYSIS_FILE"
    echo "" >> "$ANALYSIS_FILE"
    
    # Categorize errors
    if grep -q "No such file or directory" "$LOG_FILE" || grep -q "cannot find" "$LOG_FILE"; then
        echo "- [ ] **Missing Files/Headers**" >> "$ANALYSIS_FILE"
    fi
    
    if grep -q "undeclared" "$LOG_FILE" || grep -q "not declared" "$LOG_FILE"; then
        echo "- [ ] **Undeclared Identifiers**" >> "$ANALYSIS_FILE"
    fi
    
    if grep -q "undefined reference" "$LOG_FILE" || grep -q "unresolved symbol" "$LOG_FILE"; then
        echo "- [ ] **Undefined Symbols/References**" >> "$ANALYSIS_FILE"
    fi
    
    if grep -q "conflicting types" "$LOG_FILE" || grep -q "incompatible" "$LOG_FILE"; then
        echo "- [ ] **Type Conflicts**" >> "$ANALYSIS_FILE"
    fi
    
    if grep -q "syntax error" "$LOG_FILE"; then
        echo "- [ ] **Syntax Errors**" >> "$ANALYSIS_FILE"
    fi
else
    echo "✅ No errors found" >> "$ANALYSIS_FILE"
fi

echo "" >> "$ANALYSIS_FILE"
echo "## Warnings Found (Top 20)" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"

if [ "$WARNING_COUNT" -gt 0 ]; then
    grep "warning:" "$LOG_FILE" | sort -u | head -20 >> "$ANALYSIS_FILE"
else
    echo "✅ No warnings found" >> "$ANALYSIS_FILE"
fi

# Add template for agent analysis
cat >> "$ANALYSIS_FILE" << 'EOF'

---

## AI Agent Analysis Template

### Root Cause Analysis
[Agent should fill in: What is the underlying cause of these errors?]

### Discovery Phase Reference
[Agent should reference relevant Phase 1 documents showing AROS patterns]
- Reference: `docs/phase1/[relevant_document].md`

### Proposed Fix Strategy
[Agent should describe the approach to fix these errors]
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Code Changes Required
[Agent should list specific files and changes needed]
- File: [path]
  - Change: [description]
  
### Testing Plan
[How to verify the fix works]
1. [Test 1]
2. [Test 2]

### Risk Assessment
[Potential issues with the proposed fix]
- Risk: [description]
- Mitigation: [approach]

### Implementation Notes
[Additional context for implementing the fix]

---

**Next Steps for Agent:**
1. Analyze error patterns
2. Reference `docs/AGENTIC_AI_WORKFLOW.md` Phase 4 guidelines
3. Consult Phase 1 discovery for AROS API patterns
4. Implement minimal, targeted fixes
5. Rebuild with `./scripts/capture_build.sh`
6. Commit with AI_COMMIT tag referencing this analysis
EOF

echo ""
echo "========================================="
echo "Build Log Analysis Complete"
echo "========================================="
echo "Analysis saved: $ANALYSIS_FILE"
echo "Errors: $ERROR_COUNT"
echo "Warnings: $WARNING_COUNT"
echo ""
echo "The analysis file includes:"
echo "- Error extraction and categorization"
echo "- Warning summary"
echo "- Template for AI agent to complete"
echo ""
echo "Agent should now:"
echo "1. Review the analysis file"
echo "2. Reference Phase 1 docs for AROS patterns"
echo "3. Implement fixes with AI_COMMIT tags"
echo "4. Rebuild using capture_build.sh"
echo "========================================="
