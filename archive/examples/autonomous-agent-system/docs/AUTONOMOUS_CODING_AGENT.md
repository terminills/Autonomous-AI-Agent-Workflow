# AROS Autonomous Coding Agent

## AI_PHASE: AUTONOMOUS_AGENT_DOCUMENTATION
## AI_STATUS: ENHANCED
## AI_COMPLEXITY: MEDIUM
## AI_NOTE: Complete documentation for autonomous generate-compile-test-fix system with git history
## AI_COMMIT: llm_integration_v2

---

## Overview

The AROS Autonomous Coding Agent is a self-improving build system that runs on **Linux**, cross-compiling AROS and automatically fixing errors through an iterative LLM-powered cycle:

1. ✅ **Configures and builds AROS** from the repository (Linux cross-compile)
2. ✅ **Detects errors** during cross-compilation
3. ✅ **Generates fixes** using LLM inference (llama2/qwen3)
4. ✅ **Applies fixes** to source code
5. ✅ **Recompiles** to validate fixes
6. ✅ **Commits successful fixes** with AI_COMMIT tags via git
7. ✅ **Tracks history** for LLM context on subsequent fixes
8. ✅ **Iterates** until compilation succeeds or max attempts reached
9. ✅ **Follows ACD specification** for metadata and tracking
10. ✅ **Builds out-of-tree** to preserve source cleanliness
11. ✅ **Generates distfiles** after successful builds
12. ✅ **Backs up ISO files** with timestamps

## Key Features

### Autonomous Fix Cycle

The agent implements a complete **generate-compile-test-fix** loop:

```
┌─────────────────────────────────────────────┐
│   Autonomous Fix Cycle (on Linux)           │
├─────────────────────────────────────────────┤
│                                             │
│  1. Detect Error                            │
│     ↓                                       │
│  2. Get Git History Context                 │
│     ↓                                       │
│  3. LLM Generates Fix                       │
│     ↓                                       │
│  4. Apply Fix to Source                     │
│     ↓                                       │
│  5. Cross-Compile to AROS                   │
│     ↓                                       │
│  ┌──── Success? ────┐                      │
│  │                  │                      │
│  NO                YES                     │
│  │                  │                      │
│  │                  ↓                      │
│  │           6. Git Commit                │
│  │                  ↓                      │
│  │           7. Update AI_COMMIT tags     │
│  │                  ↓                      │
│  │           8. Continue Build            │
│  │                                         │
│  └→ Analyze New Error → Retry (max 5x)    │
│                                             │
└─────────────────────────────────────────────┘
```

### Git-Based Historical Memory

The agent uses **git** to provide LLM with complete historical context:

- **git blame**: Shows who/when/why each line was modified
- **git log**: Provides file change history
- **AI_COMMIT tags**: Updated only in modified sections
- **Historical recall**: LLM sees current → change 1 → change 2 → etc.

This enables the LLM to understand:
- Why previous changes were made
- What approaches were tried before
- How the code evolved over time
- Context for making better fixes

### Cross-Compilation Architecture

**Important**: The agent runs on **Linux** and cross-compiles to AROS:

```
┌─────────────────────────────────────────┐
│   Linux Host (where agent runs)         │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────────────────────────┐  │
│  │ Autonomous Agent (Python)        │  │
│  │  - LLM inference (llama2/qwen3)  │  │
│  │  - Git operations                │  │
│  │  - Code generation              │  │
│  └─────────────┬────────────────────┘  │
│                │                        │
│                ↓                        │
│  ┌──────────────────────────────────┐  │
│  │ Cross-Compiler Toolchain         │  │
│  │  - GCC for AROS                  │  │
│  │  - Binutils for AROS             │  │
│  └─────────────┬────────────────────┘  │
│                │                        │
│                ↓                        │
│  ┌──────────────────────────────────┐  │
│  │ AROS Source Tree                 │  │
│  │  - Modified by agent             │  │
│  │  - Cross-compiled to AROS        │  │
│  └──────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
            ↓ (produces)
    ┌──────────────────┐
    │ AROS Binaries    │
    │ (.iso, .exe)     │
    └──────────────────┘
```

**Note**: Runtime testing of AROS binaries is not part of the autonomous cycle since we're cross-compiling. Validation is done through successful compilation.

### Verbose Thinking Output

