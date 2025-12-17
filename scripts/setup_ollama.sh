#!/bin/bash
# AI_SCRIPT: setup_ollama.sh
# AI_PURPOSE: Install and configure Ollama with recommended coding models
# AI_USAGE: ./scripts/setup_ollama.sh [model-size]
# AI_NOTE: Installs Ollama and downloads appropriate model based on hardware

set -e

echo "========================================="
echo "Ollama Setup for AGENTIC_AI_WORKFLOW"
echo "========================================="
echo ""

MODEL_SIZE=$1

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
fi

echo "📋 Detected OS: $OS"
echo ""

# Install Ollama
echo "📦 Installing Ollama..."
echo ""

if [ "$OS" = "linux" ]; then
    echo "Installing Ollama for Linux..."
    if command -v ollama &> /dev/null; then
        echo "   ℹ️  Ollama already installed"
    else
        curl -fsSL https://ollama.com/install.sh | sh
        echo "   ✅ Ollama installed"
    fi
    
elif [ "$OS" = "macos" ]; then
    echo "Installing Ollama for macOS..."
    if command -v ollama &> /dev/null; then
        echo "   ℹ️  Ollama already installed"
    else
        if command -v brew &> /dev/null; then
            brew install ollama
            echo "   ✅ Ollama installed via Homebrew"
        else
            echo "   ⚠️  Homebrew not found"
            echo "   Please install from: https://ollama.com/download"
            echo "   Or install Homebrew first: https://brew.sh"
            exit 1
        fi
    fi
    
elif [ "$OS" = "windows" ]; then
    echo "   ⚠️  Windows detected"
    echo "   Please download and install Ollama from:"
    echo "   https://ollama.com/download"
    echo ""
    echo "   After installation, run this script again to download models."
    exit 0
fi

echo ""

# Start Ollama server
echo "🚀 Starting Ollama server..."
if pgrep -x "ollama" > /dev/null; then
    echo "   ✅ Ollama server already running"
else
    ollama serve > /dev/null 2>&1 &
    sleep 3
    echo "   ✅ Ollama server started"
fi

echo ""

# Detect hardware and recommend model
echo "🔍 Detecting hardware..."
TOTAL_RAM=0
GPU_VRAM=0
HAS_GPU=false

if [ "$OS" = "linux" ]; then
    # Get total RAM in GB
    TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    
    # Check for NVIDIA GPU
    if command -v nvidia-smi &> /dev/null; then
        HAS_GPU=true
        GPU_VRAM=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -n1)
        GPU_VRAM=$(echo "scale=0; $GPU_VRAM / 1024" | bc)
        echo "   📊 Detected: ${TOTAL_RAM}GB RAM, ${GPU_VRAM}GB VRAM (NVIDIA)"
    else
        echo "   📊 Detected: ${TOTAL_RAM}GB RAM, no NVIDIA GPU"
    fi
    
elif [ "$OS" = "macos" ]; then
    # Get total RAM in GB
    TOTAL_RAM=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)}')
    echo "   📊 Detected: ${TOTAL_RAM}GB unified memory (Apple Silicon)"
fi

echo ""

# Determine recommended model
RECOMMENDED_MODEL=""
MODEL_NAME=""

if [ -n "$MODEL_SIZE" ]; then
    # User specified model size
    case $MODEL_SIZE in
        light|small|7b)
            RECOMMENDED_MODEL="qwen2.5-coder:7b-instruct"
            MODEL_NAME="Qwen2.5-Coder 7B"
            ;;
        medium|16b)
            RECOMMENDED_MODEL="deepseek-coder-v2:16b-lite-instruct-q8_0"
            MODEL_NAME="DeepSeek-Coder-V2.5 16B"
            ;;
        large|heavy|32b)
            RECOMMENDED_MODEL="qwen2.5-coder:32b-instruct"
            MODEL_NAME="Qwen2.5-Coder 32B"
            ;;
        tiny|6b)
            RECOMMENDED_MODEL="deepseek-coder:6.7b-instruct-q4_K_M"
            MODEL_NAME="DeepSeek-Coder 6.7B"
            ;;
        *)
            echo "❌ Unknown model size: $MODEL_SIZE"
            echo "   Valid options: tiny, light, medium, large"
            exit 1
            ;;
    esac
