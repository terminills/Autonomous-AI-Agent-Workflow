#!/bin/bash
# Bootstrap installation script

set -e

echo "========================================="
echo "Installing Autonomous Agent Bootstrap"
echo "========================================="

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    echo "   Please run this from your AROS repository root"
    exit 1
fi

echo "📦 Installing files..."

# Install documentation
echo "  - Documentation"
mkdir -p docs
cp -r docs/* ../docs/ 2>/dev/null || cp -r docs/* docs/

# Install scripts
echo "  - Scripts"
mkdir -p scripts
cp scripts/*.sh scripts/
chmod +x scripts/capture_build.sh
chmod +x scripts/analyze_build_log.sh
chmod +x scripts/validate_metadata.sh
chmod +x scripts/create_phase_structure.sh

# Install issue templates
echo "  - Issue templates"
mkdir -p .github/ISSUE_TEMPLATE
cp .github/ISSUE_TEMPLATE/*.md .github/ISSUE_TEMPLATE/

# Install root documentation
echo "  - Root documentation"
cp DOCUMENTATION_GUIDE.md .
cp BOOTSTRAP_AUTONOMOUS_AGENT.md .

echo ""
echo "✅ Installation complete!"
echo ""
echo "========================================="
echo "Optional: Setup Local Coding with Aider"
echo "========================================="
echo ""
echo "For local AI-powered coding (zero cost, full privacy):"
echo "1. Run: ./scripts/setup_ollama.sh"
echo "2. Run: ./scripts/setup_aider.sh"
echo "3. Read: AIDER_QUICKSTART.md"
echo ""
echo "Or skip Aider setup and use GitHub Copilot only."
echo ""
echo "========================================="
echo "Next steps:"
echo "========================================="
echo "1. Read BOOTSTRAP_AUTONOMOUS_AGENT.md"
echo "2. (Optional) Setup Aider for local coding"
echo "3. Commit these files to your repository"
echo "4. Create your first issue using the Agent Task template"
echo ""
echo "Quick start:"
echo "  git checkout -b feature/autonomous-agent-bootstrap"
echo "  git add docs/ scripts/ .github/ .aider.conf.yml .aider.env.example .gitignore *.md"
echo "  git commit -m 'Add AGENTIC_AI_WORKFLOW with Aider support'"
echo "  git push -u origin feature/autonomous-agent-bootstrap"
echo ""
echo "IMPORTANT: .aider.env is NOT committed (contains secrets)"
echo ""
