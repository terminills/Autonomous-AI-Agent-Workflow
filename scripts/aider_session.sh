#!/bin/bash
# AI_SCRIPT: aider_session.sh
# AI_PURPOSE: Start an Aider session with AGENTIC_AI_WORKFLOW context
# AI_USAGE: ./scripts/aider_session.sh [project-name] [phase]
# AI_NOTE: Wrapper for Aider that loads appropriate context for current phase

set -e

PROJECT=$1
PHASE=$2

echo "========================================="
echo "Starting Aider Session"
echo "========================================="

# Check if aider is installed
if ! command -v aider &> /dev/null; then
    echo "❌ Error: Aider is not installed"
    echo "   Run: ./scripts/setup_aider.sh"
    exit 1
fi

# Check if .aider.env exists
if [ ! -f ".aider.env" ]; then
    echo "⚠️  Warning: .aider.env not found"
    echo "   Using .aider.conf.yml configuration only"
    echo "   You may need to set API keys as environment variables"
fi

# Build context files list
CONTEXT_FILES=(
    "docs/AGENTIC_AI_WORKFLOW.md"
    "DOCUMENTATION_GUIDE.md"
)

# Add project-specific context if provided
if [ -n "$PROJECT" ]; then
    echo "📁 Project: $PROJECT"
    
    if [ -d "docs/$PROJECT" ]; then
        # Add project README if it exists
        if [ -f "docs/$PROJECT/README.md" ]; then
            CONTEXT_FILES+=("docs/$PROJECT/README.md")
        fi
        
        # Add phase-specific context if provided
        if [ -n "$PHASE" ]; then
            echo "📋 Phase: $PHASE"
            if [ -d "docs/$PROJECT/phases/$PHASE" ]; then
                # Find the latest phase document
                LATEST_DOC=$(find "docs/$PROJECT/phases/$PHASE" -name "*.md" -type f | sort -r | head -n 1)
                if [ -n "$LATEST_DOC" ]; then
                    CONTEXT_FILES+=("$LATEST_DOC")
                    echo "📄 Loading: $LATEST_DOC"
                fi
            fi
        fi
    else
        echo "⚠️  Project directory not found: docs/$PROJECT"
        echo "   Starting without project-specific context"
    fi
fi

echo ""
echo "🚀 Launching Aider with AGENTIC_AI_WORKFLOW context..."
echo ""
echo "Context files loaded:"
for file in "${CONTEXT_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ⚠️  $file (not found)"
    fi
done

echo ""
echo "========================================="
echo "Aider Tips:"
echo "========================================="
echo "• /help - Show available commands"
echo "• /add <file> - Add file to context"
echo "• /drop <file> - Remove file from context"
echo "• /commit - Commit changes"
echo "• /undo - Undo last change"
echo "• /exit - Exit Aider"
echo ""
echo "AGENTIC_AI_WORKFLOW Tips:"
echo "• Use AI_COMMIT format in commit messages"
echo "• Reference phase documents for context"
echo "• Follow the 5-phase workflow structure"
echo "• Update metadata in documentation"
echo "========================================="
echo ""

# Build aider command as array to avoid command injection
AIDER_CMD=(aider)

# Add context files
for file in "${CONTEXT_FILES[@]}"; do
    if [ -f "$file" ]; then
        AIDER_CMD+=(--read "$file")
    fi
done

# Add message if provided (safely)
if [ -n "$3" ]; then
    MESSAGE="$3"
    echo "📝 Message: $MESSAGE"
    echo ""
    AIDER_CMD+=(--message "$MESSAGE")
fi

# Execute aider (no eval needed, array expansion is safe)
"${AIDER_CMD[@]}"
