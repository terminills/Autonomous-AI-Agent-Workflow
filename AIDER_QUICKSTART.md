# Aider Quick Start Guide

## AI_PHASE: DOCUMENTATION
## AI_STATUS: COMPLETE
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Fast track guide to get Aider working with local models in 5 minutes

---

## 5-Minute Setup

### Step 1: Install Ollama (2 min)

```bash
# Linux/macOS automatic install
./scripts/setup_ollama.sh

# This will:
# - Install Ollama
# - Detect your hardware
# - Download recommended model
# - Start Ollama server
```

**Manual install alternative:**
- Linux: `curl -fsSL https://ollama.com/install.sh | sh`
- macOS: `brew install ollama` or download from https://ollama.com
- Windows: Download from https://ollama.com/download

### Step 2: Install Aider (1 min)

```bash
# Run setup script
./scripts/setup_aider.sh

# This will:
# - Install aider-chat via pip
# - Create .aider.env from template
# - Verify installation
```

**Manual install alternative:**
```bash
pip3 install --user aider-chat
cp .aider.env.example .aider.env
```

### Step 3: Verify Setup (1 min)

```bash
# Check Ollama is running
ollama list

# Check Aider is installed
aider --version

# Test the connection
aider --model ollama/qwen2.5-coder:7b-instruct --message "Say hello"
```

### Step 4: Start Coding! (1 min)

```bash
# Basic usage
aider src/myfile.c

# Or use the helper for workflow context
./scripts/aider_session.sh my-project phase4

# In Aider:
> /add src/file.c
> Add error handling to this function
> /exit
```

---

## Recommended Models by Hardware

### Laptop (8-16GB RAM)
```bash
ollama pull qwen2.5-coder:7b-instruct
aider --model ollama/qwen2.5-coder:7b-instruct
```
**Quality: ⭐⭐⭐⭐⭐ (88% HumanEval)**

### Desktop (16-24GB RAM, GPU)
```bash
ollama pull deepseek-coder-v2:16b-lite-instruct-q8_0
aider --model ollama/deepseek-coder-v2:16b-lite-instruct-q8_0
```
**Quality: ⭐⭐⭐⭐ (81% HumanEval)**

### Workstation (32GB+ RAM, High-end GPU)
```bash
ollama pull qwen2.5-coder:32b-instruct
aider --model ollama/qwen2.5-coder:32b-instruct
```
**Quality: ⭐⭐⭐⭐⭐ (90% HumanEval)**

---

## Common Commands

### Ollama Management
```bash
ollama list                    # Show installed models
ollama ps                      # Show running models
ollama pull <model>            # Download a model
ollama rm <model>              # Remove a model
ollama serve                   # Start server manually
```

### Aider Usage
```bash
# Start session
aider                          # Current directory
aider src/file.c              # With specific file

# Session with project context
./scripts/aider_session.sh my-project phase4

# With initial message
aider --message "Fix the build errors"

# Different model
aider --model ollama/deepseek-coder-v2:16b-lite-instruct-q8_0
```

### Inside Aider
```
/help                         # Show commands
/add src/file.c              # Add file to context
/drop src/file.c             # Remove from context
/ls                          # List context files
/commit                      # Commit changes
/undo                        # Undo last change
/run make                    # Run command
/exit                        # Exit
```

---

## Quick Troubleshooting

### Ollama not found
```bash
# Check if installed
which ollama

# Install if missing
./scripts/setup_ollama.sh
```

### Model not found
```bash
# List installed models
ollama list

# Pull the model
ollama pull qwen2.5-coder:7b-instruct
```

### Connection refused
```bash
# Start Ollama server
ollama serve

# Test connection
curl http://127.0.0.1:11434/api/version
```

### Slow inference
```bash
# Use smaller model
aider --model ollama/qwen2.5-coder:7b-instruct

# Check GPU usage (Linux)
nvidia-smi
```

### Out of memory
```bash
# Use quantized model
ollama pull qwen2.5-coder:7b-instruct-q4_K_M

# Reduce context
export OLLAMA_NUM_CTX=4096
```

---

## Typical Workflow

### 1. Fix a Bug
```bash
# Start Aider with the problematic file
aider src/socket.c

# In Aider:
> /add include/socket.h
> Fix the NULL pointer dereference on line 45
> Add error handling

# Review, commit, done!
> /commit
> /exit
```

### 2. Implement Feature
```bash
# Start with phase context
./scripts/aider_session.sh network-stack phase4

# In Aider:
> /add src/socket.c
> Implement POSIX socket() using AROS bsdsocket.library
> Follow the API mapping in the phase2 plan document

# Test it
> /run make
> /run ./test_socket

# Commit when working
> /commit
> /exit

# Push to GitHub
git push
```

### 3. Refactor Code
```bash
# Add all related files
aider src/api_v1.c src/api_v2.c include/api.h

# In Aider:
> Refactor the API to use the new pattern
> Update all function signatures
> Maintain backward compatibility

> /commit
> /exit
```

---

## Integration with AGENTIC_AI_WORKFLOW

### Phase 1-3: Planning (Use GitHub Copilot)
- Create issues with GitHub Copilot
- Document discovery and planning
- Break down tasks

### Phase 4: Implementation (Use Aider)
```bash
# Start implementation
./scripts/aider_session.sh my-project phase4

# Implement task by task
> /add src/target.c
> Implement task 3.1: Socket layer porting
> Follow the Phase 2 plan

# Build and test
> /run ./scripts/capture_build.sh "make"

# Fix errors
> Fix the build errors

# Commit
> /commit "AI_COMMIT: Implement socket layer - Task 3.1"
> /exit

# Push for review
git push
```

### Phase 5: Completion (Both)
- Use Aider for final polish
- Use GitHub Copilot for documentation
- Generate completion report

---

## Why Local Models?

✅ **Zero cost** - No API fees, ever
✅ **Privacy** - Code never leaves your machine
✅ **Speed** - Fast local inference
✅ **Offline** - Works without internet
✅ **Unlimited** - No rate limits

**Example costs:**
- Cloud API (GPT-4): $0.125 per coding session
- 100 sessions/month: **$12.50/month**
- Local model: **$0/month** (after initial GPU purchase)

**Break-even:** 2-3 months of moderate use

---

## Next Steps

1. ✅ **Setup complete?** Start coding with Aider!

2. 📚 **Learn more:**
   - Full guide: [docs/LOCAL_MODELS_GUIDE.md](docs/LOCAL_MODELS_GUIDE.md)
   - Integration: [docs/AIDER_INTEGRATION.md](docs/AIDER_INTEGRATION.md)
   - Workflow: [docs/AGENTIC_AI_WORKFLOW.md](docs/AGENTIC_AI_WORKFLOW.md)

3. 🎯 **Optimize:**
   - Tune model for your hardware
   - Create custom model aliases
   - Set up team sharing

4. 🤝 **Collaborate:**
   - Use with GitHub Copilot
   - Multi-agent workflows
   - ACD v1.1.0 metadata

---

## Support

- **Aider:** https://aider.chat/docs/
- **Ollama:** https://ollama.com/
- **This Repo:** https://github.com/terminills/Autonomous-AI-Agent-Workflow

---

**Last Updated:** 2025-12-17  
**Version:** 1.0  
**Time to setup:** ~5 minutes

Happy coding! 🚀
