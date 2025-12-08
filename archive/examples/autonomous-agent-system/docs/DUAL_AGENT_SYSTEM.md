# Dual-Agent Autonomous Build System

## AI_PHASE: DUAL_AGENT_DOCUMENTATION
## AI_STATUS: IMPLEMENTED
## AI_COMPLEXITY: MEDIUM
## AI_NOTE: Complete documentation for dual-agent system with ACD exchange protocol
## AI_DEPENDENCIES: DUAL_AGENT_ORCHESTRATOR, ACD_STANDARD, LLM_BACKENDS

---

## Overview

The Dual-Agent Autonomous Build System coordinates two specialized LLM agents using **ACD (Autonomous Continuous Development) as an exchange of thought** protocol. This architecture enables sophisticated code generation and validation through collaborative reasoning.

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Dual-Agent System                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌────────────────────────┐      ┌────────────────────────┐   │
│  │  Generator Agent       │      │  Reasoning Agent        │   │
│  │  (GPU 0)               │◄────►│  (GPU 1)                │   │
│  ├────────────────────────┤      ├────────────────────────┤   │
│  │ Model:                 │      │ Model:                  │   │
│  │ uigen-x-30b-moe:q6_k   │      │ gpt-oss-abliterated     │   │
│  │                        │      │                         │   │
│  │ Role:                  │      │ Role:                   │   │
│  │ - Code generation      │      │ - Analysis              │   │
│  │ - Solution creation    │      │ - Validation            │   │
│  │ - Refinement           │      │ - Reasoning             │   │
│  └────────────────────────┘      └────────────────────────┘   │
│             │                              │                    │
│             └──────────────┬───────────────┘                    │
│                            ▼                                    │
│                 ┌─────────────────────┐                        │
│                 │  ACD Exchange       │                        │
│                 │  Protocol           │                        │
│                 ├─────────────────────┤                        │
│                 │ • Communication     │                        │
│                 │   Flags             │                        │
│                 │ • Structured        │                        │
│                 │   Messages          │                        │
│                 │ • History Tracking  │                        │
│                 └─────────────────────┘                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Key Components

### 1. Generator Agent

**Model**: `richardyoung/uigen-x-30b-moe:q6_k`
**GPU**: 0
**Role**: Code generation and solution creation

The generator agent specializes in:
- Creating code solutions from problem descriptions
- Generating UI components and interfaces
- Refining code based on reasoning feedback
- Implementing fixes and enhancements

**Characteristics**:
- Higher temperature (0.8) for creative solutions
- Large context window (4096 tokens)
- Specialized MoE architecture for code generation

### 2. Reasoning Agent

**Model**: `huihui_ai/gpt-oss-abliterated`
**GPU**: 1
**Role**: Analysis, validation, and reasoning

The reasoning agent specializes in:
- Analyzing code quality and correctness
- Identifying issues and potential bugs
- Validating solutions against requirements
- Providing structured feedback

**Characteristics**:
- Lower temperature (0.3) for consistent reasoning
- Focused on analysis and validation
- Abliterated model for unrestricted reasoning

### 3. ACD Exchange Protocol

The ACD (Autonomous Continuous Development) exchange protocol provides a structured communication framework between agents.

#### Exchange Phases

1. **Generation**
   - Generator creates initial solution
   - Tags: `AI_PHASE`, `AI_STATUS`, `AI_NOTE`, `AI_COMPLEXITY`
   - Flags: `UNCERTAIN`, `NEEDS_VALIDATION`, `READY`

2. **Reasoning**
   - Reasoner analyzes the solution
   - Tags: `AI_VALIDATION`, `AI_ISSUES`, `AI_SUGGESTIONS`
   - Flags: `UNCERTAIN/CONFIDENT`, `REQUEST_FEEDBACK`, `READY`

3. **Refinement**
   - Generator refines based on feedback
   - Tags: `AI_REFINEMENT`, `AI_CHANGES`, `AI_RATIONALE`
   - Flags: `CONFIDENT`, `NEEDS_VALIDATION`, `READY`

4. **Validation**
   - Reasoner validates refined solution
   - Tags: `AI_VALIDATION_RESULT`, `AI_APPROVAL`
   - Flags: `CONFIDENT`, `DONE`

## Communication Flags

### Confidence Flags

Indicate the agent's confidence level in its output:

- **`CONFIDENT`**: Output is likely correct, minimal review needed
- **`UNCERTAIN`**: Model is unsure, needs validation
- **`HYPOTHESIS`**: Speculative guess, high uncertainty

### Request Flags

Signal the need for feedback or action:

- **`REQUEST_FEEDBACK`**: Needs feedback from another agent
- **`WAITING_FOR_INPUT`**: Waiting for more information
- **`NEEDS_VALIDATION`**: Requires validation before proceeding

### State Flags

Indicate current processing state:

