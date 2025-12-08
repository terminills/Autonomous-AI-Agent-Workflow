# AI Training Data Pipeline Guide

This guide explains how to extract and prepare training data from the AROS repository for fine-tuning LLaMA codegen models.

## Pipeline Overview

```
┌─────────────────┐
│  Git History    │
│  (Commits)      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Commit Parser   │  ← git_history_to_training_data.sh
│ (Extract Data)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Breadcrumb     │  ← generate_breadcrumbs.sh
│  Generator      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Annotated      │  ← validate_ai_breadcrumbs.sh
│  Codebase       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Training Data   │  ← extract_ai_training_data.sh
│  Extraction     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  CodeLlama      │
│  Fine-tuning    │
└─────────────────┘
```

---

## Stage 1: Extract Git Commit History

**Tool:** `scripts/git_history_to_training_data.sh`

Extract structured data from Git commits including:
- Commit metadata (author, date, message)
- File changes (diffs)
- Lines added/deleted
- Existing breadcrumb annotations

### Basic Usage

```bash
# Extract last 500 commits
./scripts/git_history_to_training_data.sh -n 500 -o ./data/commits

# Extract commits from last year
./scripts/git_history_to_training_data.sh --since 2024-01-01 -o ./data/2024

# Focus on specific subsystems
./scripts/git_history_to_training_data.sh -p 'rom/exec/*.c rom/kernel/*.c' -o ./data/kernel
```

### Advanced Usage

```bash
# Generate training data with specific constraints
./scripts/git_history_to_training_data.sh \
  -n 1000 \
  --since 2024-01-01 \
  --until 2025-01-01 \
  -m 10 \
  -M 300 \
  -f jsonl \
  -o ./training_data/year_2024 \
  -v

# Extract only commits with breadcrumbs
./scripts/git_history_to_training_data.sh \
  -n 500 \
  --no-diffs \
  -o ./data/breadcrumb_commits
```

### Output Format

The script generates:
- `commits.jsonl` - Training data (one JSON object per line)
- `summary.txt` - Generation statistics

JSONL format example:
```json
{
  "commit": "abc123...",
  "author": "Developer Name",
  "email": "dev@example.com",
  "date": "2024-10-15 10:30:00 +0000",
  "message": "Fix memory leak in allocator",
  "lines_added": 15,
  "lines_deleted": 8,
  "files": [
    {
      "path": "rom/exec/allocmem.c",
      "breadcrumbs": "// AI_PHASE: MEMORY_MANAGEMENT\n// AI_STATUS: FIXED...",
      "diff": "@@ -42,7 +42,10 @@..."
    }
  ]
}
```

---

## Stage 2: Annotate Code with Breadcrumbs

**Tool:** `scripts/generate_breadcrumbs.sh`

Add AI breadcrumbs to code that doesn't have them yet.

### Interactive Mode

```bash
./scripts/generate_breadcrumbs.sh
```

Follow the prompts to:
1. Select AI_PHASE (e.g., MEMORY_MANAGEMENT, KERNEL_INIT)
2. Choose AI_STATUS (e.g., IMPLEMENTED, FIXED)
3. Pick template type (minimal, standard, comprehensive)

### Batch Mode

```bash
# Generate standard breadcrumb
./scripts/generate_breadcrumbs.sh \
  -p MEMORY_MANAGEMENT \
  -s IMPLEMENTED \
  -t standard

# Generate comprehensive breadcrumb for bug fix
./scripts/generate_breadcrumbs.sh \
  -p KERNEL_INIT \
  -s FIXED \
  -t comprehensive \
  --issue 245 \
  --pr 250
```

### Adding Breadcrumbs to Code

1. Generate breadcrumb template
2. Copy to your source file before the function
3. Fill in placeholder values
4. Include `<aros/ai_metadata.h>` in the file

Example:
```c
#include <aros/ai_metadata.h>
#include <exec/types.h>

// AI_PHASE: MEMORY_MANAGEMENT
// AI_STATUS: IMPLEMENTED
// AI_PATTERN: MEMORY_ALLOC_V1
// AI_STRATEGY: Pool-based allocation with size tracking
// AI_DETAILS: Allocates memory from system pool with header for size tracking
// AI_NOTE: Thread-safe implementation using semaphores
// AMIGAOS_REF: exec.library AllocMem() - compatible API
// AROS_IMPL: Adds memory tracking and debugging support
// AI_VERSION: 1.0
APTR AllocMem(ULONG byteSize, ULONG requirements)
{
    // Implementation
}
```

---

## Stage 3: Validate Breadcrumbs

**Tool:** `scripts/validate_ai_breadcrumbs.sh`

Ensure all breadcrumbs are properly formatted.

```bash
# Validate specific file
./scripts/validate_ai_breadcrumbs.sh rom/exec/allocmem.c

# Validate directory
./scripts/validate_ai_breadcrumbs.sh rom/exec/

# Quiet mode for CI/CD
./scripts/validate_ai_breadcrumbs.sh -q rom/
```

---

## Stage 4: Extract Training Examples

