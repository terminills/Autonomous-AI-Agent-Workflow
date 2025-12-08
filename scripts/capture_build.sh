#!/bin/bash
# AI_SCRIPT: capture_build.sh
# AI_PURPOSE: Capture build output with metadata for AGENTIC_AI_WORKFLOW
# AI_USAGE: ./scripts/capture_build.sh [build_command]
# AI_NOTE: Part of autonomous agent workflow system

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
echo "## AI_BRANCH: $(git branch --show-current 2>/dev/null || echo 'unknown')" >> "$LOG_FILE"
echo "## AI_COMMIT: $(git rev-parse HEAD 2>/dev/null || echo 'unknown')" >> "$LOG_FILE"
echo "## AI_WORKFLOW: AGENTIC_AI_WORKFLOW" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Run build and capture output
echo "Starting build..."
echo "Command: $@"
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
ERROR_COUNT=$(grep -c "error:" "$LOG_FILE" 2>/dev/null || echo "0")
WARNING_COUNT=$(grep -c "warning:" "$LOG_FILE" 2>/dev/null || echo "0")

echo "## AI_ERRORS: $ERROR_COUNT" >> "$LOG_FILE"
echo "## AI_WARNINGS: $WARNING_COUNT" >> "$LOG_FILE"

echo ""
echo "========================================="
echo "Build Capture Summary"
echo "========================================="
echo "Build log saved: $LOG_FILE"
echo "Status: $BUILD_STATUS"
echo "Errors: $ERROR_COUNT"
echo "Warnings: $WARNING_COUNT"
echo "Exit Code: $EXIT_CODE"
echo "========================================="

# If build failed, suggest next steps
if [ "$BUILD_STATUS" = "FAILED" ]; then
    echo ""
    echo "Next steps for AI agent:"
    echo "1. Run: ./scripts/analyze_build_log.sh $LOG_FILE"
    echo "2. Review error analysis"
    echo "3. Reference docs/phase1/ for AROS patterns"
    echo "4. Implement fixes with AI_COMMIT tags"
    echo "5. Rebuild with this script"
fi

exit $EXIT_CODE