- **`PROCESSING`**: Actively working on task
- **`READY`**: Task completed, ready for next step
- **`DONE`**: Fully completed, no further action needed
- **`BLOCKED`**: Cannot proceed without external input

## Installation

### Prerequisites

1. **Ollama** installed and running
2. **2x GPU** (preferably 32GB each)
3. **Python 3.8+**
4. **PyYAML** (optional, for configuration)

### Install Models

```bash
# Install generator model
ollama pull richardyoung/uigen-x-30b-moe:q6_k

# Install reasoning model
ollama pull huihui_ai/gpt-oss-abliterated

# Verify models are available
ollama list
```

### Configuration

The system uses `llm_config.yaml` for configuration. Key settings:

```yaml
dual_agent:
  enabled: true
  
  generator:
    model: 'richardyoung/uigen-x-30b-moe:q6_k'
    backend: 'ollama'
    gpu_id: 0
    temperature: 0.8
    max_tokens: 4096
    
  reasoner:
    model: 'huihui_ai/gpt-oss-abliterated'
    backend: 'ollama'
    gpu_id: 1
    temperature: 0.3
    max_tokens: 2048
```

## Usage

### Basic Usage

```bash
cd /home/runner/work/AROS/AROS

# Run example
python3 scripts/dual_agent_example.py

# Or directly use orchestrator
python3 scripts/dual_agent_orchestrator.py \
    --problem "Fix undeclared identifier 'printf'" \
    --output results.json
```

### Python API

```python
from dual_agent_orchestrator import DualAgentOrchestrator

# Initialize orchestrator
orchestrator = DualAgentOrchestrator(
    config_path='llm_config.yaml',
    verbose=True
)

# Execute ACD exchange
result = orchestrator.execute_acd_exchange(
    problem_description="Fix compilation error: undeclared 'printf'",
    context={'file': 'test.c', 'error_type': 'undeclared'}
)

# Access results
print(f"Final code: {result['final_code']}")
print(f"Approved: {result['approved']}")
print(f"Iterations: {result['iterations']}")
```

### Advanced Usage

#### Custom Context

```python
context = {
    'file_path': 'src/main.c',
    'error_type': 'undeclared_identifier',
    'build_system': 'gcc',
    'acd_phase': 'BUILD_ERROR_FIX',
    'dependencies': ['stdio.h', 'stdlib.h']
}

result = orchestrator.execute_acd_exchange(
    problem_description="Fix build error",
    context=context
)
```

#### Analyzing Exchange History

```python
for msg in result['exchange_history']:
    print(f"Agent: {msg['agent_role']}")
    print(f"Phase: {msg['phase']}")
    print(f"Confidence: {msg['confidence']}")
    print(f"State: {msg['state']}")
    print(f"Content: {msg['content'][:100]}...")
    print()
```

## GPU Management

### Static GPU Allocation

The system assigns GPUs statically:
- **GPU 0**: Generator agent
- **GPU 1**: Reasoning agent

This allows both agents to run in parallel without conflicts.

### Setting CUDA_VISIBLE_DEVICES

The orchestrator automatically sets `CUDA_VISIBLE_DEVICES` for each agent:

```python
# Generator uses GPU 0
os.environ['CUDA_VISIBLE_DEVICES'] = '0'

# Reasoner uses GPU 1
os.environ['CUDA_VISIBLE_DEVICES'] = '1'
```

### Manual GPU Control

For custom setups, modify `llm_config.yaml`:

```yaml
dual_agent:
  generator:
    gpu_id: 0  # Change to desired GPU
  reasoner:
    gpu_id: 1  # Change to desired GPU
    
  gpu_management:
    cuda_visible_devices: '0,1'  # Update device list
    parallel_execution: true
```

## Exchange Protocol Flow

### Complete Workflow

```
1. Problem Submitted
   │
   ▼
2. Generator: Create Solution
   │ Flags: UNCERTAIN, NEEDS_VALIDATION, READY
   │ ACD: AI_PHASE, AI_STATUS, AI_NOTE
   │
   ▼
3. Reasoner: Analyze Solution
   │ Flags: UNCERTAIN, REQUEST_FEEDBACK, READY
   │ ACD: AI_VALIDATION, AI_ISSUES, AI_SUGGESTIONS
   │
   ▼
4. Check Approval?
   │
   ├─ YES: Done ──────────────────────┐
   │                                  │
   └─ NO: Continue                    │
      │                               │
      ▼                               │
5. Generator: Refine Solution         │
   │ Flags: CONFIDENT, NEEDS_VAL...   │
   │ ACD: AI_REFINEMENT, AI_CHANGES   │
   │                                  │
   ▼                                  │
6. Reasoner: Validate Refinement      │
   │ Flags: CONFIDENT, DONE           │
   │ ACD: AI_VALIDATION_RESULT        │
   │                                  │
   ▼                                  │
7. Check Approval?                    │
   │                                  │
   ├─ YES ────────────────────────────┤
   │                                  │
   └─ NO: Repeat (max 5 iterations)   │
                                      │
                                      ▼
                               8. Final Result
```