**Tool:** `scripts/extract_ai_training_data.sh`

Extract breadcrumb-annotated code as training examples.

```bash
# Extract from specific directory
./scripts/extract_ai_training_data.sh -o ./training_examples rom/exec/

# Generate CSV for analysis
./scripts/extract_ai_training_data.sh -f csv -o training.csv rom/

# Extract all breadcrumb files
find . -name "*.c" -o -name "*.h" | \
  xargs grep -l "AI_PHASE" | \
  xargs ./scripts/extract_ai_training_data.sh
```

---

## Stage 5: Prepare Training Dataset

### Combine All Data Sources

```bash
# Create training dataset directory
mkdir -p ./llama_training_data

# 1. Extract commit history
./scripts/git_history_to_training_data.sh \
  -n 5000 \
  --since 2020-01-01 \
  -o ./llama_training_data/commits

# 2. Extract breadcrumb examples
./scripts/extract_ai_training_data.sh \
  -f jsonl \
  -o ./llama_training_data/breadcrumbs.jsonl \
  rom/ arch/ workbench/

# 3. Analyze coverage
./scripts/analyze_breadcrumb_coverage.sh -p > ./llama_training_data/coverage_report.txt
```

### Generate Training Pairs

Create problem-solution pairs from commits:

```python
# Example Python script to generate training pairs
import json

def extract_training_pairs(commit_data):
    """
    Extract problem-solution pairs from commit data
    
    Returns:
    - Problem: Code before the change + commit message
    - Solution: Code after the change + breadcrumb annotations
    """
    pairs = []
    
    for commit in commit_data:
        if commit['lines_added'] > 0 and commit['lines_deleted'] > 0:
            # This is a code change, not just addition
            for file in commit['files']:
                if 'breadcrumbs' in file:
                    pair = {
                        'problem': {
                            'context': commit['message'],
                            'before': extract_before_code(file['diff']),
                            'file': file['path']
                        },
                        'solution': {
                            'after': extract_after_code(file['diff']),
                            'breadcrumbs': file['breadcrumbs'],
                            'explanation': extract_fix_reason(file['breadcrumbs'])
                        }
                    }
                    pairs.append(pair)
    
    return pairs

# Load commit data
with open('commits.jsonl', 'r') as f:
    commits = [json.loads(line) for line in f]

# Generate pairs
training_pairs = extract_training_pairs(commits)

# Save for training
with open('training_pairs.jsonl', 'w') as f:
    for pair in training_pairs:
        f.write(json.dumps(pair) + '\n')
```

---

## Training Data Categories

### 1. Error Correction Examples

**Source:** Commits with COMPILER_ERR or RUNTIME_ERR breadcrumbs

**Format:**
```json
{
  "input": "Code with error + error message",
  "output": "Fixed code + FIX_REASON explanation"
}
```

**Usage:** Train model to fix common errors

### 2. Implementation Patterns

**Source:** Files with AI_PATTERN tags

**Format:**
```json
{
  "pattern": "MEMORY_ALLOC_V1",
  "examples": [
    {"code": "...", "context": "..."},
    {"code": "...", "context": "..."}
  ]
}
```

**Usage:** Train model to recognize and replicate patterns

### 3. Cross-Platform Porting

**Source:** Files with LINUX_REF → AROS_IMPL mappings

**Format:**
```json
{
  "linux_code": "...",
  "linux_ref": "mm/slab.c",
  "aros_code": "...",
  "adaptations": "Uses exec.library instead of kernel allocator"
}
```

**Usage:** Train model for platform adaptation

### 4. Historical Evolution

**Source:** Commits with AI_HISTORY tags

**Format:**
```json
{
  "versions": [
    {"version": "0.1", "code": "...", "issues": "..."},
    {"version": "0.2", "code": "...", "fixes": "..."},
    {"version": "1.0", "code": "...", "improvements": "..."}
  ]
}
```

**Usage:** Train model on iterative improvement

---

## LLaMA Fine-Tuning

### Prepare Training Format

Convert JSONL to LLaMA training format:

```python
import json

def convert_to_llama_format(commit_data):
    """
    Convert commit data to LLaMA instruction-tuning format
    """
    examples = []
    
    for commit in commit_data:
        for file in commit.get('files', []):
            if 'breadcrumbs' in file:
                example = {
                    "instruction": f"Implement the following code change: {commit['message']}",
                    "input": f"File: {file['path']}\n\nContext: {extract_context(file['diff'])}",
                    "output": f"```c\n{extract_after_code(file['diff'])}\n```\n\n{file['breadcrumbs']}"
                }
                examples.append(example)
    
    return examples

# Convert data
with open('commits.jsonl', 'r') as f:
    commits = [json.loads(line) for line in f]

training_data = convert_to_llama_format(commits)

with open('llama_training.jsonl', 'w') as f:
    for example in training_data:
        f.write(json.dumps(example) + '\n')
```

### Training Configuration

Example configuration for fine-tuning CodeLlama:

