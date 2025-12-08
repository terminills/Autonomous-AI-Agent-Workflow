# UIGen-X-30B-MoE Model Integration Guide

## Overview

The `richardyoung/uigen-x-30b-moe:q6_k` model is a 30-billion parameter Mixture of Experts (MoE) model optimized for UI generation and code generation tasks. It has been integrated into the AROS autonomous build agent infrastructure.

## Model Specifications

- **Model Name**: richardyoung/uigen-x-30b-moe:q6_k
- **Parameters**: 30B (Mixture of Experts architecture)
- **Quantization**: Q6_K (6-bit quantization for efficient memory usage)
- **Backend**: Ollama
- **Memory Requirements**: Fits in single 32GB GPU
- **Recommended RAM**: 64GB or more

## Installation

To use this model, ensure you have Ollama installed and pull the model:

```bash
# Install Ollama (if not already installed)
curl -fsSL https://ollama.ai/install.sh | sh

# Pull the UIGen model
ollama pull richardyoung/uigen-x-30b-moe:q6_k
```

## Use Cases

This model is particularly well-suited for:

1. **UI Code Generation**: Generating user interface code for AROS applications
2. **Code Completion**: Intelligent code completion and suggestions
3. **Build Error Analysis**: Analyzing build errors with UI component context
4. **Component Generation**: Creating new UI components with proper structure

## Configuration

The model is automatically available through the LLM backend infrastructure. It's configured in `llm_config.yaml`:

- Added to `alternative_models` list in the Ollama backend
- Included in `high` tier models for hardware-aware selection
- Configured as preferred model for `ui_generation` tasks
- Listed as second preference for `code_generation` tasks

## Usage Examples

### Using the Autonomous Build Agent

The autonomous build agent will automatically select this model for UI-related tasks:

```bash
# Run the autonomous build agent
cd /path/to/AROS
python3 scripts/autonomous_build_agent.py
```

### Manual Model Selection

To explicitly use this model, update your `llm_config.yaml`:

```yaml
backends:
  ollama:
    model: 'richardyoung/uigen-x-30b-moe:q6_k'
```

### Python API Usage

```python
from llm_backends import LLMBackendManager

# Initialize with configuration
manager = LLMBackendManager(config_path='llm_config.yaml')

# Generate UI code
prompt = "Generate a MUI window class for AROS with a button and text field"
response = manager.generate(prompt, max_tokens=2048)
print(response)
```

## Task-Specific Configuration

The model is configured for specific tasks:

- **UI Generation** (`ui_generation`): Primary choice
- **Code Generation** (`code_generation`): Secondary choice after Qwen2.5-72B
- **Quick Fixes** (`quick_fixes`): Available as fallback option

## Performance Characteristics

- **Inference Speed**: Moderate (MoE architecture provides good efficiency)
- **Quality**: High quality for UI and code generation tasks
- **Context Window**: Standard transformer context window
- **Memory Efficiency**: Q6_K quantization reduces memory footprint while maintaining quality

## Integration with Autonomous Agent

The model integrates seamlessly with the autonomous development agent's capabilities:

1. **ACD-Aware**: Generates code with proper AI breadcrumbs
2. **Error Analysis**: Can analyze UI-related build errors
3. **Code Enhancement**: Suggests UI improvements
4. **Port Generation**: Helps generate UI port skeletons

## Troubleshooting

### Model Not Found

If you get "model not found" errors:
```bash
ollama list  # Check if model is installed
ollama pull richardyoung/uigen-x-30b-moe:q6_k  # Install if missing
```

### Ollama Not Running

Ensure Ollama service is running:
```bash
# Check status
systemctl status ollama  # On systemd systems

# Start service
systemctl start ollama
```

### Memory Issues

If you encounter out-of-memory errors:
- Ensure you have at least 64GB RAM
- Consider using a smaller model from the `medium` tier
- Reduce batch size or context length

## Comparison with Other Models

| Model | Size | Speed | UI Quality | Code Quality | Memory |
|-------|------|-------|------------|--------------|--------|
| uigen-x-30b-moe:q6_k | 30B | Medium | ★★★★★ | ★★★★☆ | 32GB GPU |
| qwen2.5-coder:72b | 72B | Slow | ★★★★☆ | ★★★★★ | 2x32GB GPU |
| qwen2.5-coder:32b | 32B | Medium | ★★★★☆ | ★★★★☆ | 32GB GPU |
| qwen2.5-coder:14b | 14B | Fast | ★★★☆☆ | ★★★★☆ | 16GB GPU |

## Future Enhancements

Planned improvements for UIGen model integration:

- [ ] Fine-tune on AROS-specific UI patterns (MUI, Intuition)
- [ ] Add specialized prompts for AROS UI frameworks
- [ ] Integrate with GUI testing frameworks
- [ ] Create UI component library with model-generated examples

## References

- [Ollama Documentation](https://github.com/ollama/ollama)
- [AROS MUI Documentation](http://aros.sourceforge.net/documentation/developers/mui.php)
- [Autonomous Build Agent Guide](../AUTONOMOUS_CODING_AGENT.md)
- [LLM Backend Architecture](../scripts/llm_backends.py)

## Support

For issues or questions:
1. Check logs in `logs/llm_interactions.log`
2. Verify model availability with `ollama list`
3. Test backend with `python3 scripts/llm_backends.py`
4. Open an issue on your AROS fork GitHub repository
