# Aider Integration with AGENTIC_AI_WORKFLOW

## AI_PHASE: DOCUMENTATION
## AI_STATUS: COMPLETE
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Complete guide for integrating Aider with the autonomous workflow system
## AI_VERSION: 1.0

---

## Table of Contents

1. [Overview](#overview)
2. [What is Aider?](#what-is-aider)
3. [Why Aider + AGENTIC_AI_WORKFLOW?](#why-aider--agentic_ai_workflow)
4. [Installation](#installation)
5. [Configuration](#configuration)
6. [Usage Patterns](#usage-patterns)
7. [Workflow Integration](#workflow-integration)
8. [Multi-Agent Collaboration](#multi-agent-collaboration)
9. [Best Practices](#best-practices)
10. [Troubleshooting](#troubleshooting)
11. [Examples](#examples)

---

## Overview

This guide explains how to use **Aider** as a local coding agent within the **AGENTIC_AI_WORKFLOW** system. Aider complements GitHub Copilot by providing:

- **Terminal-based AI pair programming** for local development
- **Direct git integration** with auto-commits
- **Codebase mapping** for better context awareness
- **Multi-file editing** with coordinated changes
- **Support for multiple LLM providers** (OpenAI, Anthropic, DeepSeek, local models)

**The Perfect Combination:**
- **GitHub Copilot** - For GitHub Issues, PR reviews, and cloud-based workflow orchestration
- **Aider** - For local terminal coding, rapid iteration, and hands-on implementation

---

## What is Aider?

[Aider](https://aider.chat) is an open-source AI coding assistant that works directly in your terminal. It provides:

### Core Features

- **AI Pair Programming** - Natural language requests for code changes
- **Git Integration** - Automatic commits with descriptive messages
- **Codebase Mapping** - Deep understanding of your project structure
- **Multi-Language Support** - Works with 100+ programming languages
- **Multiple LLM Providers** - OpenAI, Anthropic, DeepSeek, Groq, local models
- **Multi-File Editing** - Coordinated changes across multiple files
- **Voice Input** - Optional voice commands for hands-free coding
- **Test Integration** - Run tests after changes

### Specialized Agent Roles

Aider supports dedicated agent roles:
- **DevOps Agent** - CI/CD, deployment, infrastructure
- **Feature Agent** - Core business logic and APIs
- **QA Agent** - Testing and validation
- **Documentation Agent** - Technical docs and diagrams

---

## Why Aider + AGENTIC_AI_WORKFLOW?

The AGENTIC_AI_WORKFLOW was designed for GitHub Copilot and cloud-based agents, but adding Aider provides:

### 1. Local Development Speed
- **Instant feedback** - No waiting for CI/CD or GitHub API
- **Rapid iteration** - Code, test, fix cycle in seconds
- **Offline capability** - Work with local LLMs when offline

### 2. Better Context Control
- **File-level control** - Add/remove files from context dynamically
- **Cost optimization** - Use smaller models for simple edits
- **Caching** - Faster responses with prompt caching

### 3. Complementary Strengths

| Feature | GitHub Copilot | Aider |
|---------|---------------|-------|
| Issue management | ✅ Excellent | ❌ Not supported |
| PR reviews | ✅ Excellent | ❌ Not supported |
| Local coding | ⚠️ Limited | ✅ Excellent |
| Terminal workflow | ⚠️ Basic | ✅ Native |
| Codebase mapping | ⚠️ Basic | ✅ Advanced |
| Auto-commits | ❌ Manual | ✅ Automatic |
| Multi-file edits | ⚠️ Limited | ✅ Excellent |
| Cost control | ❌ Fixed pricing | ✅ Flexible models |

### 4. Workflow Integration

Use them together for maximum efficiency:

```
Phase 1-3: Discovery, Planning, Task Segmentation
├── Use: GitHub Copilot in Issues
└── Output: Structured documentation and task list

Phase 4: Implementation
├── Use: Aider for local coding sessions
├── Auto-commit: Changes with AI_COMMIT metadata
└── Push: To GitHub for Copilot review

Phase 5: Completion
├── Use: GitHub Copilot for PR review
└── Use: Aider for final polishing
```

---

## Installation

### Prerequisites

- Python 3.9 or later
- pip (Python package manager)
- Git repository
- API key for LLM provider (OpenAI, Anthropic, etc.) or local LLM

### Quick Install

```bash
# Navigate to your repository
cd /path/to/your/repo

# Run the setup script
./scripts/setup_aider.sh
```

The script will:
1. Check Python version
2. Install aider-chat via pip
3. Verify installation
4. Create .aider.env from template
5. Provide next steps

### Manual Install

If you prefer manual installation:

```bash
# Install Aider
pip install --user aider-chat

# Verify installation
aider --version

# Copy environment template
cp .aider.env.example .aider.env

# Edit and add your API keys
nano .aider.env
```

### Configuration Files

After installation, you'll have:

```
.aider.conf.yml          # Main configuration (committed to repo)
.aider.env               # API keys and secrets (NOT committed)
.aider.env.example       # Template for .aider.env
.gitignore               # Updated to exclude Aider temp files
```

---

## Configuration

### Main Configuration (.aider.conf.yml)

This file is committed to the repository and contains:

```yaml
# AI Model Configuration
model: gpt-4o              # Primary coding model
editor-model: gpt-4o-mini  # Fast model for small edits

# Git Integration
auto-commits: true         # Automatic commits after changes
dirty-commits: true        # Allow commits in dirty repos
commit-prompt: |          # Custom commit message format
  Generate a clear, descriptive commit message following AGENTIC_AI_WORKFLOW conventions.
  Include AI_COMMIT metadata tags when appropriate.

# Context and Files
read:                      # Auto-load these files for context
  - docs/AGENTIC_AI_WORKFLOW.md
  - DOCUMENTATION_GUIDE.md
  - BOOTSTRAP_AUTONOMOUS_AGENT.md

# Codebase Mapping
map-tokens: 2048          # Tokens for repo map
map-refresh: auto         # Refresh map automatically

# Code Quality
lint: true                # Run linters
auto-test: false          # Don't auto-run tests

# Output Configuration
pretty: true              # Pretty formatting
show-diffs: true          # Show diffs before commit
```

### Environment Variables (.aider.env)

This file is **NOT committed** and contains sensitive data:

```bash
# OpenAI (GPT models)
OPENAI_API_KEY=sk-...

# Anthropic (Claude models)
ANTHROPIC_API_KEY=sk-ant-...

# Azure OpenAI
AZURE_OPENAI_API_KEY=...
AZURE_OPENAI_ENDPOINT=https://...

# DeepSeek (budget option)
DEEPSEEK_API_KEY=...

# Groq (fast inference)
GROQ_API_KEY=...

# Local LLMs (Ollama)
OLLAMA_API_BASE=http://localhost:11434

# GitHub Token
GITHUB_TOKEN=ghp_...
```

### Model Selection

Choose models based on task complexity:

```bash
# Premium model for complex work
aider --model gpt-4o

# Budget model for simple edits
aider --model gpt-4o-mini

# Claude for reasoning-heavy tasks
aider --model claude-3-5-sonnet-20241022

# DeepSeek for cost optimization
aider --model deepseek/deepseek-chat

# Local Ollama model (free)
aider --model ollama/codellama
```

---

## Usage Patterns

### Basic Usage

#### 1. Start Aider

```bash
# Basic start
aider

# With specific files
aider src/main.py src/utils.py

# With message
aider --message "Add error handling to the socket layer"
```

#### 2. Using the Helper Script

```bash
# Start with project context
./scripts/aider_session.sh my-project phase4

# With custom message
./scripts/aider_session.sh network-stack phase4 "Implement BSD socket compatibility layer"
```

### Interactive Commands

Inside an Aider session:

```
/help                     # Show all commands
/add src/file.py         # Add file to context
/drop src/file.py        # Remove file from context
/ls                      # List files in context
/commit                  # Commit changes
/undo                    # Undo last change
/diff                    # Show uncommitted changes
/run pytest              # Run command and show output
/exit                    # Exit Aider
```

### Common Tasks

#### 1. Implementing a Task

```bash
# Start Aider with task context
./scripts/aider_session.sh network-stack phase4

# In Aider:
> /add src/socket.c
> Implement POSIX socket() function using AROS bsdsocket.library.
> Follow the API mapping in docs/network-stack/phases/phase2/plan_*.md
> Add proper error handling and AI_PHASE metadata in comments.

# Aider will:
# 1. Read the context files
# 2. Generate the implementation
# 3. Show you a diff
# 4. Auto-commit with message
```

#### 2. Fixing Build Errors

```bash
# Capture build with errors
./scripts/capture_build.sh "make"

# Analyze errors
./scripts/analyze_build_log.sh docs/phase4/build_logs/build_*.log

# Start Aider with error context
aider --read docs/phase4/build_logs/build_*_analysis.md

# In Aider:
> /add src/problematic_file.c
> Fix the build errors described in the analysis document.
> Follow AROS API patterns from Phase 1 discovery.
```

#### 3. Refactoring

```bash
# Start with multiple files
aider src/module1.c src/module2.c src/module3.c

# In Aider:
> Refactor the memory allocation pattern to use AROS AllocMem/FreeMem
> instead of malloc/free. Update all three files consistently.
> Add AI_HISTORY metadata tracking this refactoring.
```

#### 4. Adding Tests

```bash
# Add test files
aider src/socket.c tests/test_socket.c

# In Aider:
> Add comprehensive unit tests for the socket implementation.
> Test success cases, error cases, and edge cases.
> Follow existing test patterns in the codebase.
```

---

## Workflow Integration

### Phase 1: Discovery (GitHub Copilot)

Use GitHub Copilot in Issues to:
- Analyze repository structure
- Document findings
- Create discovery reports

**Aider's role:** Minimal - maybe quick exploration

```bash
# Quick codebase exploration with Aider
aider --read docs/AGENTIC_AI_WORKFLOW.md
> /map
> Explore the codebase structure and summarize key subsystems
```

### Phase 2: Master Plan (GitHub Copilot)

Use GitHub Copilot to:
- Design architecture
- Map APIs
- Create implementation strategy

**Aider's role:** Validate feasibility

```bash
# Test API mappings
aider
> /add src/example_old_api.c
> Can we implement this using the AROS APIs documented in Phase 1?
> Show me a proof-of-concept.
```

### Phase 3: Task Segmentation (GitHub Copilot)

Use GitHub Copilot to:
- Break down work into tasks
- Prioritize and sequence

**Aider's role:** Estimate complexity

```bash
# Complexity estimation
aider
> /add docs/phase3/tasks_*.md
> For task 3.1, estimate lines of code and potential issues
```

### Phase 4: Implementation (Aider + GitHub Copilot)

**Primary tool: Aider**

This is where Aider shines!

#### Workflow:

```bash
# 1. Start implementation session
./scripts/aider_session.sh my-project phase4

# 2. Add relevant files
> /add src/target_file.c
> /add src/helper.c

# 3. Implement the task
> Implement task 3.1: Port socket layer to bsdsocket.library
> Reference: docs/my-project/phases/phase3/tasks_*.md
> Follow patterns from: docs/my-project/phases/phase1/discovery_*.md

# 4. Aider makes changes and auto-commits

# 5. Build and test
> /run make
> /run make test

# 6. Fix any errors
> Fix the compilation errors shown above

# 7. Verify and continue
> /commit
> /exit

# 8. Push to GitHub
git push

# 9. GitHub Copilot reviews in PR
# @copilot please review this implementation
```

#### Iteration Pattern:

```
1. Aider implements code
2. Auto-commit with AI_COMMIT metadata
3. Build with ./scripts/capture_build.sh
4. If errors:
   a. Aider reads error log
   b. Aider fixes errors
   c. Repeat
5. When successful:
   a. Push to GitHub
   b. Copilot reviews PR
   c. Address feedback with Aider
```

### Phase 5: Completion (GitHub Copilot + Aider)

**Primary tool: GitHub Copilot**

Use Copilot for:
- Final testing
- Documentation
- Completion report

**Aider's role:** Polish and minor fixes

```bash
# Final polishing
aider
> /add README.AROS
> /add CHANGELOG.AROS
> Polish the documentation and fix any formatting issues
```

---

## Multi-Agent Collaboration

Combine Aider with GitHub Copilot using ACD v1.1.0 metadata:

### Pattern 1: Handoff from Copilot to Aider

**In GitHub Issue:**
```markdown
## AI_PHASE: IMPLEMENTATION
## AI_STATUS: IN_PROGRESS
## AI_HANDOFF_REQUESTED: true
## AI_HANDOFF_TYPE: SPECIALIZATION
## AI_HANDOFF_TO: local-aider-agent
## AI_HANDOFF_REASON: Requires rapid local iteration for debugging
## AI_HANDOFF_NOTES: See build log docs/phase4/build_logs/build_20251217.log

@copilot Task requires local debugging. Handing off to Aider for implementation.
```

**In Aider Session:**
```bash
# Load context from handoff
aider --read docs/my-project/phases/phase4/iteration_003.md

> Implementing task from GitHub issue #123
> GitHub Copilot identified the approach in the planning phase.
> Now implementing locally with rapid iteration.

# Work, commit, push
> /exit

git push
```

**Back in GitHub:**
```markdown
## AI_HANDOFF_STATUS: COMPLETED
## AI_PREVIOUS_ASSIGNEE: local-aider-agent
## AI_ASSIGNED_TO: copilot
## AI_CONFIDENCE: CONFIDENT
## AI_REQUEST: REQUEST_REVIEW

@copilot Implementation complete. Ready for review.
```

### Pattern 2: Dual-Agent Exchange

**Aider generates, Copilot reviews:**

```bash
# Aider implements
aider
> Implement feature X with AI_CONFIDENCE: UNCERTAIN tag
> /commit "AI_COMMIT: Implement feature X (needs review)"
> /exit

git push
```

**In GitHub PR:**
```markdown
## AI_EXCHANGE_ID: feature-x-impl
## AI_ROUND: 1
## AI_ASSIGNED_TO: aider-local
## AI_CONFIDENCE: UNCERTAIN
## AI_REQUEST: REQUEST_REVIEW

@copilot Please review this implementation. Specifically:
1. Check memory management
2. Verify error handling
3. Validate API usage
```

**Copilot responds:**
```markdown
## AI_VALIDATION: ANALYZED
## AI_ISSUES: 
- Missing NULL check on line 45
- Memory leak in error path line 67
## AI_SUGGESTIONS:
- Add NULL validation before CloseSocket()
- Add FreeMem() in error handling
## AI_VALIDATION_RESULT: NEEDS_MORE_WORK
```

**Back to Aider:**
```bash
aider
> /add src/feature_x.c
> Apply Copilot's feedback from PR #456:
> - Add NULL check on line 45
> - Fix memory leak on line 67
> /commit "AI_COMMIT: Apply review feedback - fixes memory issues"
> /exit

git push
```

### Pattern 3: Parallel Work

- **Copilot** - Works on Issue #1 (documentation)
- **Aider** - Works on Issue #2 (implementation)

Both use AI_ASSIGNED_TO metadata to avoid conflicts.

---

## Best Practices

### 1. Commit Message Format

Always use AGENTIC_AI_WORKFLOW format:

```bash
# In .aider.conf.yml:
commit-prompt: |
  Generate commit message following format:
  
  AI_COMMIT: [Brief description]
  
  - [Detailed change 1]
  - [Detailed change 2]
  - Ref: [phase document if applicable]
  - Task: [task identifier if applicable]
```

Example output:
```
AI_COMMIT: Implement POSIX socket compatibility layer

- Added CloseSocket() wrapper for socket()
- Implemented error code mapping POSIX→AROS
- Added AI_PHASE metadata in source
- Ref: docs/network-stack/phases/phase2/plan_20251217.md
- Task: TASK_3_1_SOCKET_LAYER
```

### 2. Context Management

**Do:**
- Start with workflow documentation in context
- Add only relevant files
- Use `/drop` to remove files you're done with
- Use `/ls` to see what's in context

**Don't:**
- Add entire codebase to context (expensive)
- Keep unrelated files in context
- Forget to add header files when working on .c files

### 3. Cost Optimization

```bash
# Use cheaper models for simple tasks
aider --editor-model gpt-4o-mini

# Use local models when possible
aider --model ollama/codellama

# Cache context for repeated sessions
aider --cache-prompts
```

### 4. Testing Integration

```bash
# Run tests after changes
aider --auto-test --test-cmd "make test"

# Or manually
> /run make test
> Review test output and fix failures
```

### 5. Documentation

Always update metadata:

```c
/*
 * AI_PHASE: NETWORK_TRANSLATION
 * AI_STATUS: IMPLEMENTED
 * AI_ASSIGNED_TO: aider-local
 * AI_CONFIDENCE: CONFIDENT
 * AI_HISTORY: socket_v1 [abc123] → socket_v2 [def456] → socket_v3 [ghi789]
 * AI_HISTORY_STATUS: SUCCESS
 * AI_NOTE: POSIX socket() → AROS bsdsocket.library
 */
```

### 6. Error Recovery

If Aider makes a mistake:

```bash
# Undo last change
> /undo

# Or revert specific file
> /drop src/file.c
> /run git checkout src/file.c
> /add src/file.c
> Try again with different approach
```

### 7. Large Changes

For multi-file refactoring:

```bash
# Use architect mode (default in config)
aider --edit-format architect

# Add all related files
> /add src/file1.c src/file2.c src/file3.c include/api.h

# Request coordinated changes
> Refactor the API calls across all files to use the new pattern
> Ensure consistency and update all call sites
```

---

## Troubleshooting

### Problem: Aider not found after installation

**Solution:**
```bash
# Add to PATH
export PATH="$HOME/.local/bin:$PATH"

# Make permanent
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Problem: API key errors

**Solution:**
```bash
# Check .aider.env exists
ls -la .aider.env

# Verify API key is set
grep OPENAI_API_KEY .aider.env

# Test API key
aider --model gpt-4o-mini --message "test"
```

### Problem: Context too large errors

**Solution:**
```bash
# Use smaller model
aider --model gpt-4o-mini

# Reduce map tokens
aider --map-tokens 1024

# Remove unnecessary files from context
> /drop unwanted_file.c
```

### Problem: Aider makes wrong changes

**Solution:**
```bash
# Undo
> /undo

# Provide more context
> /add docs/phase1/discovery_*.md
> Try again, following the patterns documented here

# Use architect mode for complex changes
aider --edit-format architect
```

### Problem: Build still failing after fixes

**Solution:**
```bash
# Capture detailed build log
./scripts/capture_build.sh "make VERBOSE=1"

# Load into Aider with analysis
./scripts/analyze_build_log.sh docs/phase4/build_logs/build_*.log
aider --read docs/phase4/build_logs/build_*_analysis.md

# Provide full error context
> /add src/failing_file.c
> Fix all errors from the build analysis
```

### Problem: Slow response times

**Solution:**
```bash
# Use faster model
aider --model gpt-4o-mini

# Use Groq for fast inference
aider --model groq/llama3-70b-8192

# Enable caching
aider --cache-prompts

# Use local model
aider --model ollama/codellama
```

---

## Examples

### Example 1: Complete Implementation Session

```bash
# Start session
./scripts/aider_session.sh network-stack phase4

# Load context and files
> /add src/socket.c
> /add include/socket.h
> /read docs/network-stack/phases/phase2/plan_20251217.md

# Implement
> Implement POSIX socket() function using AROS bsdsocket.library
> Follow the API mapping in the plan document
> Add comprehensive error handling
> Include AI_PHASE and AI_HISTORY metadata

# Review diff
# (Aider shows diff)

# Looks good? Auto-commits
# AI_COMMIT: Implement POSIX socket compatibility
#
# - Added socket() wrapper using CloseSocket()
# - Implemented errno mapping
# - Added error handling for all failure cases
# - Ref: docs/network-stack/phases/phase2/plan_20251217.md
# - Task: TASK_3_1_SOCKET_LAYER

# Build and test
> /run ./scripts/capture_build.sh "make"

# If errors, fix them
> Fix the compilation error on line 45

# Test again
> /run make test

# Exit when done
> /exit

# Push to GitHub
git push
```

### Example 2: Bug Fix from Build Log

```bash
# Build failed
./scripts/capture_build.sh "make"
# Error log: docs/phase4/build_logs/build_20251217_143022.log

# Analyze
./scripts/analyze_build_log.sh docs/phase4/build_logs/build_20251217_143022.log
# Analysis: docs/phase4/build_logs/build_20251217_143022_analysis.md

# Start Aider with context
aider --read docs/phase4/build_logs/build_20251217_143022_analysis.md

# Add problematic file
> /add src/socket.c

# Fix
> Fix all errors listed in the analysis document
> Preserve existing functionality
> Add comments explaining fixes

# Rebuild
> /run make

# Success!
> /exit
```

### Example 3: Multi-File Refactoring

```bash
# Start with all related files
aider src/api_v1.c src/api_v2.c src/caller.c include/api.h

# Request coordinated refactoring
> Refactor the old API to the new pattern:
> - Update api_v1.c to use new function signatures
> - Update api_v2.c similarly
> - Update all call sites in caller.c
> - Update header file declarations
> Ensure backward compatibility where possible
> Add AI_HISTORY tracking this refactoring

# Review changes across all files
# (Aider shows coordinated diff)

# Commit
> /commit

# Exit
> /exit
```

### Example 4: Documentation Update

```bash
# Update docs based on implementation
aider README.AROS CHANGELOG.AROS docs/network-stack/docs/USER_GUIDE.md

# Request updates
> Update all documentation to reflect the new socket implementation
> Add usage examples to README.AROS
> Update CHANGELOG.AROS with new features
> Expand USER_GUIDE.md with socket examples

# Review and commit
> /commit
> /exit
```

---

## Summary

**Aider Integration Benefits:**

✅ **Faster local development** - Rapid iteration without waiting for CI/CD
✅ **Better context control** - Add/remove files dynamically
✅ **Cost optimization** - Choose models based on task complexity
✅ **Auto-commits** - Automatic git commits with AI_COMMIT metadata
✅ **Multi-file editing** - Coordinated changes across codebase
✅ **Works offline** - Use local LLMs when needed
✅ **Perfect for Phase 4** - Implementation phase where speed matters
✅ **Complements Copilot** - Use both for maximum efficiency

**When to Use What:**

| Task | Tool |
|------|------|
| Issue creation and tracking | GitHub Copilot |
| Discovery and planning | GitHub Copilot |
| Task segmentation | GitHub Copilot |
| **Local implementation** | **Aider** |
| **Rapid bug fixes** | **Aider** |
| **Build error resolution** | **Aider** |
| PR reviews | GitHub Copilot |
| Completion reports | GitHub Copilot |
| Final polishing | Aider or Copilot |

**Best Practice:**
Use both tools together, each for what it does best, with clear handoffs documented using ACD v1.1.0 metadata.

---

## Further Reading

- **Aider Documentation:** https://aider.chat/docs/
- **Aider GitHub:** https://github.com/Aider-AI/aider
- **AGENTIC_AI_WORKFLOW:** [docs/AGENTIC_AI_WORKFLOW.md](AGENTIC_AI_WORKFLOW.md)
- **ACD Specification:** [docs/acd-system/docs/ACD_SPECIFICATION_V1.md](acd-system/docs/ACD_SPECIFICATION_V1.md)
- **Bootstrap Guide:** [BOOTSTRAP_AUTONOMOUS_AGENT.md](../BOOTSTRAP_AUTONOMOUS_AGENT.md)

---

**Last Updated:** 2025-12-17
**Version:** 1.0
**Compatible with:** Aider 0.x, AGENTIC_AI_WORKFLOW v1.0, ACD v1.1.0
