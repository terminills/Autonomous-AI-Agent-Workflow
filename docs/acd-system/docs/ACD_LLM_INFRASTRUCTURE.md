# ACD Documentation: LLM Infrastructure

## AI_PHASE: LLM_INFRASTRUCTURE
## AI_STATUS: IMPLEMENTED
## AI_COMPLEXITY: MEDIUM
## AI_NOTE: Complete LLM inference and model management infrastructure for AROS
## AI_DEPENDENCIES: BSDSOCKET_LIBRARY, FILE_IO, POSIX_MATH

---

## Overview

This document provides ACD (Autonomous Continuous Development) context for the LLM (Large Language Model) infrastructure in AROS. The system includes inference engines for Llama2 and Qwen3 models, plus a model downloader utility.

## Components

### 1. Llama2 Inference Engine
**Location:** `developer/debug/test/llm/llama2.c`
**Status:** AI_STATUS: IMPLEMENTED
**Complexity:** AI_COMPLEXITY: HIGH

Pure C implementation of Llama-2 transformer model inference.

**Key Features:**
- Memory-mapped model loading (or file reading on AROS)
- Transformer architecture with multi-head attention
- RMSNorm normalization
- SwiGLU activation
- BPE tokenization
- Generate and chat modes

**Dependencies:**
- POSIX C library (posixc)
- Math library (libm)
- File I/O operations

### 2. Qwen3 Inference Engine
**Location:** `developer/debug/test/llm/qwen3.c`
**Status:** AI_STATUS: IMPLEMENTED
**Complexity:** AI_COMPLEXITY: HIGH

Pure C implementation of Qwen-3 transformer model with int8 quantization.

**Key Features:**
- INT8 quantized weights for memory efficiency
- QK-RMSNorm for query/key normalization
- Extended context window support
- Thinking mode for reasoning tasks
- Chat mode with system prompts

**Dependencies:**
- POSIX C library (posixc)
- Math library (libm)
- File I/O operations

### 3. Model Downloader
**Location:** `developer/debug/test/llm/modeldownloader.c`
**Status:** AI_STATUS: IMPLEMENTED
**Complexity:** AI_COMPLEXITY: MEDIUM

HTTP-based downloader for LLM model binaries using bsdsocket.library.

**Key Features:**
- Model catalog management
- HTTP download via BSD sockets
- Custom URL support
- Progress tracking
- Network library lifecycle management

**Dependencies:**
- bsdsocket.library v4+
- POSIX C library (posixc)
- TCP/IP networking stack

## Build System Integration

All components are integrated into the AROS MetaMake build system:

```makefile
#MM- test-llm : test-llm-llama2 test-llm-qwen3 test-llm-modeldownloader

%build_prog mmake=test-llm-llama2 \
    progname=llama2 targetdir=$(AROS_TESTS)/llm \
    uselibs="posixc"

%build_prog mmake=test-llm-qwen3 \
    progname=qwen3 targetdir=$(AROS_TESTS)/llm \
    uselibs="posixc"

%build_prog mmake=test-llm-modeldownloader \
    progname=modeldownloader targetdir=$(AROS_TESTS)/llm \
    uselibs="bsdsocket posixc"
```

## Usage Workflow

### Step 1: Download Models
```bash
# List available models
modeldownloader list

# Download a model
modeldownloader download 1
```

### Step 2: Run Inference

**Llama2 - Generate Mode:**
```bash
llama2 stories110M.bin -i "Once upon a time"
```

**Llama2 - Chat Mode:**
```bash
llama2 stories110M.bin -m chat
```

**Qwen3 - Chat Mode:**
```bash
qwen3 model.bin -m chat
```

**Qwen3 - With Thinking:**
```bash
qwen3 model.bin -m chat -r 1
```

## ACD Standard Compliance

This infrastructure follows ACD Standard v1.0 guidelines:

### Metadata Tags
- ✅ AI_PHASE: Component lifecycle tracking
- ✅ AI_STATUS: Implementation status
- ✅ AI_COMPLEXITY: Complexity ratings
- ✅ AI_NOTE: Contextual descriptions
- ✅ AI_DEPENDENCIES: Dependency tracking

### Complexity Distribution

**CRITICAL (0):**
- None currently

**HIGH (2):**
- Llama2 inference engine
- Qwen3 inference engine

**MEDIUM (6):**
- Model downloader
- Network initialization
- URL parsing
- HTTP download engine
- Main entry points
- User interfaces

**LOW (8):**
- Data structures
- Configuration
- Cleanup routines
- Utility functions
- Model listing
- Command parsing

## Architecture Diagram