### Message Structure

Each exchange message contains:

```json
{
  "agent_role": "generator",
  "content": "Generated code...",
  "phase": "generation",
  "confidence": "UNCERTAIN",
  "request": "NEEDS_VALIDATION",
  "state": "READY",
  "acd_tags": {
    "AI_PHASE": "CODE_GENERATION",
    "AI_STATUS": "GENERATED",
    "AI_NOTE": "Generated solution for...",
    "AI_COMPLEXITY": "MEDIUM"
  },
  "metadata": {},
  "timestamp": "2025-11-01T21:30:00.000Z"
}
```

## Examples

### Example 1: Fix Build Error

**Problem**: Undeclared identifier 'printf'

**Input**:
```c
int main() {
    printf("Hello, World!\n");
    return 0;
}
```

**Generator Output** (Iteration 1):
```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```
Flags: `UNCERTAIN`, `NEEDS_VALIDATION`, `READY`

**Reasoner Analysis**:
```json
{
  "validation": "NEEDS_WORK",
  "issues": ["No error handling", "Missing return value check"],
  "suggestions": ["Add error handling for printf", "Check return value"],
  "confidence": 0.7
}
```
Flags: `UNCERTAIN`, `REQUEST_FEEDBACK`, `READY`

**Generator Refinement**:
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    if (printf("Hello, World!\n") < 0) {
        fprintf(stderr, "Error writing to stdout\n");
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
```
Flags: `CONFIDENT`, `NEEDS_VALIDATION`, `READY`

**Reasoner Validation**:
```json
{
  "validation": "APPROVED",
  "confidence": 0.9,
  "remaining_issues": []
}
```
Flags: `CONFIDENT`, `DONE`

### Example 2: Generate UI Component

**Problem**: Create a React settings dialog

**Generator**: Creates TypeScript React component

**Reasoner**: Validates accessibility, suggests ARIA labels

**Generator**: Adds accessibility features

**Reasoner**: Approves component

## Performance Considerations

### GPU Memory

- **Generator (30B MoE)**: ~20-24GB VRAM
- **Reasoner (abliterated)**: ~16-20GB VRAM
- **Total**: ~40GB across 2x 32GB GPUs

### Speed

- **Generation**: 30-60 seconds (depends on output length)
- **Reasoning**: 15-30 seconds (shorter outputs)
- **Complete cycle**: 2-5 minutes (3-5 iterations typical)

### Optimization Tips

1. **Cache generations** for repeated problems
2. **Batch multiple problems** if independent
3. **Use smaller models** for simple tasks
4. **Enable async communication** for faster exchanges

## Troubleshooting

### Models Not Found

```bash
# Check Ollama is running
ollama list

# Pull missing models
ollama pull richardyoung/uigen-x-30b-moe:q6_k
ollama pull huihui_ai/gpt-oss-abliterated
```

### GPU Out of Memory

```yaml
# Use smaller models in llm_config.yaml
dual_agent:
  generator:
    model: 'qwen2.5-coder:32b'  # Smaller alternative
  reasoner:
    model: 'qwen2.5-coder:14b'  # Smaller alternative
```

### Ollama Connection Error

```bash
# Check Ollama is running
curl http://localhost:11434/api/tags

# Restart Ollama if needed
ollama serve
```

### Exchange Not Converging

Increase max iterations in config:

```yaml
dual_agent:
  acd_exchange:
    max_iterations: 10  # Increase from default 5
```

## Integration with Autonomous Build Agent

The dual-agent system integrates with the autonomous build agent:

```python
from autonomous_build_agent import AutonomousBuildAgent
from dual_agent_orchestrator import DualAgentOrchestrator

# Initialize both systems
build_agent = AutonomousBuildAgent()
dual_agent = DualAgentOrchestrator()

# When build fails
if build_failed:
    # Use dual-agent for sophisticated fix
    result = dual_agent.execute_acd_exchange(
        problem_description=error_message,
        context={'build_log': build_log}
    )
    
    # Apply fix
    build_agent.apply_fix(result['final_code'])
```

## Future Enhancements

- [ ] Dynamic GPU allocation based on load
- [ ] Multi-problem parallel processing
- [ ] Learning from previous exchanges
- [ ] Integration with build system
- [ ] Real-time collaboration visualization
- [ ] Support for 3+ agent configurations
- [ ] Automatic model selection based on problem type
- [ ] Exchange pattern templates for common scenarios

## References

- [ACD Standard Documentation](ACD_README.md)
- [Autonomous Build Agent](AUTONOMOUS_CODING_AGENT.md)
- [LLM Backend Configuration](llm_config.yaml)
- [UIGen Model Guide](UIGEN_MODEL_GUIDE.md)

## License

Copyright (C) 2025, The AROS Development Team. All rights reserved.

---

*Last Updated: November 1, 2025*
*Version: 1.0*
*Status: Production Ready*