```yaml
# training_config.yaml
model:
  base_model: "codellama/CodeLlama-7b-hf"
  
training:
  num_epochs: 3
  batch_size: 4
  learning_rate: 2e-5
  warmup_steps: 100
  
data:
  train_file: "llama_training.jsonl"
  validation_split: 0.1
  max_seq_length: 2048
  
output:
  model_dir: "./aros_codellama_finetuned"
  checkpoint_steps: 500
```

### Run Training

```bash
# Using Hugging Face Transformers
python train_llama.py \
  --config training_config.yaml \
  --data_dir ./llama_training_data \
  --output_dir ./models/aros_codellama

# Monitor training
tensorboard --logdir ./models/aros_codellama/logs
```

---

## Quality Metrics

### Training Data Quality

1. **Coverage**: Percentage of code with breadcrumbs
   - Target: >0.5% initially, >5% long-term
   
2. **Breadcrumb Completeness**: Required tags present
   - Target: 100% of breadcrumbs have AI_PHASE and AI_STATUS
   
3. **Pattern Diversity**: Unique AI_PATTERN values
   - Target: >50 distinct patterns
   
4. **Error Examples**: Commits with error corrections
   - Target: >100 error-fix pairs

### Model Performance

1. **Code Completion Accuracy**
   - Test on held-out AROS code
   - Measure exact match and fuzzy match rates
   
2. **Error Detection**
   - Can model identify common errors?
   - Compare against static analysis tools
   
3. **Pattern Recognition**
   - Can model replicate AROS-specific patterns?
   - Test on pattern generation tasks

---

## Best Practices

### 1. Data Diversity

- Include commits from multiple subsystems
- Mix error fixes, features, refactoring
- Include both simple and complex changes

### 2. Data Quality

- Validate all breadcrumbs before extraction
- Filter commits with too many/too few changes
- Remove auto-generated or merge commits

### 3. Incremental Updates

- Regularly extract new commits
- Update training data monthly
- Retrain model periodically

### 4. Evaluation

- Hold out 10% of data for validation
- Test on real development tasks
- Gather feedback from developers

---

## Troubleshooting

### Issue: Empty training data

**Solution:** Check filters (min/max lines, file patterns)
```bash
./scripts/git_history_to_training_data.sh -v -m 1 -M 10000
```

### Issue: Too many commits

**Solution:** Use date filters
```bash
./scripts/git_history_to_training_data.sh --since 2024-01-01 --until 2024-12-31
```

### Issue: Missing breadcrumbs

**Solution:** Generate breadcrumbs for existing code
```bash
# Identify files without breadcrumbs
./scripts/analyze_breadcrumb_coverage.sh -d rom/exec/

# Add breadcrumbs using generator
./scripts/generate_breadcrumbs.sh
```

### Issue: Validation errors

**Solution:** Fix breadcrumb formatting
```bash
./scripts/validate_ai_breadcrumbs.sh -v problem_file.c
```

---

## Example Workflow

Complete workflow for generating training data:

```bash
#!/bin/bash

# 1. Create output directory
mkdir -p ./aros_training_data

# 2. Extract commit history (last 2 years)
./scripts/git_history_to_training_data.sh \
  --since 2023-01-01 \
  -n 3000 \
  -m 5 \
  -M 400 \
  -f jsonl \
  -o ./aros_training_data/commits \
  -v

# 3. Extract breadcrumb examples
./scripts/extract_ai_training_data.sh \
  -f jsonl \
  -o ./aros_training_data/breadcrumbs.jsonl \
  rom/ arch/ workbench/

# 4. Generate coverage report
./scripts/analyze_breadcrumb_coverage.sh -p > ./aros_training_data/coverage.txt

# 5. Validate all breadcrumbs
./scripts/validate_ai_breadcrumbs.sh -q rom/ arch/ workbench/ || echo "Validation warnings found"

# 6. Generate summary
cat > ./aros_training_data/README.md <<EOF
# AROS Training Data

Generated: $(date)

## Contents

- commits/ - Git commit history data
- breadcrumbs.jsonl - Extracted breadcrumb examples
- coverage.txt - Breadcrumb coverage report

## Statistics

- Total commits: $(wc -l < ./aros_training_data/commits/commits.jsonl)
- Files with breadcrumbs: $(grep -c '"has_breadcrumbs": true' ./aros_training_data/breadcrumbs.jsonl)

## Next Steps

1. Convert to LLaMA training format
2. Split into train/validation sets
3. Fine-tune CodeLlama model
4. Evaluate on held-out test set

See TRAINING_DATA_PIPELINE_GUIDE.md for details.
EOF

echo "Training data generation complete!"
echo "Output directory: ./aros_training_data"
```

---

## References

- **Repository Evaluation**: `BREADCRUMB_REPO_EVALUATION.md`
- **Implementation Guide**: `BREADCRUMB_IMPLEMENTATION_GUIDE.md`
- **Scripts Documentation**: `scripts/AI_BREADCRUMB_SCRIPTS_README.md`
- **Breadcrumb Guide**: `AI_BREADCRUMB_GUIDE.md`

---

**Version:** 1.0  
**Last Updated:** October 15, 2025  
**Status:** Production Ready