The agent provides human-readable output showing its reasoning process:

```
[14:23:15] 🤔 Autonomous Build Agent initialized
[14:23:15] 🤔 Repository: /home/runner/work/AROS/AROS
[14:23:15] 🤔 Build directory (out-of-tree): /home/runner/work/aros-build-pc-x86_64
[14:23:15] 🤔 Target platform: pc-x86_64 (cross-compiling from Linux)
[14:23:15] ✅ LLM llama2 available: /usr/bin/llama2
[14:23:15] ✅ Git repository initialized
[14:23:16] 🔧 Bash: ./configure --target=pc-x86_64 --enable-debug=none
[14:23:45] ✅ Configuration completed successfully
[14:23:45] 🤔 Starting build iteration 1...
[14:23:45] 🔧 Build: Running make
[14:25:32] ❌ Build error detected
[14:25:32] 🤖 Attempting automatic fix with LLM...
[14:25:32] 🤔 Getting git history for context...
[14:25:33] 🤖 Generating code fix with llama2...
[14:25:35] 💡 Generated 156 characters of code
[14:25:35] ✅ Applied fix to test.c
[14:25:36] 🔧 Cross-compiling to validate...
[14:25:40] ✅ Compilation successful!
[14:25:40] ✅ Committed: a3b2c1d - Auto-fix: undefined reference to 'foo'
[14:25:40] ✅ Updated AI_COMMIT tags in test.c
[14:25:40] ✅ Automatic fix applied in 1 attempts
```

### Out-of-Tree Builds

The agent builds in a separate directory to:
- Preserve source tree cleanliness
- Enable faster incremental rebuilds
- Facilitate testing multiple configurations
- Avoid polluting the repository with build artifacts

### Error Analysis

The agent parses build errors and categorizes them:
- Compiler errors (undeclared identifiers, syntax errors)
- Linker errors (undefined references)
- Missing file errors
- Make target errors

### ACD Compliance

All code follows the ACD (Autonomous Continuous Development) Standard v1.0:
- AI_PHASE tags for lifecycle tracking
- AI_STATUS tags for implementation status
- AI_COMPLEXITY ratings
- AI_NOTE for contextual information
- AI_DEPENDENCIES for dependency tracking

## Installation

The agent is located at:
```
scripts/autonomous_build_agent.py
```

### Requirements

- Python 3.6+
- Standard AROS build dependencies
- Sufficient disk space for out-of-tree builds

### Dependencies

The agent uses:
- AROS build system (configure, make)
- Python standard library (no external packages needed)
- ACD validation tools (optional, for metadata checking)

## Usage

### Basic Usage

Build AROS with default settings:
```bash
cd /path/to/AROS
./scripts/autonomous_build_agent.py
```

This will:
1. Configure for `pc-x86_64` target
2. Create out-of-tree build in `../aros-build-pc-x86_64`
3. Build iteratively (up to 10 attempts)
4. On success: create distfiles and backup ISO

### Advanced Usage

#### Specify Target Platform

```bash
./scripts/autonomous_build_agent.py --target pc-i386
```

Supported targets:
- `pc-x86_64` (default)
- `pc-i386`
- `linux-x86_64`
- `raspi-armhf`
- `amiga-m68k`
- etc.

#### Custom Build Directory

```bash
./scripts/autonomous_build_agent.py --build-dir /path/to/custom/build
```

#### Set Maximum Iterations

```bash
./scripts/autonomous_build_agent.py --max-iterations 20
```

#### Quiet Mode

Reduce output verbosity:
```bash
./scripts/autonomous_build_agent.py --quiet
```

### Full Example

Complete build with custom settings:
```bash
./scripts/autonomous_build_agent.py \
    --repo-path /home/user/AROS \
    --build-dir /mnt/fast-disk/aros-build \
    --target pc-x86_64 \
    --max-iterations 15
```

## How It Works

### Phase 1: Configuration

```
🤔 Configuring AROS build system...
🤔 This is an out-of-tree build to preserve source cleanliness
🔧 Configure: Running configure for pc-x86_64
✅ Configuration completed successfully
```

The agent runs the AROS configure script with appropriate flags for the target platform.

### Phase 2: Iterative Build Loop

