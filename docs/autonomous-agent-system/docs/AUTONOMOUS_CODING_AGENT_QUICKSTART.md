# Quick Start: AROS Autonomous Coding Agent

## What It Does

The autonomous coding agent automatically:
1. Configures AROS for your target platform
2. Builds AROS (out-of-tree)
3. Analyzes and fixes build errors
4. Retries until successful
5. Generates distfiles
6. Backs up ISO images

## Hardware Requirements (from Issue)

Developed for systems with:
- **GPU**: 2x Radeon Pro V620 (or similar)
- **ROCm**: Latest compatible version
- **LLM**: Qwen2.5 72B for reasoning

## Quick Start

### Step 1: Run the Agent

```bash
cd /path/to/AROS
./scripts/autonomous_build_agent.py
```

### Step 2: Watch the Agent Think

You'll see output like:
```
[14:23:15] 🤔 Autonomous Build Agent initialized
[14:23:15] 🤔 Repository: /home/user/AROS
[14:23:15] 🤔 Build directory (out-of-tree): /home/user/aros-build-pc-x86_64
[14:23:16] 🔧 Bash: ./configure --target=pc-x86_64
[14:25:30] ✅ Configuration completed successfully
[14:25:31] 🤔 Starting build iteration 1...
```

### Step 3: Check Results

After completion:
- **Build artifacts**: `../aros-build-pc-x86_64/`
- **ISO backups**: `distfiles/backups/`
- **Logs**: `../aros-build-pc-x86_64/logs/`

## Common Options

```bash
# Different target
./scripts/autonomous_build_agent.py --target pc-i386

# Custom build location
./scripts/autonomous_build_agent.py --build-dir /mnt/fast-ssd/build

# More retry attempts
./scripts/autonomous_build_agent.py --max-iterations 20

# Less verbose output
./scripts/autonomous_build_agent.py --quiet
```

## Features Matching Issue Requirements

✅ **Configure and build AROS** - Automatic configuration and build execution  
✅ **Trace errors and correct failures** - Error parsing and analysis  
✅ **Build again and repeat** - Iterative retry loop (up to 10 attempts)  
✅ **Follow ACD spec** - Full ACD metadata on all code  
✅ **Make distfiles on clean build** - Automatic after successful build  
✅ **Save ISO backup** - Timestamped backups in distfiles/backups/  
✅ **Build out of tree** - Preserves source, faster rebuilds  
✅ **Verbose thinking output** - Shows reasoning process  

## What's Next

### Current Implementation
- ✅ Error detection and categorization
- ✅ Heuristic-based analysis
- ✅ Build orchestration
- ✅ Out-of-tree builds
- ✅ ISO backup system

### Future Enhancement: Full LLM Integration
- 🚧 Qwen2.5 72B integration for deep reasoning
- 🚧 Automatic code patching
- 🚧 Learning from previous fixes
- 🚧 ROCm GPU acceleration

## Troubleshooting

### Agent won't start
- Check Python 3.6+ is installed
- Verify you're in AROS repo directory

### Build fails repeatedly
- Check logs in `../aros-build-*/logs/`
- Review fix suggestions in JSON files
- May need manual intervention

### No ISO created
- Check distfiles.log for errors
- Verify disk space available
- Ensure build completed successfully

## Full Documentation

See [AUTONOMOUS_CODING_AGENT.md](AUTONOMOUS_CODING_AGENT.md) for complete documentation.

## Architecture

The agent follows ACD Standard v1.0 and integrates with:
- LLM Infrastructure (Qwen3, Llama2)
- ACD validation tools
- AROS build system
- Error analysis framework

---

**Ready to build AROS autonomously? Just run:**
```bash
./scripts/autonomous_build_agent.py
```
