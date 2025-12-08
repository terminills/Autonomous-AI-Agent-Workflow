# AROS AI Autonomous Development System

This repository contains the foundation for the **AROS-Cognito** project - a fully autonomous, self-evolving operating system development system powered by AI and guided by the AI Breadcrumb System.

## 🎯 Project Vision

Create a system where a fine-tuned AI model can:
1. **Understand** AROS codebase architecture and patterns
2. **Generate** new code with comprehensive context
3. **Compile** and test its own code
4. **Learn** from compiler errors and runtime failures
5. **Iterate** until code is production-ready
6. **Document** its reasoning and decisions

## 🔗 Related Projects

- **Main AI Training Project**: [ai_breadcrumb_automated_development](https://github.com/terminills/ai_breadcrumb_automated_development)
- **Bootstrap Archive**: [Autonomous-AI-Agent-Workflow](https://github.com/terminills/Autonomous-AI-Agent-Workflow)
- **AROS Repository**: [AROS](https://github.com/aros-development-team/AROS)

## 📚 Core Components

### 1. AI Breadcrumb System

A structured metadata system that transforms AI-generated code from a "black box" into a transparent, self-documenting, and accountable system.

**Key Documentation**:
- [`AI_BREADCRUMB_GUIDE.md`](AI_BREADCRUMB_GUIDE.md) - Complete breadcrumb system guide
- [`compiler/include/aros/ai_metadata.h`](compiler/include/aros/ai_metadata.h) - Metadata standard definition
- [`CONTRIBUTING.md`](CONTRIBUTING.md) - Contribution guidelines with breadcrumb usage

**Core Principle**: "What and Why are more important than How"

### 2. Seed Training Examples

Comprehensive examples demonstrating the complete AI development lifecycle from planning through errors to production code.

**Location**: [`examples/`](examples/)

**Key Examples**:
- `ai_autonomous_seed_kernel_init.c` - Kernel memory initialization (6 iterations)
- `ai_autonomous_seed_graphics.c` - Graphics shader compilation (8 iterations)
- `ai_breadcrumb_enhanced_demo.c` - Comprehensive tag usage

**Documentation**: [`examples/AUTONOMOUS_AI_DEVELOPMENT_README.md`](examples/AUTONOMOUS_AI_DEVELOPMENT_README.md)

### 3. Validation and Extraction Tools

**Validation Script**: [`scripts/validate_ai_breadcrumbs.sh`](scripts/validate_ai_breadcrumbs.sh)
- Validates breadcrumb format and completeness
- Checks for required tags (AI_PHASE, AI_STATUS)
- Verifies tag consistency

**Extraction Script**: [`scripts/extract_ai_training_data.sh`](scripts/extract_ai_training_data.sh)
- Extracts breadcrumb metadata for AI training
- Supports JSON, CSV, and text formats
- Correlates code versions via AI_TRAIN_HASH

## 🚀 Getting Started

### For AI Training

Extract training data from seed examples:

```bash
# Extract as JSON for model training
./scripts/extract_ai_training_data.sh -f json -o training_data.json examples/

# Extract as CSV for analysis
./scripts/extract_ai_training_data.sh -f csv -o training_data.csv examples/

# Extract from entire RadeonSI driver
./scripts/extract_ai_training_data.sh workbench/hidds/radeonsi/
```

### For Validation

Validate breadcrumbs in your code:

```bash
# Validate a single file
./scripts/validate_ai_breadcrumbs.sh path/to/file.c

# Validate a directory
./scripts/validate_ai_breadcrumbs.sh -v workbench/hidds/radeonsi/

# Validate all examples
cd examples/ && make validate
```

### For Development

Create new code with breadcrumbs:

```c
#include <aros/ai_metadata.h>

// AI_PHASE: YOUR_PHASE
// AI_STATUS: PARTIAL
// AI_STRATEGY: Your implementation strategy
// AI_NOTE: Context and next steps
// LINUX_REF: Reference to Linux implementation
// AROS_IMPL: AROS-specific notes
// AI_VERSION: 0.1
// AI_CONTEXT: { "key": "value" }
void your_function(void)
{
    /* Implementation */
}
```

## 🧠 The Compiler-in-Loop Methodology

The autonomous AI development system follows this iterative loop:

```
┌─────────────────────────────────────────────────┐
│  1. AI analyzes context and requirements        │
│     (AI_PHASE, AI_STRATEGY, external refs)      │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│  2. AI generates code with breadcrumbs          │
│     (AI_STATUS: PARTIAL, AI_VERSION: 0.1)       │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│  3. Compile → Capture COMPILER_ERR              │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│  4. AI analyzes error and updates code          │
│     (FIX_REASON, AI_CHANGE, AI_HISTORY)         │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│  5. Runtime test → Capture RUNTIME_ERR          │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│  6. AI fixes and documents pattern              │
│     (AI_PATTERN, AI_TRAIN_HASH)                 │
└────────────┬────────────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────────────┐
│  7. Production ready                            │
│     (AI_STATUS: FIXED, AI_VERSION: 1.0)         │
└─────────────────────────────────────────────────┘
```

## 🎓 Training Pipeline (AROS-Cognito)

### Hardware Setup

Based on the AROS-Cognito specification:

- **OS**: Ubuntu 20.04
- **GPU Stack**: ROCm 5.7.1, PyTorch 2.3.1
- **Accelerators**: 2x AMD Instinct MI25 (gfx900) or compatible
- **Storage**: SSD for fast iteration

### Training Data

1. **Seed Examples**: This repository's `examples/` directory
2. **AROS History**: Full commit history from AROS development team
3. **Error Patterns**: Extracted COMPILER_ERR and RUNTIME_ERR with fixes
4. **Pattern Library**: AI_PATTERN tags across codebase

### Fine-Tuning Process

```bash
# Step 1: Extract training data
./scripts/extract_ai_training_data.sh -f json -o seed_data.json examples/
./scripts/extract_ai_training_data.sh -f json -o driver_data.json workbench/hidds/

# Step 2: Combine with commit history
git log --all --pretty=format:"%H|%an|%ad|%s" > commit_history.txt

# Step 3: Train model (example using PyTorch)
# python train_aros_model.py --seed-data seed_data.json \
#                            --commit-history commit_history.txt \
#                            --model codegen-350M \
#                            --epochs 10

# Step 4: Validate autonomous generation
# python validate_autonomous.py --test-cases examples/
```

## 📊 Breadcrumb Statistics

Current repository breadcrumb coverage:

```bash
# Check coverage across AROS
./scripts/validate_ai_breadcrumbs.sh .

# Expected output for seed examples:
# Files checked: 3
# Valid breadcrumbs: 16
# Invalid breadcrumbs: 0
```

## 🔍 Key Breadcrumb Tags for Training

### Essential Tags (Required)
- `AI_PHASE` - Development phase identifier
- `AI_STATUS` - Implementation status

### Learning Signal Tags (Critical for AI)
- `COMPILER_ERR` - Exact compiler error for pattern learning
- `RUNTIME_ERR` - Runtime failure symptoms
- `FIX_REASON` - Root cause and solution rationale
- `AI_PATTERN` - Reusable pattern identifier
- `AI_TRAIN_HASH` - Training correlation hash

### Context Tags (Rich Information)
- `AI_STRATEGY` - High-level approach
- `AI_HISTORY` - Evolution context
- `AI_CHANGE` - Specific modifications
- `AI_CONTEXT` - JSON metadata
- `LINUX_REF` / `AMIGAOS_REF` - External references

## 🎯 Use Cases

### 1. Fine-Tuning Language Models

Use the seed examples to fine-tune models for:
- AROS-specific API usage patterns
- Error correction strategies
- Incremental development workflows
- Pattern recognition and reuse

### 2. Reinforcement Learning

Use breadcrumb evolution as RL signals:
- **State**: Code version (v0.1, v0.2, etc.)
- **Action**: Code modifications
- **Reward**: Compilation success, test passage
- **Penalty**: COMPILER_ERR, RUNTIME_ERR

### 3. Testing Autonomous Systems

Validate AI capabilities:
- Pattern recognition from examples
- Error diagnosis from COMPILER_ERR
- Solution generation from FIX_REASON
- Feature addition from AI_NOTE

### 4. Code Generation Validation

Ensure AI-generated code quality:
- Breadcrumb completeness
- Reference accuracy
- Pattern consistency
- Version progression

## 📈 Success Metrics

For autonomous AI OS development:

1. **Compilation Success Rate**: % of AI-generated code that compiles
2. **First-Iteration Success**: % that works without fixes
3. **Error Learning**: Reduction in repeated error patterns
4. **Pattern Reuse**: % of solutions using documented AI_PATTERN
5. **Context Utilization**: Effective use of LINUX_REF and AI_HISTORY
6. **Iteration Efficiency**: Average iterations from stub to production

## 🛠️ Development Workflow

### For Human Developers

1. Write code with breadcrumbs for AI training
2. Document errors and fixes comprehensively
3. Use consistent AI_PATTERN naming
4. Validate with `validate_ai_breadcrumbs.sh`
5. Contribute seed examples for new domains

### For AI Systems

1. Analyze breadcrumbs for context and patterns
2. Generate code with comprehensive metadata
3. Capture and learn from errors
4. Document reasoning and evolution
5. Track training correlation with AI_TRAIN_HASH

## 📦 Repository Structure

```
AROS/
├── compiler/include/aros/ai_metadata.h    # Breadcrumb standard
├── scripts/
│   ├── validate_ai_breadcrumbs.sh         # Validation tool
│   └── extract_ai_training_data.sh        # Training extraction
├── examples/
│   ├── AUTONOMOUS_AI_DEVELOPMENT_README.md # Seed examples guide
│   ├── ai_autonomous_seed_kernel_init.c    # Kernel init lifecycle
│   ├── ai_autonomous_seed_graphics.c       # Graphics compilation lifecycle
│   ├── ai_breadcrumb_enhanced_demo.c       # Tag usage demo
│   └── Makefile                            # Build and validation
├── AI_BREADCRUMB_GUIDE.md                 # Complete system guide
└── AI_AUTONOMOUS_DEVELOPMENT.md           # This file
```

## 🤝 Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for general contribution guidelines.

For AI autonomous development contributions:

1. **Seed Examples**: Add new lifecycle examples for different subsystems
2. **Error Patterns**: Document real compiler/runtime errors with fixes
3. **Training Data**: Contribute extracted metadata from your work
4. **Tools**: Improve extraction and validation scripts
5. **Documentation**: Enhance training methodology documentation

## 📄 License

This project is licensed under the APL License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **AROS Development Team**: For the foundational codebase and commit history
- **Linux Kernel**: For reference implementations (LINUX_REF)
- **Mesa Project**: For graphics driver patterns
- **AmigaOS Heritage**: For API design inspiration
- **ROCm/LLVM**: For compilation infrastructure

## 📞 Support

- **AROS-Cognito Project**: See ai_breadcrumb_automated_development repository
- **AROS Development**: AROS development mailing list
- **Issues**: GitHub issues for this repository

---

**"What and Why are more important than How"** - The core principle of transparent, accountable AI development.
