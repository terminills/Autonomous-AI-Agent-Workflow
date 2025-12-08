# Dual-Agent Quick Start Guide

## AI_PHASE: QUICK_START_GUIDE
## AI_STATUS: IMPLEMENTED
## AI_COMPLEXITY: LOW
## AI_NOTE: Quick start guide for dual-agent autonomous build system

---

## 🚀 Quick Start (5 minutes)

Get the dual-agent system running in 3 easy steps:

### Step 1: Install Ollama and Models

```bash
# Install Ollama (if not already installed)
curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama server
ollama serve &

# Install generator model (UI/code generation specialist)
ollama pull richardyoung/uigen-x-30b-moe:q6_k

# Install reasoning model (analysis and validation)
ollama pull huihui_ai/gpt-oss-abliterated

# Verify models are installed
ollama list
```

### Step 2: Test the System

```bash
cd /home/runner/work/AROS/AROS

# Run interactive example
python3 scripts/dual_agent_example.py

# Select option 1 (build error resolution)
# Watch the agents collaborate!
```

### Step 3: Use for Your Own Problems

```bash
# Solve a build error
python3 scripts/dual_agent_orchestrator.py \
    --problem "Fix undeclared identifier 'printf' in main.c" \
    --output results.json

# Check results
cat results.json | python3 -m json.tool
```

---

## 💡 What Just Happened?

The dual-agent system just:

1. **Generator Agent** (GPU 0) created a code solution
2. **Reasoning Agent** (GPU 1) analyzed and validated it
3. **Generator** refined based on feedback
4. **Reasoner** approved the final solution

All using **ACD exchange protocol** with communication flags!

---

## 🎯 Real-World Examples

### Example 1: Fix Build Error

```bash
python3 scripts/dual_agent_orchestrator.py \
    --problem "Fix compilation error: undeclared 'malloc'" \
    --output fix_malloc.json
```

**What happens:**
- Generator adds `#include <stdlib.h>`
- Reasoner suggests error checking
- Generator adds null pointer checks
- Reasoner approves ✅

### Example 2: Generate UI Component

```bash
python3 scripts/dual_agent_orchestrator.py \
    --problem "Create React modal dialog with confirm/cancel buttons" \
    --output modal_component.json
```

**What happens:**
- Generator creates React component
- Reasoner checks accessibility
- Generator adds ARIA labels
- Reasoner approves ✅

---

## 🔧 Configuration

### Basic Config (llm_config.yaml)

```yaml
dual_agent:
  enabled: true
  
  generator:
    model: 'richardyoung/uigen-x-30b-moe:q6_k'
    gpu_id: 0
    
  reasoner:
    model: 'huihui_ai/gpt-oss-abliterated'
    gpu_id: 1
```

### Custom GPU Assignment

```yaml
dual_agent:
  generator:
    gpu_id: 2  # Use GPU 2 instead of 0
  reasoner:
    gpu_id: 3  # Use GPU 3 instead of 1
```

---

## 📊 Understanding the Output

### JSON Output Structure

```json
{
  "final_code": "/* Generated and validated code */",
  "approved": true,
  "iterations": 2,
  "exchange_history": [
    {
      "agent_role": "generator",
      "phase": "generation",
      "confidence": "UNCERTAIN",
      "state": "READY",
      "content": "..."
    }
  ]
}
```

### Key Fields

- **`final_code`**: The approved solution
- **`approved`**: Whether reasoner approved (true/false)
- **`iterations`**: Number of exchange cycles (typically 1-3)
- **`exchange_history`**: Complete communication log

---

## 🎨 Communication Flags Explained

### Confidence Flags
- **CONFIDENT** 😊 - High confidence, good to go
- **UNCERTAIN** 🤔 - Needs review/validation
- **HYPOTHESIS** 💭 - Speculative, low confidence

### Request Flags
- **REQUEST_FEEDBACK** 🙋 - "Please review this"
- **WAITING_FOR_INPUT** ⏳ - "Need more info"
- **NEEDS_VALIDATION** ✓ - "Ready for validation"

### State Flags
- **PROCESSING** ⚙️ - Currently working
- **READY** ✅ - Task complete, ready
- **DONE** 🎉 - Fully complete
- **BLOCKED** 🚫 - Can't proceed

---

## 🐛 Troubleshooting

### "Ollama backend not available"

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# If not, start it
ollama serve
```

### "Models not found"

```bash
# Re-pull models
ollama pull richardyoung/uigen-x-30b-moe:q6_k
ollama pull huihui_ai/gpt-oss-abliterated
```

### "GPU out of memory"

Use smaller models:

```yaml
dual_agent:
  generator:
    model: 'qwen2.5-coder:32b'  # Smaller
  reasoner:
    model: 'qwen2.5-coder:14b'  # Smaller
```

---

## 🎓 Learn More

- **Full Documentation**: [DUAL_AGENT_SYSTEM.md](DUAL_AGENT_SYSTEM.md)
- **ACD Standard**: [ACD_README.md](ACD_README.md)
- **LLM Configuration**: [llm_config.yaml](llm_config.yaml)
- **Examples**: [scripts/dual_agent_example.py](scripts/dual_agent_example.py)

---

## 🤝 Integration with Build Agent

Use dual-agent system with autonomous build agent:

```python
from autonomous_build_agent import AutonomousBuildAgent
from dual_agent_orchestrator import DualAgentOrchestrator

# When sophisticated reasoning is needed
if complex_error:
    dual_agent = DualAgentOrchestrator()
    result = dual_agent.execute_acd_exchange(
        problem_description=error_msg
    )
    apply_fix(result['final_code'])
```

---

## 💬 FAQ

**Q: Do I need 2 GPUs?**
A: Yes, for full parallel execution. Or use smaller models on 1 GPU.

**Q: Can I use different models?**
A: Yes! Edit `llm_config.yaml` to use any Ollama model.

**Q: How long does it take?**
A: 2-5 minutes for complete exchange (1-3 iterations).

**Q: Does it work without GPUs?**
A: Yes, but slower. Ollama will use CPU inference.

**Q: Can I run without Ollama?**
A: Yes, simulation mode works for testing (no real LLM calls).

---

## ⚡ Next Steps

1. ✅ Run the example
2. ✅ Test with your own problem
3. 📖 Read [DUAL_AGENT_SYSTEM.md](DUAL_AGENT_SYSTEM.md)
4. 🔧 Customize for your needs
5. 🚀 Integrate with your build system

---

**Ready to start?** Run the example now:

```bash
python3 scripts/dual_agent_example.py
```

---

*Last Updated: November 1, 2025*
*Version: 1.0*