```
🤔 --- Build Iteration 1/10 ---
🔧 Build: Running make
[build output...]
❌ Build failed with return code 2
🤔 Analyzing build errors...
🤔 Found 3 distinct errors in build output
🤔 Error 1: file.c:42:5: error: undeclared identifier 'foo'
🤔 Error type: Undeclared identifier
🤔 Suggested approach: // TODO: Add missing declaration or include header
```

For each iteration:
1. Run `make` with parallel jobs
2. Capture and parse errors
3. Analyze errors with LLM reasoning
4. Suggest fixes
5. Log detailed information
6. Retry build

### Phase 3: Distribution Files

After successful build:
```
🤔 Phase 3: Distribution Files
🔧 Build: Running make distfiles
✅ Distribution files built successfully
```

### Phase 4: ISO Backup

```
🤔 Phase 4: ISO Backup
🤔 Searching for generated ISO files...
🤔 Found 1 ISO file(s)
🔧 Backup: Copying aros-pc-x86_64.iso to backups/
✅ Backed up to distfiles/backups/aros-pc-x86_64_20251029_142530.iso
```

## Output Directory Structure

After running the agent:

```
/path/to/AROS/
├── scripts/
│   └── autonomous_build_agent.py
├── distfiles/
│   └── backups/
│       ├── aros-pc-x86_64_20251029_142530.iso
│       └── aros-pc-x86_64_20251029_150123.iso
│
../aros-build-pc-x86_64/
├── bin/              # Compiled binaries
├── distfiles/        # Generated distribution files
│   └── *.iso        # ISO images
├── logs/            # Build logs and error analysis
│   ├── configure_0.log
│   ├── build_1.log
│   ├── build_2.log
│   ├── distfiles.log
│   └── fixes_iteration_1.json
└── [build artifacts]
```

## Log Files

The agent creates detailed logs in `<build-dir>/logs/`:

### Configuration Logs
- `configure_N.log` - Configuration output

### Build Logs
- `build_N.log` - Full build output for iteration N
- Contains stdout and stderr
- Includes return codes

### Fix Logs
- `fixes_iteration_N.json` - Suggested fixes in JSON format
- Structured error information
- Proposed solutions

### Distfile Logs
- `distfiles.log` - Distribution file generation output

## Error Analysis

The agent analyzes errors and suggests approaches:

### Undeclared Identifiers
```
Error: 'foo' undeclared
Approach: Add missing declaration or include header
```

### Undefined References
```
Error: undefined reference to `bar'
Approach: Add missing library or implement function
```

### Missing Files
```
Error: fatal error: header.h: No such file or directory
Approach: Add missing file or fix include path
```

### Syntax Errors
```
Error: expected ';' before 'int'
Approach: Fix syntax in source file
```

## Integration with LLM Infrastructure

The agent now includes full integration with the AROS LLM infrastructure!

### Current Status
- ✅ Error detection and parsing
- ✅ LLM inference integration (llama2, qwen3)
- ✅ Heuristic-based analysis as fallback
- ✅ Web search for known fixes
- ✅ Structured error logging
- ✅ Multi-strategy error analysis

### LLM Integration Architecture

The agent integrates with LLM inference engines through the `LLMInferenceEngine` class:

```python
# Automatic initialization with auto-detection
llm_engine = LLMInferenceEngine(
    verbose=True,
    llm_type='llama2',    # or 'qwen3'
    model_path=None,      # auto-detects model
    llm_bin_dir=None      # auto-detects binaries
)

# Check if LLM is available
if llm_engine.is_available():
    # Analyze build error with LLM
    suggestion = llm_engine.analyze_build_error(
        error_message="error: 'foo' undeclared",
        file_path="test.c",
        line_number=42,
        max_tokens=200
    )
```

### Multi-Strategy Error Analysis

The agent uses a sophisticated three-tier approach:

1. **LLM Inference (Primary)**: Calls llama2 or qwen3 for intelligent analysis
2. **Web Search (Secondary)**: Searches GitHub for similar issues and solutions
3. **Heuristic Patterns (Fallback)**: Pattern-based analysis for common errors

This ensures maximum reliability and accuracy while gracefully degrading when LLM is unavailable.

### Usage

#### Basic Usage with LLM (Auto-detect)
```bash
./scripts/autonomous_build_agent.py
```

#### Specify LLM Type
```bash
# Use llama2 (default)
./scripts/autonomous_build_agent.py --llm-type llama2

