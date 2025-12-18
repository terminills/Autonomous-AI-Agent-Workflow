#!/bin/bash
# AI_SCRIPT: setup_aider.sh
# AI_PURPOSE: Setup and configure Aider for AGENTIC_AI_WORKFLOW
# AI_USAGE: ./scripts/setup_aider.sh
# AI_NOTE: Installs Aider and configures it for the autonomous workflow

set -e

echo "========================================="
echo "Aider Setup for AGENTIC_AI_WORKFLOW"
echo "========================================="
echo ""

# Check Python version
echo "📋 Checking Python version..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is not installed"
    echo "   Please install Python 3.9 or later"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "   Found Python $PYTHON_VERSION"

# Check if pip is available
if ! command -v pip3 &> /dev/null; then
    echo "❌ Error: pip3 is not installed"
    echo "   Please install pip3"
    exit 1
fi

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    echo "   Please run this from your repository root"
    exit 1
fi

echo ""
echo "📦 Installing Aider..."
echo ""

# Install aider-chat
if pip3 install --user aider-chat; then
    echo "✅ Aider installed successfully"
else
    echo "❌ Failed to install Aider"
    echo "   Try: pip3 install --user --upgrade aider-chat"
    exit 1
fi

echo ""
echo "⚙️  Setting up configuration..."

# Check if .aider.conf.yml exists
if [ ! -f ".aider.conf.yml" ]; then
    echo "❌ Error: .aider.conf.yml not found"
    echo "   This file should have been created by the bootstrap"
    exit 1
fi
echo "   ✅ Configuration file found"

# Setup environment file if it doesn't exist
if [ ! -f ".aider.env" ]; then
    echo ""
    echo "📝 Creating .aider.env from template..."
    cp .aider.env.example .aider.env
    echo "   ✅ Created .aider.env"
    echo ""
    echo "⚠️  IMPORTANT: Edit .aider.env and add your API keys!"
    echo "   Required: OPENAI_API_KEY or other LLM provider keys"
    echo "   Run: nano .aider.env (or use your preferred editor)"
    echo ""
else
    echo "   ℹ️  .aider.env already exists"
fi

# Verify aider is in PATH
echo ""
echo "🔍 Verifying installation..."
if command -v aider &> /dev/null; then
    AIDER_VERSION=$(aider --version 2>&1 || echo "unknown")
    echo "   ✅ Aider is available: $AIDER_VERSION"
else
    echo "   ⚠️  Aider command not found in PATH"
    echo "   You may need to add ~/.local/bin to your PATH"
    echo "   Run: export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "   Add this to your ~/.bashrc or ~/.zshrc for persistence"
fi

echo ""
echo "========================================="
echo "✅ Aider Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Edit .aider.env and add your API keys"
echo "2. Read docs/AIDER_INTEGRATION.md for usage guide"
echo "3. Start Aider: aider"
echo "4. Or use the helper: ./scripts/aider_session.sh"
echo ""
echo "Quick test:"
echo "  aider --help"
echo ""