```
┌─────────────────────────────────────────────────────┐
│                  AROS LLM Infrastructure             │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐ │
│  │   Llama2     │  │    Qwen3     │  │  Model    │ │
│  │   Engine     │  │    Engine    │  │Downloader │ │
│  └──────┬───────┘  └──────┬───────┘  └─────┬─────┘ │
│         │                 │                 │       │
│         └─────────┬───────┴─────────────────┘       │
│                   │                                 │
├───────────────────┼─────────────────────────────────┤
│                   ▼                                 │
│         ┌──────────────────┐                        │
│         │  POSIX C Library │                        │
│         └─────────┬────────┘                        │
│                   │                                 │
│         ┌─────────┴─────────┐                       │
│         │                   │                       │
│    ┌────▼─────┐      ┌─────▼────────┐              │
│    │ File I/O │      │  BSD Sockets │              │
│    └──────────┘      └──────────────┘              │
│                                                      │
└─────────────────────────────────────────────────────┘
```

## Model Catalog

### Available Models

1. **stories15M.bin** (60 MB)
   - Llama2 15M parameter model
   - Good for testing
   - Fast inference

2. **stories42M.bin** (164 MB)
   - Llama2 42M parameter model
   - Better quality
   - Moderate speed

3. **stories110M.bin** (440 MB)
   - Llama2 110M parameter model
   - High quality
   - Recommended for production

4. **tokenizer.bin** (1 MB)
   - Required for Llama2 models
   - BPE tokenizer
   - Download first

### Model Sources

Primary source: [HuggingFace - karpathy/tinyllamas](https://huggingface.co/karpathy/tinyllamas)

## Network Stack Requirements

The model downloader requires:
- Active AROS TCP/IP stack (AROSTCP)
- bsdsocket.library v4 or higher
- Working network interface
- DNS resolution capability

## Testing Strategy

### Unit Testing
Each component can be tested independently:
```bash
# Test model downloader
modeldownloader list

# Test llama2 (requires model)
llama2 stories15M.bin -i "test" -n 50

# Test qwen3 (requires model)
qwen3 model.bin -m generate -i "test"
```

### Integration Testing
Full workflow test:
```bash
# 1. Download model
modeldownloader download 4  # tokenizer
modeldownloader download 1  # stories15M

# 2. Run inference
llama2 stories15M.bin -i "Hello world"
```

## Future Enhancements

### Short Term
- [ ] HTTPS support with SSL/TLS
- [ ] Checksum verification
- [ ] Download resume capability
- [ ] Model compression support

### Medium Term
- [ ] GPU acceleration via RadeonSI
- [ ] Multi-threaded inference
- [ ] Dynamic quantization
- [ ] Model caching system

### Long Term
- [ ] On-device fine-tuning
- [ ] Multi-modal support
- [ ] Distributed inference
- [ ] ONNX runtime integration

## Performance Considerations

### Memory Requirements
- **Llama2 15M:** ~100 MB RAM
- **Llama2 110M:** ~600 MB RAM
- **Qwen3 (quantized):** 30-50% less than FP32

### CPU Optimization
- SSE4.2 and PCLMUL on x86_64
- OpenMP parallelization support
- Efficient matrix operations

### Storage
- Models stored in $(AROS_TESTS)/llm
- Typical model sizes: 60-440 MB
- Recommend SSD for faster loading

## Security Considerations

1. **Network Downloads**
   - HTTP only (unencrypted)
   - No signature verification
   - Trust model sources

2. **Model Execution**
   - Large memory allocations
   - File system access required
   - CPU-intensive operations

3. **Best Practices**
   - Verify download sources
   - Check file sizes
   - Use trusted models only
   - Monitor resource usage

## Documentation References

### Local Documentation
- [Model Downloader Details](developer/debug/test/llm/ACD_MODELDOWNLOADER.md)
- [ACD Standard v1.0](ACD_README.md)
- [ACD Implementation Guide](ACD_IMPLEMENTATION_GUIDE.md)

### Source Code
- [llama2.c](developer/debug/test/llm/llama2.c)
- [qwen3.c](developer/debug/test/llm/qwen3.c)
- [modeldownloader.c](developer/debug/test/llm/modeldownloader.c)
- [mmakefile.src](developer/debug/test/llm/mmakefile.src)

### External Resources
- [Llama2.c Project](https://github.com/karpathy/llama2.c)
- [HuggingFace Models](https://huggingface.co)
- [AROS Developer Guide](http://aros.sourceforge.net)

## Contributing

When modifying LLM infrastructure:

1. **Add ACD metadata** to all new functions
2. **Update complexity ratings** for changed code
3. **Document dependencies** explicitly
4. **Test thoroughly** with various models
5. **Update this document** with changes

### ACD Metadata Template
```c
// AI_PHASE: COMPONENT_NAME
// AI_STATUS: IMPLEMENTED|IN_PROGRESS|PLANNED
// AI_COMPLEXITY: LOW|MEDIUM|HIGH|CRITICAL
// AI_NOTE: Brief description
// AI_DEPENDENCIES: DEPENDENCY1, DEPENDENCY2
```

## License

Copyright (C) 2025, The AROS Development Team. All rights reserved.

Components follow respective licenses:
- Llama2: MIT License (Andrej Karpathy)
- Qwen3: Model-specific license
- Model Downloader: AROS License