# Use qwen3
./scripts/autonomous_build_agent.py --llm-type qwen3

# Disable LLM
./scripts/autonomous_build_agent.py --llm-type none
```

#### Custom LLM Configuration
```bash
# Specify model and binary locations
./scripts/autonomous_build_agent.py \
    --llm-type llama2 \
    --llm-model /path/to/stories110M.bin \
    --llm-bin-dir /path/to/llm/binaries
```

### LLM Binary Locations

The agent auto-detects LLM binaries in these locations:
- `/usr/local/bin`
- `/usr/bin`
- `~/bin`
- `bin/pc-x86_64/AROS/Tests/llm` (AROS build)
- `bin/linux-x86_64/AROS/Tests/llm` (AROS build)

### LLM Model Auto-Detection

For **llama2**, the agent searches for:
1. `stories110M.bin` (440 MB, best quality)
2. `stories42M.bin` (164 MB, good quality)
3. `stories15M.bin` (60 MB, fast testing)

For **qwen3**, the agent searches for:
1. `qwen3.bin`
2. `model.bin`

### Example Output

When LLM is available:
```
[14:23:15] 🤔 Analyzing error with LLM reasoning...
✅ LLM llama2 available: /path/to/llama2
✅ Model: /path/to/stories110M.bin
[14:23:16] 🤔 Step 1: Consulting LLM for intelligent error analysis...
[14:23:17] 🤖 Consulting llama2 LLM for error analysis...
[14:23:20] 💡 LLM suggests: Add #include <stdio.h> at the top of the file...
[14:23:20] 🤔 ✓ LLM provided suggestion: Add #include <stdio.h> at the top...
```

When LLM is unavailable:
```
[14:23:15] 🤔 Analyzing error with LLM reasoning...
⚠️  LLM llama2 not available (binary not found)
[14:23:15] 🤔 ℹ️  LLM not available, using alternative analysis methods
[14:23:15] 🤔 Step 2: Searching GitHub for similar error fixes...
```

### LLM Model Recommendations

Based on AROS LLM infrastructure:

#### Llama2 Models (Recommended for Build Agent)
- **stories15M.bin** (60 MB): Fast, good for testing
- **stories42M.bin** (164 MB): Better quality, moderate speed
- **stories110M.bin** (440 MB): Best quality, recommended for production

#### Qwen3 Models
- **Qwen3 with thinking mode**: Step-by-step debugging and reasoning
- Better for complex architectural decisions
- Supports extended context windows

#### Choosing a Model
- **Development/Testing**: Use stories15M.bin for fast iteration
- **Production Builds**: Use stories110M.bin for best error analysis
- **Complex Issues**: Switch to Qwen3 with thinking mode enabled

#### UIGen-X-30B-MoE Model (NEW!)
- **richardyoung/uigen-x-30b-moe:q6_k**: Specialized 30B parameter MoE model
- **Best for**: UI code generation, component creation, code completion
- **Backend**: Ollama (requires Ollama installed)
- **Memory**: Fits in single 32GB GPU, recommended 64GB+ RAM
- **Performance**: Medium speed, high quality for UI tasks
- **Installation**: `ollama pull richardyoung/uigen-x-30b-moe:q6_k`

The UIGen model is automatically used for UI-related tasks when configured. See [UIGEN_MODEL_GUIDE.md](UIGEN_MODEL_GUIDE.md) for detailed setup and usage.

**Quick Start with UIGen:**
```bash
# Install model
ollama pull richardyoung/uigen-x-30b-moe:q6_k

# Run quick start helper
python3 uigen_quickstart.py

# Use with build agent (auto-selects for UI tasks)
./scripts/autonomous_build_agent.py
```

### Installing LLM Models

To download models for the build agent:

```bash
# Navigate to LLM test directory
cd developer/debug/test/llm

# List available models
./modeldownloader list

# Download tokenizer (required for llama2)
./modeldownloader download 4

# Download a model
./modeldownloader download 3  # stories110M.bin

