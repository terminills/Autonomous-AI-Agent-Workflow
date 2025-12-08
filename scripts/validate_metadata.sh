#!/bin/bash
# AI_SCRIPT: validate_metadata.sh
# AI_PURPOSE: Validate metadata in AI-generated documents for AGENTIC_AI_WORKFLOW
# AI_USAGE: ./scripts/validate_metadata.sh [file_or_directory]
# AI_NOTE: Ensures all AI documents follow metadata standards

TARGET=$1

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <file_or_directory>"
    echo "Example: $0 docs/phase1/discovery_20231207.md"
    echo "Example: $0 docs/"
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

# Phase-specific fields
TASK_FIELDS=(
    "AI_TASK"
    "AI_PRIORITY"
)

BUILD_FIELDS=(
    "AI_BUILD"
    "AI_ERRORS"
    "AI_WARNINGS"
)

validate_file() {
    local file=$1
    local missing_required=()
    local missing_recommended=()
    local has_issues=0
    
    # Skip non-markdown files
    if [[ ! "$file" =~ \.md$ ]]; then
        return
    fi
    
    # Skip README files (they might not need metadata)
    if [[ "$file" =~ README\.md$ ]]; then
        return
    fi
    
    # Check if file has any AI metadata
    if ! grep -q "^## AI_" "$file"; then
        echo "⚠️  $file - No AI metadata found (might not be an AI document)"
        return
    fi
    
    # Check required fields
    for field in "${REQUIRED_FIELDS[@]}"; do
        if ! grep -q "^## $field:" "$file"; then
            missing_required+=("$field")
            has_issues=1
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
        if [ ${#missing_recommended[@]} -eq 0 ]; then
            echo "✅ $file - Valid metadata (all fields present)"
        else
            echo "✅ $file - Valid metadata (required fields present)"
            echo "   ℹ️  Missing recommended fields: ${missing_recommended[*]}"
        fi
    else
        echo "❌ $file - Missing required fields: ${missing_required[*]}"
        has_issues=1
    fi
    
    # Check for valid AI_PHASE values
    if grep -q "^## AI_PHASE:" "$file"; then
        phase=$(grep "^## AI_PHASE:" "$file" | head -1 | sed 's/^## AI_PHASE: *//')
        case "$phase" in
            DISCOVERY|MASTER_PLAN|TASK_SEGMENTATION|IMPLEMENTATION|COMPLETION|AUTONOMOUS_AGENT_DOCUMENTATION)
                # Valid phase
                ;;
            *)
                echo "   ⚠️  Invalid AI_PHASE value: '$phase'"
                echo "       Valid values: DISCOVERY, MASTER_PLAN, TASK_SEGMENTATION, IMPLEMENTATION, COMPLETION"
                has_issues=1
                ;;
        esac
    fi
    
    # Check for valid AI_STATUS values
    if grep -q "^## AI_STATUS:" "$file"; then
        status=$(grep "^## AI_STATUS:" "$file" | head -1 | sed 's/^## AI_STATUS: *//')
        case "$status" in
            PENDING|IN_PROGRESS|BLOCKED|COMPLETE|FAILED|ANALYZED|SUCCESS|ENHANCED)
                # Valid status
                ;;
            *)
                echo "   ⚠️  Invalid AI_STATUS value: '$status'"
                echo "       Valid values: PENDING, IN_PROGRESS, BLOCKED, COMPLETE, FAILED, ANALYZED, SUCCESS"
                has_issues=1
                ;;
        esac
    fi
    
    return $has_issues
}

# Statistics
total_files=0
valid_files=0
invalid_files=0

echo "========================================="
echo "AI Metadata Validation"
echo "========================================="
echo "Target: $TARGET"
echo "Workflow: AGENTIC_AI_WORKFLOW"
echo ""

if [ -f "$TARGET" ]; then
    validate_file "$TARGET"
    result=$?
    total_files=1
    if [ $result -eq 0 ]; then
        valid_files=1
    else
        invalid_files=1
    fi
elif [ -d "$TARGET" ]; then
    while IFS= read -r file; do
        validate_file "$file"
        result=$?
        total_files=$((total_files + 1))
        if [ $result -eq 0 ]; then
            valid_files=$((valid_files + 1))
        else
            invalid_files=$((invalid_files + 1))
        fi
    done < <(find "$TARGET" -name "*.md" -type f | sort)
else
    echo "Error: $TARGET is not a file or directory"
    exit 1
fi

echo ""
echo "========================================="
echo "Validation Summary"
echo "========================================="
echo "Total files checked: $total_files"
echo "Valid metadata: $valid_files"
echo "Invalid metadata: $invalid_files"
echo ""

if [ $invalid_files -eq 0 ]; then
    echo "✅ All files have valid metadata"
    exit 0
else
    echo "⚠️  Some files have missing or invalid metadata"
    echo "    Please update them to follow AGENTIC_AI_WORKFLOW standards"
    exit 1
fi
