# Local Models Guide for AGENTIC_AI_WORKFLOW

## AI_PHASE: DOCUMENTATION
## AI_STATUS: COMPLETE
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Comprehensive guide for using local LLMs with Aider and the autonomous workflow
## AI_VERSION: 1.0

---

## Table of Contents

1. [Overview](#overview)
2. [Why Local Models?](#why-local-models)
3. [Recommended Models for Coding](#recommended-models-for-coding)
4. [Hardware Requirements](#hardware-requirements)
5. [Setup Options](#setup-options)
6. [Ollama Setup (Recommended)](#ollama-setup-recommended)
7. [LM Studio Setup (Alternative)](#lm-studio-setup-alternative)
8. [Aider Configuration for Local Models](#aider-configuration-for-local-models)
9. [Model Selection Strategy](#model-selection-strategy)
10. [Performance Optimization](#performance-optimization)
11. [Troubleshooting](#troubleshooting)
12. [Cost Comparison](#cost-comparison)

---

## Overview

This guide helps you set up and use **local LLM models** with Aider for the AGENTIC_AI_WORKFLOW. Running models locally provides:

✅ **Zero API costs** - No per-token charges
✅ **Complete privacy** - Your code never leaves your machine
✅ **Offline capability** - Work without internet
✅ **Full control** - Choose models, tune performance
✅ **Unlimited usage** - No rate limits or quotas

---

## Why Local Models?

### Privacy & Security
- **Your code stays local** - No data sent to external APIs
- **Perfect for proprietary code** - Enterprise-safe
- **GDPR/compliance friendly** - Data sovereignty

### Cost Savings
- **No API fees** - Initial GPU investment only
- **Unlimited usage** - Code 24/7 without additional cost
- **Team scale** - Multiple developers use same hardware

### Performance
- **Low latency** - Responses in seconds on good hardware
- **Consistent speed** - No network variability
- **Always available** - No API downtime

### Flexibility
- **Model choice** - Switch models based on task
- **Custom fine-tuning** - Adapt models to your codebase
- **Version control** - Lock model versions for consistency

---

## Recommended Models for Coding

### Tier 1: Best Overall (High-End Hardware)

#### 1. **Qwen2.5-Coder 32B** ⭐ BEST CHOICE
```bash
# Pull model
ollama pull qwen2.5-coder:32b-instruct

# Use with Aider
aider --model ollama/qwen2.5-coder:32b-instruct
```

**Specs:**
- **HumanEval Score:** 88.4% (matches GPT-4)
- **Context:** 131K tokens
- **Memory:** 20-24GB VRAM
- **Languages:** 100+ languages
- **Special:** Fill-in-the-middle, repo-level understanding

**Best for:**
- Large codebases
- Multi-file refactoring
- Complex algorithms
- Production code quality

---

#### 2. **DeepSeek-Coder-V2.5 16B** ⭐ HIGH PERFORMANCE
```bash
# Pull model
ollama pull deepseek-coder-v2:16b-lite-instruct-q8_0

# Use with Aider
aider --model ollama/deepseek-coder-v2:16b-lite-instruct-q8_0
```

**Specs:**
- **HumanEval Score:** 81.1%
- **Context:** 128K tokens
- **Memory:** 16-18GB VRAM
- **Languages:** 300+ languages
- **Special:** Math reasoning, fill-in-the-middle

**Best for:**
- Mathematical algorithms
- Multi-language projects
- Performance-critical code
- API porting (POSIX → AROS)

---

### Tier 2: Balanced Performance (Mid-Range Hardware)

#### 3. **Qwen2.5-Coder 7B** ⭐ BEST BUDGET
```bash
ollama pull qwen2.5-coder:7b-instruct
aider --model ollama/qwen2.5-coder:7b-instruct
```

**Specs:**
- **HumanEval Score:** 88.4%
- **Context:** 131K tokens
- **Memory:** 8-10GB VRAM
- **Performance:** Excellent for size

**Best for:**
- Laptops with 16GB RAM
- Quick edits and bug fixes
- Learning and experimentation
- Most AGENTIC_AI_WORKFLOW tasks

---

#### 4. **CodeLlama 34B** (Classic Choice)
```bash
ollama pull codellama:34b-instruct
aider --model ollama/codellama:34b-instruct
```

**Specs:**
- **HumanEval Score:** 77-80%
- **Context:** 100K tokens
- **Memory:** 20GB VRAM
- **Maturity:** Very stable, well-tested

**Best for:**
- Production environments
- C/C++ development
- Debugging and analysis
- Legacy code understanding

---

### Tier 3: Lightweight (Low-End Hardware)

#### 5. **DeepSeek-Coder 6.7B** (Laptop-Friendly)
```bash
ollama pull deepseek-coder:6.7b-instruct-q4_K_M
aider --model ollama/deepseek-coder:6.7b-instruct-q4_K_M
```

**Specs:**
- **Memory:** 4-6GB VRAM
- **Context:** 16K tokens
- **Speed:** Fast inference

**Best for:**
- Laptops without GPU
- Simple bug fixes
- Quick prototyping
- Low-power systems

---

#### 6. **CodeLlama 13B**
```bash
ollama pull codellama:13b-instruct
aider --model ollama/codellama:13b-instruct
```

**Specs:**
- **Memory:** 8GB VRAM
- **Context:** 100K tokens
- **Reliability:** Very stable

**Best for:**
- 16GB RAM systems
- Standard coding tasks
- Good balance of speed/quality

---

### Comparison Table

| Model | Size | VRAM | HumanEval | Context | Best Use Case |
|-------|------|------|-----------|---------|---------------|
| **Qwen2.5-Coder 32B** | 32B | 20-24GB | 88.4% | 131K | Large projects, refactoring |
| **DeepSeek-Coder-V2.5 16B** | 16B | 16-18GB | 81.1% | 128K | Math, multi-language |
| **Qwen2.5-Coder 7B** | 7B | 8-10GB | 88.4% | 131K | **Best budget choice** |
| **CodeLlama 34B** | 34B | 20GB | 77-80% | 100K | Stable, production |
| **DeepSeek-Coder 6.7B** | 6.7B | 4-6GB | ~70% | 16K | Laptops, quick edits |
| **CodeLlama 13B** | 13B | 8GB | ~70% | 100K | Balanced performance |

---

## Hardware Requirements

### Minimum Specs (Entry Level)
```
CPU: 4+ cores (modern Intel/AMD/Apple M-series)
RAM: 16GB
Storage: 10GB free (for models)
OS: Linux, macOS, Windows 10+
```
**Recommended models:** DeepSeek 6.7B, CodeLlama 13B

---

### Recommended Specs (Sweet Spot)
```
CPU: 8+ cores
RAM: 32GB
GPU: NVIDIA RTX 3060 (12GB VRAM) or better
      OR Apple M2/M3 with 16GB+ unified memory
Storage: 50GB SSD
OS: Linux (best performance) or macOS
```
**Recommended models:** Qwen2.5-Coder 7B, DeepSeek-Coder-V2.5 16B

---

### High-End Specs (Maximum Performance)
```
CPU: 16+ cores
RAM: 64GB+
GPU: NVIDIA RTX 4090 (24GB VRAM)
     OR NVIDIA A6000 (48GB VRAM)
     OR Apple M3 Max with 64GB+ unified memory
Storage: 100GB+ NVMe SSD
OS: Linux (Ubuntu 22.04+ recommended)
```
**Recommended models:** Qwen2.5-Coder 32B, DeepSeek-Coder-V2.5 16B, CodeLlama 70B

---

### Apple Silicon Performance

**M1/M2/M3 Series** are excellent for local LLMs:
- Unified memory architecture = efficient
- Metal GPU acceleration = fast
- Low power consumption
- Excellent for 7B-13B models
- M3 Max/Ultra can handle 32B models

**Recommendations:**
- **M1/M2 8GB**: DeepSeek 6.7B only
- **M1/M2 16GB**: Qwen2.5-Coder 7B, CodeLlama 13B
- **M2/M3 24GB**: DeepSeek-Coder-V2.5 16B
- **M3 Max 48GB+**: Qwen2.5-Coder 32B, CodeLlama 34B

---

## Setup Options

### Option 1: Ollama (Recommended) ⭐

**Pros:**
- Command-line interface (developer-friendly)
- Easy model management
- Docker support
- Scriptable and automatable
- Great for CI/CD integration
- Minimal resource overhead

**Best for:**
- Developers comfortable with CLI
- Production environments
- Team/enterprise use
- Integration with Aider

---

### Option 2: LM Studio (Alternative)

**Pros:**
- Graphical interface (user-friendly)
- Visual resource monitoring
- Easy model switching
- No CLI knowledge required
- Great for experimentation

**Best for:**
- GUI preference
- Beginners
- Quick prototyping
- Model evaluation

---

## Ollama Setup (Recommended)

### Installation

#### Linux
```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Start server (runs in background)
ollama serve
```

#### macOS
```bash
# Using Homebrew
brew install ollama

# Or download from https://ollama.com/download

# Start server
ollama serve
```

#### Windows
```powershell
# Download installer from https://ollama.com/download
# Run installer
# Ollama runs as Windows service automatically
```

---

### Model Installation

```bash
# Check Ollama is running
ollama list

# Pull recommended model for your hardware
# Choose based on Hardware Requirements section above

# Budget (8GB VRAM)
ollama pull qwen2.5-coder:7b-instruct

# Mid-range (16GB VRAM)
ollama pull deepseek-coder-v2:16b-lite-instruct-q8_0

# High-end (24GB VRAM)
ollama pull qwen2.5-coder:32b-instruct

# Verify installation
ollama list
```

---

### Configuration

#### 1. Set Ollama Environment Variables

Create/edit `~/.ollama/config` or set in shell:

```bash
# Basic configuration
export OLLAMA_HOST=127.0.0.1:11434
export OLLAMA_ORIGINS="http://localhost:*"

# Performance tuning
export OLLAMA_NUM_PARALLEL=1        # Number of parallel requests
export OLLAMA_MAX_LOADED_MODELS=1   # Keep only 1 model in memory
export OLLAMA_KEEP_ALIVE=5m         # Keep model loaded for 5 minutes

# Context size (adjust based on model)
export OLLAMA_NUM_CTX=8192          # Default: 2048

# GPU configuration (if applicable)
export OLLAMA_NUM_GPU=1             # Number of GPUs to use
export OLLAMA_GPU_LAYERS=35         # Number of layers on GPU
```

Add to `~/.bashrc` or `~/.zshrc` for persistence:
```bash
echo 'export OLLAMA_HOST=127.0.0.1:11434' >> ~/.bashrc
echo 'export OLLAMA_NUM_CTX=8192' >> ~/.bashrc
source ~/.bashrc
```

#### 2. Create Modelfile for Custom Configuration

For advanced configuration, create a Modelfile:

```bash
# Create Modelfile for Qwen2.5-Coder
cat > Modelfile.qwen << EOF
FROM qwen2.5-coder:7b-instruct

# Set parameters
PARAMETER temperature 0.1
PARAMETER top_p 0.9
PARAMETER top_k 40
PARAMETER num_ctx 8192
PARAMETER num_predict 2048

# System message for coding
SYSTEM """
You are an expert coding assistant working with the AGENTIC_AI_WORKFLOW system.
Follow these guidelines:
1. Write clean, well-documented code
2. Use AI_PHASE and AI_COMMIT metadata when appropriate
3. Prefer AROS native APIs over POSIX when porting code
4. Include comprehensive error handling
5. Follow existing code patterns in the repository
"""
EOF

# Create custom model
ollama create qwen-agentic -f Modelfile.qwen

# Use it
aider --model ollama/qwen-agentic
```

---

### Testing Ollama

```bash
# Test model is working
ollama run qwen2.5-coder:7b-instruct "Write a hello world in C"

# Check API endpoint
curl http://127.0.0.1:11434/api/generate -d '{
  "model": "qwen2.5-coder:7b-instruct",
  "prompt": "Write a function to reverse a string in C"
}'

# List running models
ollama ps

# Monitor resource usage
ollama logs
```

---

## LM Studio Setup (Alternative)

### Installation

1. Download LM Studio from https://lmstudio.ai/
2. Install for your platform (Windows, macOS, Linux)
3. Launch LM Studio

### Model Installation

1. Click "Search" tab
2. Search for: `qwen2.5-coder` or `deepseek-coder`
3. Download GGUF quantized version (Q4_K_M or Q8_0)
4. Models save to `~/.cache/lm-studio/models/`

### Configuration

1. Click "Local Server" tab
2. Select your downloaded model
3. Configure:
   - **Context Length:** 8192 or higher
   - **GPU Offload:** Max (if you have GPU)
   - **Temperature:** 0.1 (for coding)
4. Click "Start Server"
5. Server runs on `http://127.0.0.1:1234`

### Testing LM Studio

```bash
# Test API endpoint
curl http://127.0.0.1:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5-coder",
    "messages": [
      {"role": "user", "content": "Write hello world in C"}
    ]
  }'
```

---

## Aider Configuration for Local Models

### Update .aider.conf.yml

```yaml
# Primary model (choose based on your hardware)
model: ollama/qwen2.5-coder:7b-instruct

# Fast model for simple edits
editor-model: ollama/qwen2.5-coder:7b-instruct

# Ollama API configuration
api-base: http://127.0.0.1:11434

# Git settings (same as before)
auto-commits: true
dirty-commits: true

# Context
read:
  - docs/AGENTIC_AI_WORKFLOW.md
  - DOCUMENTATION_GUIDE.md

# Codebase mapping
map-tokens: 2048
map-refresh: auto

# Quality
lint: true
auto-test: false

# Output
pretty: true
show-diffs: true
stream: true
```

### Update .aider.env

```bash
# Ollama configuration
OLLAMA_API_BASE=http://127.0.0.1:11434

# For LM Studio (alternative)
# OPENAI_API_BASE=http://127.0.0.1:1234/v1

# No API keys needed for local models!
```

---

## Model Selection Strategy

### By Task Complexity

#### Simple Tasks (Bug fixes, small edits)
```bash
# Use lightweight model for speed
aider --model ollama/qwen2.5-coder:7b-instruct \
      --message "Fix the NULL pointer check on line 45"
```

#### Medium Tasks (Feature implementation)
```bash
# Use balanced model
aider --model ollama/qwen2.5-coder:7b-instruct
# Or for better quality:
aider --model ollama/deepseek-coder-v2:16b-lite-instruct-q8_0
```

#### Complex Tasks (Refactoring, architecture)
```bash
# Use best model
aider --model ollama/qwen2.5-coder:32b-instruct
```

---

### By Hardware Available

Create model aliases in your shell:

```bash
# Add to ~/.bashrc or ~/.zshrc

# Light model (laptop, 16GB RAM)
alias aider-light='aider --model ollama/qwen2.5-coder:7b-instruct'

# Medium model (desktop, 24GB RAM)
alias aider-medium='aider --model ollama/deepseek-coder-v2:16b-lite-instruct-q8_0'

# Heavy model (workstation, 32GB+ RAM)
alias aider-heavy='aider --model ollama/qwen2.5-coder:32b-instruct'

# Use them:
# aider-light src/simple_fix.c
# aider-heavy src/complex_refactor.c
```

---

## Performance Optimization

### 1. Quantization

Use appropriately quantized models:

```bash
# Q4_K_M - 4-bit (fastest, lowest quality)
ollama pull qwen2.5-coder:7b-instruct-q4_K_M

# Q8_0 - 8-bit (balanced)
ollama pull qwen2.5-coder:7b-instruct-q8_0

# FP16 - 16-bit (best quality, slowest)
ollama pull qwen2.5-coder:7b-instruct-fp16
```

**Recommendation:** Q8_0 for best quality/speed balance

---

### 2. Context Window Optimization

```bash
# Small context (faster, less memory)
export OLLAMA_NUM_CTX=4096
aider

# Medium context (balanced)
export OLLAMA_NUM_CTX=8192
aider

# Large context (for big files)
export OLLAMA_NUM_CTX=16384
aider
```

---

### 3. GPU Acceleration

```bash
# Linux: Check GPU usage
nvidia-smi

# Optimize GPU layers
export OLLAMA_NUM_GPU=1
export OLLAMA_GPU_LAYERS=35  # Adjust based on VRAM

# macOS: Metal acceleration (automatic)
# No configuration needed on Apple Silicon
```

---

### 4. Memory Management

```bash
# Keep only 1 model loaded
export OLLAMA_MAX_LOADED_MODELS=1

# Unload model after 5 minutes
export OLLAMA_KEEP_ALIVE=5m

# Or keep loaded indefinitely
export OLLAMA_KEEP_ALIVE=-1
```

---

### 5. Batch Processing

For multiple files:

```bash
# Process files sequentially (lower memory)
for file in src/*.c; do
    aider --model ollama/qwen2.5-coder:7b-instruct \
          --yes \
          --message "Add error handling" \
          "$file"
done

# Or use Aider's multi-file mode (higher memory)
aider --model ollama/qwen2.5-coder:7b-instruct \
      src/*.c
```

---

## Troubleshooting

### Problem: Ollama not found

```bash
# Check installation
which ollama

# Install if missing (Linux/macOS)
curl -fsSL https://ollama.com/install.sh | sh

# macOS Homebrew
brew install ollama
```

---

### Problem: Model not found

```bash
# List available models
ollama list

# Pull the model
ollama pull qwen2.5-coder:7b-instruct

# Verify
ollama list
```

---

### Problem: Connection refused

```bash
# Start Ollama server
ollama serve

# Check it's running
curl http://127.0.0.1:11434/api/version

# Check firewall
sudo ufw allow 11434  # Linux
```

---

### Problem: Out of memory

```bash
# Use smaller model
aider --model ollama/deepseek-coder:6.7b-instruct-q4_K_M

# Reduce context
export OLLAMA_NUM_CTX=2048

# Unload other models
ollama stop qwen2.5-coder:32b-instruct

# Check memory usage
ollama ps
```

---

### Problem: Slow inference

```bash
# Check GPU is being used (Linux)
nvidia-smi

# Increase GPU layers
export OLLAMA_GPU_LAYERS=40

# Use quantized model
ollama pull qwen2.5-coder:7b-instruct-q4_K_M

# Reduce context size
export OLLAMA_NUM_CTX=4096
```

---

### Problem: Poor code quality

```bash
# Use larger model
aider --model ollama/qwen2.5-coder:32b-instruct

# Lower temperature (more focused)
# Create custom Modelfile with temperature 0.1

# Provide more context
aider --read docs/AGENTIC_AI_WORKFLOW.md \
      --read docs/phase1/discovery_*.md \
      src/file.c
```

---

## Cost Comparison

### Cloud API Costs (GPT-4o)

```
Input:  $2.50 per 1M tokens
Output: $10.00 per 1M tokens

Typical coding session (10,000 tokens in/out):
= (10K × $2.50/1M) + (10K × $10/1M)
= $0.025 + $0.10
= $0.125 per session

100 sessions/month = $12.50/month
1000 sessions/month = $125/month
```

---

### Local Model Costs

```
Hardware (one-time):
- RTX 3060 12GB: $300-400
- RTX 4090 24GB: $1600-2000
- Apple M3 Max 48GB: $3500+

Electricity (ongoing):
- GPU at 200W, $0.12/kWh
- 8 hours/day = 1.6 kWh = $0.19/day
- Monthly: ~$6/month

Break-even vs GPT-4o:
- Light use (100 sessions/month): ~2-3 months
- Heavy use (1000 sessions/month): <1 month
- Team (5 devs, 1000 sessions each): <1 week
```

**Conclusion:** Local models pay for themselves quickly with moderate usage.

---

## Recommended Setup by Use Case

### Solo Developer, Laptop
```yaml
Hardware: MacBook Pro M2 16GB or Laptop with 16GB RAM
Model: ollama/qwen2.5-coder:7b-instruct
Setup: Ollama
Cost: $0 (using existing hardware)
```

### Professional Developer, Desktop
```yaml
Hardware: Desktop with RTX 3060 (12GB) or M3 24GB
Model: ollama/deepseek-coder-v2:16b-lite-instruct-q8_0
Setup: Ollama
Cost: ~$400 GPU + $6/month electricity
```

### Team, Dedicated Server
```yaml
Hardware: Workstation with RTX 4090 (24GB) or A6000 (48GB)
Model: ollama/qwen2.5-coder:32b-instruct
Setup: Ollama with Docker, shared API
Cost: ~$2000 GPU + $15/month electricity
ROI: <1 month with 5+ developers
```

---

## Summary

**Best Local Model Recommendations:**

1. **Budget/Laptop:** Qwen2.5-Coder 7B (8GB VRAM) ⭐
2. **Mid-Range:** DeepSeek-Coder-V2.5 16B (16GB VRAM) ⭐
3. **High-End:** Qwen2.5-Coder 32B (24GB VRAM) ⭐

**Setup Tool:** Ollama (recommended for developers) ⭐

**Key Benefits:**
- ✅ Zero ongoing costs
- ✅ Complete privacy
- ✅ Offline capable
- ✅ Unlimited usage
- ✅ Fast local inference

**Next Steps:**
1. Check your hardware specs
2. Install Ollama
3. Pull recommended model for your hardware
4. Configure Aider with local model
5. Start coding!

---

## Further Reading

- **Ollama:** https://ollama.com/
- **LM Studio:** https://lmstudio.ai/
- **Aider + Ollama:** https://aider.chat/docs/llms/ollama.html
- **Model Benchmarks:** https://huggingface.co/spaces/bigcode/bigcodebench-leaderboard
- **AGENTIC_AI_WORKFLOW:** [docs/AGENTIC_AI_WORKFLOW.md](AGENTIC_AI_WORKFLOW.md)
- **Aider Integration:** [docs/AIDER_INTEGRATION.md](AIDER_INTEGRATION.md)

---

**Last Updated:** 2025-12-17
**Version:** 1.0
**Compatible with:** Ollama 0.x, LM Studio, Aider 0.x, AGENTIC_AI_WORKFLOW v1.0