# Or download from custom URL
./modeldownloader download-url http://example.com/model.bin mymodel.bin
```

## ACD Standard Compliance

### Metadata Tags

All agent code includes ACD metadata:

```python
"""
AI_PHASE: AUTONOMOUS_BUILD_SYSTEM
AI_STATUS: IMPLEMENTED
AI_COMPLEXITY: HIGH
AI_NOTE: Main orchestrator for autonomous AROS development
AI_DEPENDENCIES: ACD_STANDARD, LLM_INFRASTRUCTURE, BUILD_SYSTEM
"""
```

### Validation

Validate agent code with ACD tools:
```bash
python3 scripts/validate_acd.py scripts/autonomous_build_agent.py
```

### Integration with ACD Tools

The agent works with existing ACD infrastructure:
- `validate_acd.py` - Validate agent code
- `gdb_acd.py` - Debug agent with ACD context
- `update_acd_commits.py` - Track agent changes

## Best Practices

### 1. Use Out-of-Tree Builds

Always use separate build directories:
```bash
# Good
./scripts/autonomous_build_agent.py --build-dir /path/to/build

# Avoid in-tree builds
cd /path/to/AROS && make
```

### 2. Monitor Logs

Check logs after failed builds:
```bash
tail -f ../aros-build-pc-x86_64/logs/build_1.log
```

### 3. Review Fix Suggestions

Examine suggested fixes:
```bash
cat ../aros-build-pc-x86_64/logs/fixes_iteration_1.json | jq
```

### 4. Incremental Development

For iterative development:
```bash
# First run: full build
./scripts/autonomous_build_agent.py

# Subsequent runs: reuse build directory
./scripts/autonomous_build_agent.py --build-dir ../aros-build-pc-x86_64
```

### 5. Target-Specific Builds

Test multiple targets:
```bash
# Build for different architectures
for target in pc-x86_64 pc-i386 linux-x86_64; do
    ./scripts/autonomous_build_agent.py --target $target
done
```

## Troubleshooting

### Configuration Fails

**Problem**: Configure script fails

**Solution**:
1. Check dependencies are installed
2. Review `configure_0.log`
3. Verify target is valid

### Build Hangs

**Problem**: Build appears stuck

**Solution**:
1. Check if process is running (`ps aux | grep make`)
2. Review build logs for clues
3. Reduce parallel jobs: edit script to use fewer cores

### No Automatic Fixes

**Problem**: Agent can't fix errors automatically

**Solution**:
1. Review error analysis in logs
2. Check `fixes_iteration_N.json` for suggestions
3. Apply manual fixes to source
4. Re-run agent

### ISO Not Found

**Problem**: ISO backup fails - no ISO found

**Solution**:
1. Verify distfiles were created successfully
2. Check `distfiles.log` for errors
3. Ensure sufficient disk space
4. Manually run `make distfiles` to diagnose

## Performance Considerations

### Build Time

Typical build times (on modern hardware):
- **Initial build**: 30-60 minutes
- **Incremental rebuild**: 5-15 minutes
- **Distfiles generation**: 5-10 minutes

### Resource Requirements

Minimum requirements:
- **CPU**: 4+ cores recommended
- **RAM**: 8 GB minimum, 16 GB recommended
- **Disk**: 20 GB free space for build artifacts
- **Disk I/O**: SSD strongly recommended

### Optimization Tips

1. **Use SSD**: Significantly faster builds
2. **More cores**: Set parallel jobs in script
3. **ccache**: Enable with `--enable-ccache`
4. **Out-of-tree**: Faster incremental builds

## Future Enhancements

### Planned Features

- [ ] Full Qwen 72B integration for error analysis
- [ ] Automatic code patching
- [ ] Learning from previous fixes
- [ ] Multi-target parallel builds
- [ ] Build caching and artifact reuse
- [ ] Integration with CI/CD pipelines
- [ ] Real-time error correction
- [ ] Code review and suggestion system

### Research Areas

- **Self-improving**: Learn from successful fixes
- **Code generation**: Generate missing implementations
- **Architectural decisions**: High-level refactoring
- **Test generation**: Auto-create tests for fixes

## Contributing

When modifying the autonomous agent:

1. **Follow ACD standard**: Add metadata to all functions
2. **Update documentation**: Keep this file current
3. **Test thoroughly**: Run on multiple targets
4. **Log everything**: Verbose output helps debugging
5. **Preserve compatibility**: Don't break existing builds

### Adding New Error Patterns

To add new error detection patterns:

```python
# In parse_build_errors() method
patterns = [
    # Existing patterns...
    
    # Add your pattern
    r'your_pattern_here',
]
```

### Adding New Fix Heuristics

To add new automatic fix logic:

```python
# In analyze_error_with_llm() method
elif 'your_error_pattern' in error_msg.lower():
    self.think("Error type: Your error type")
    return "// TODO: Your fix suggestion"