else
    # Auto-detect based on hardware
    if [ $TOTAL_RAM -ge 32 ] && ([ $GPU_VRAM -ge 20 ] || [ "$OS" = "macos" ]); then
        # High-end hardware
        RECOMMENDED_MODEL="qwen2.5-coder:32b-instruct"
        MODEL_NAME="Qwen2.5-Coder 32B"
        echo "🎯 Recommended model: $MODEL_NAME (high-end hardware)"
        
    elif [ $TOTAL_RAM -ge 24 ] && ([ $GPU_VRAM -ge 12 ] || [ "$OS" = "macos" ]); then
        # Mid-range hardware
        RECOMMENDED_MODEL="deepseek-coder-v2:16b-lite-instruct-q8_0"
        MODEL_NAME="DeepSeek-Coder-V2.5 16B"
        echo "🎯 Recommended model: $MODEL_NAME (mid-range hardware)"
        
    elif [ $TOTAL_RAM -ge 16 ]; then
        # Budget hardware
        RECOMMENDED_MODEL="qwen2.5-coder:7b-instruct"
        MODEL_NAME="Qwen2.5-Coder 7B"
        echo "🎯 Recommended model: $MODEL_NAME (budget hardware)"
        
    else
        # Low-end hardware
        RECOMMENDED_MODEL="deepseek-coder:6.7b-instruct-q4_K_M"
        MODEL_NAME="DeepSeek-Coder 6.7B"
        echo "🎯 Recommended model: $MODEL_NAME (limited hardware)"
    fi
fi

echo ""
echo "========================================="
echo "Downloading Model: $MODEL_NAME"
echo "========================================="
echo ""
echo "This may take several minutes depending on your internet speed..."
echo "Model size: ~4-20GB depending on quantization"
echo ""

# Download model
if ollama pull $RECOMMENDED_MODEL; then
    echo ""
    echo "   ✅ Model downloaded successfully"
else
    echo ""
    echo "   ❌ Failed to download model"
    echo "   Please check your internet connection and try again"
    exit 1
fi

echo ""
echo "🧪 Testing model..."
if ollama run $RECOMMENDED_MODEL "Write a hello world function in C" > /dev/null 2>&1; then
    echo "   ✅ Model working correctly"
else
    echo "   ⚠️  Model test failed, but may still work"
fi

echo ""
echo "========================================="
echo "✅ Ollama Setup Complete!"
echo "========================================="
echo ""
echo "Installed model: $MODEL_NAME"
echo "Model ID: $RECOMMENDED_MODEL"
echo ""
echo "Configuration:"
echo "  Server: http://127.0.0.1:11434"
echo "  Status: $(pgrep -x "ollama" > /dev/null && echo "Running" || echo "Stopped")"
echo ""
echo "Next steps:"
echo "1. Configure Aider to use this model"
echo "2. Edit .aider.conf.yml and set:"
echo "   model: ollama/$RECOMMENDED_MODEL"
echo "3. Start coding with: aider"
echo ""
echo "Useful commands:"
echo "  ollama list              # List installed models"
echo "  ollama ps                # Show running models"
echo "  ollama pull <model>      # Download another model"
echo "  ollama rm <model>        # Remove a model"
echo "  ollama serve             # Start server manually"
echo ""
echo "Documentation:"
echo "  Local Models Guide: docs/LOCAL_MODELS_GUIDE.md"
echo "  Aider Integration: docs/AIDER_INTEGRATION.md"
echo ""

# Update .aider.conf.yml if it exists
if [ -f ".aider.conf.yml" ]; then
    echo "💡 Tip: Your .aider.conf.yml has been detected."
    echo "   Edit it to use: ollama/$RECOMMENDED_MODEL"
    echo ""
fi

# Create/update .aider.env if needed
if [ ! -f ".aider.env" ]; then
    echo "📝 Creating .aider.env..."
    cp .aider.env.example .aider.env
    echo "   ✅ Created .aider.env"
    echo "   Review and customize if needed"
    echo ""
fi

echo "Happy coding! 🚀"