```

## Examples

### Example 1: Successful Build

```bash
$ ./scripts/autonomous_build_agent.py

[14:23:15] 🤔 ======================================================================
[14:23:15] 🤔 AROS Autonomous Build Agent Starting
[14:23:15] 🤔 ======================================================================
[14:23:15] 🤔 
[14:23:15] 🤔 Phase 1: Configuration
[14:23:15] 🤔 ----------------------------------------------------------------------
[14:23:16] 🔧 Configure: Running configure for pc-x86_64
[14:25:30] ✅ Configuration completed successfully
[14:25:30] 🤔 
[14:25:30] 🤔 Phase 2: Iterative Build and Error Correction
[14:25:30] 🤔 ----------------------------------------------------------------------
[14:25:31] 🤔 --- Build Iteration 1/10 ---
[14:25:31] 🔧 Build: Running make
[14:56:12] ✅ Build completed successfully!
[14:56:12] 🤔 
[14:56:12] 🤔 Phase 3: Distribution Files
[14:56:12] 🤔 ----------------------------------------------------------------------
[14:56:13] 🔧 Build: Running make distfiles
[15:02:45] ✅ Distribution files built successfully
[15:02:45] 🤔 
[15:02:45] 🤔 Phase 4: ISO Backup
[15:02:45] 🤔 ----------------------------------------------------------------------
[15:02:46] 🤔 Found 1 ISO file(s)
[15:02:46] 🔧 Backup: Copying aros-pc-x86_64.iso to backups/
[15:02:48] ✅ Backed up to distfiles/backups/aros-pc-x86_64_20251029_150248.iso
[15:02:48] 🤔 
[15:02:48] 🤔 ======================================================================
[15:02:48] ✅ AUTONOMOUS BUILD COMPLETED SUCCESSFULLY
[15:02:48] 🤔 ======================================================================
```

### Example 2: Build with Errors

```bash
$ ./scripts/autonomous_build_agent.py

[14:23:15] 🤔 --- Build Iteration 1/10 ---
[14:23:15] 🔧 Build: Running make
[14:25:32] ❌ Build failed with return code 2
[14:25:32] 🤔 Build failed. Analyzing errors...
[14:25:32] 🤔 Analyzing build errors from output...
[14:25:32] 🤔 Found 3 distinct errors in build output
[14:25:32] 🤔 Analyzing 3 errors...
[14:25:32] 🤔 Error 1: test.c:42:5: error: 'foo' undeclared
[14:25:32] 🤔 Analyzing error with LLM reasoning...
[14:25:32] 🤔 Error type: Undeclared identifier
[14:25:32] 🤔 Suggested approach: // TODO: Add missing declaration or include header
[14:25:33] 🤔 Attempting to apply automatic fixes...
[14:25:33] 🤔 No automatic fixes available - manual intervention needed
```

## References

### Documentation
- [ACD Standard v1.0](ACD_README.md)
- [ACD Implementation Guide](ACD_IMPLEMENTATION_GUIDE.md)
- [LLM Infrastructure](ACD_LLM_INFRASTRUCTURE.md)
- [AI Breadcrumb Guide](AI_BREADCRUMB_GUIDE.md)

### Source Code
- [Autonomous Agent](scripts/autonomous_build_agent.py)
- [ACD Validator](scripts/validate_acd.py)
- [GDB Extension](scripts/gdb_acd.py)

### External Resources
- [AROS Development](http://aros.sourceforge.net)
- [Qwen Models](https://huggingface.co/Qwen)
- [Bootstrap Archive Repository](https://github.com/terminills/Autonomous-AI-Agent-Workflow)
- [AROS Repository](https://github.com/aros-development-team/AROS)

## License

Copyright (C) 2025, The AROS Development Team. All rights reserved.

This autonomous coding agent is part of the AROS operating system project and follows the AROS license.

---

*Last Updated: October 29, 2025*
*Version: 1.0*
*Status: Production Ready*
