# AI_COMMIT_HISTORY: Context-Aware Evolutionary Tracking

## AI_PHASE: DOCUMENTATION
## AI_STATUS: IMPLEMENTED  
## AI_COMPLEXITY: MEDIUM
## AI_NOTE: Complete guide for AI_COMMIT_HISTORY tracking system
## AI_COMMIT: history_docs_v1

---

## 🎯 Purpose

**AI_COMMIT_HISTORY** provides context-aware historical tracking by maintaining a lineage of changes to specific code sections (functions, classes, or logical code blocks with AI_COMMIT tags). This allows LLMs to understand:

- **How code evolved over time**
- **Why changes were made** (via commit context)
- **What approaches were tried before**
- **Which files co-evolved** (changed together)

### The Key Insight

We **only update AI_COMMIT on sections we change**, which means:

```c
// Section A - Modified recently
AI_COMMIT: networking_fix_v3
AI_COMMIT_HISTORY: initial_impl, bugfix_v1, networking_fix_v2

// Section B - Unchanged for a long time  
AI_COMMIT: initial_impl
AI_COMMIT_HISTORY: 

// This tells the LLM:
// - Section A is actively maintained (3 iterations)
// - Section B is stable (unchanged since creation)
```

---

## 📚 Format

### Basic Structure

```c
AI_COMMIT: <git_commit_hash>
AI_COMMIT_HISTORY: <previous_hash_1>, <previous_hash_2>, ...
```

**Important**: Use actual git commit hashes (7-char short or 40-char full), not arbitrary identifiers!

### Why Git Hashes?

✅ **Unique by design**: Git guarantees uniqueness  
✅ **Traceable**: Can `git show <hash>` to see exact changes  
✅ **No overlap**: Impossible to accidentally reuse  
✅ **Verifiable**: Links directly to git history  
✅ **Automatic**: Git generates them, no manual naming

### Evolution Example

**Initial state:**
```c
/**
 * Network packet handler
 * 
 * AI_PHASE: NETWORK_STACK
 * AI_STATUS: PARTIAL
 * AI_COMPLEXITY: HIGH
 * AI_COMMIT: a3b2c1d
 */
void handle_packet(packet_t *pkt) {
    // Initial implementation
}
```

**After first fix (commit f6e18ee):**
```c
/**
 * Network packet handler
 * 
 * AI_PHASE: NETWORK_STACK
 * AI_STATUS: PARTIAL
 * AI_COMPLEXITY: HIGH
 * AI_COMMIT: f6e18ee
 * AI_COMMIT_HISTORY: a3b2c1d
 */
void handle_packet(packet_t *pkt) {
    // Fixed memory leak
}
```

**After second fix (commit 228bbf9):**
```c
/**
 * Network packet handler
 * 
 * AI_PHASE: NETWORK_STACK
 * AI_STATUS: IMPLEMENTED
 * AI_COMPLEXITY: MEDIUM
 * AI_COMMIT: 228bbf9
 * AI_COMMIT_HISTORY: a3b2c1d, f6e18ee
 */
void handle_packet(packet_t *pkt) {
    // Fixed memory leak + optimized performance
}
```

Now you can:
```bash
# See what changed in each iteration
git show a3b2c1d -- network/packet.c
git show f6e18ee -- network/packet.c  
git show 228bbf9 -- network/packet.c
```

---

## 🔧 Usage

### 1. Manual Updates

Use the `update_commit_history.py` tool:

```bash
# Show current evolution
./scripts/update_commit_history.py show src/network/packet.c

# Update to current git HEAD (automatic)
./scripts/update_commit_history.py update-head src/network/packet.c

# Update with specific git commit hash
./scripts/update_commit_history.py update src/network/packet.c a3b2c1d

# Update specific sections with git hash
./scripts/update_commit_history.py update src/network/packet.c f6e18ee 100:150 200:250
```

**Tip**: After committing changes, use `update-head` to automatically set AI_COMMIT to the latest commit hash!

### 2. Automatic Updates (Autonomous Agent)

The autonomous build agent automatically updates AI_COMMIT tags when fixing errors:

```python
# When agent applies a fix
def apply_fix(self, file_path: str, fix_content: str):
    # Apply the fix
    self._write_fix(file_path, fix_content)
    
    # Commit to git first
    commit_hash = self.git_manager.commit_changes(f"Auto-fix: {error_description}")
    
    # Update AI_COMMIT for this section with the git hash
    update_file_commits(file_path, commit_hash, modified_lines=[(start, end)])
```

### 3. Semantic Index Integration

Query evolutionary history:

```python
from acd_semantic_index import ACDSemanticIndex

index = ACDSemanticIndex('/path/to/repo')
index.scan_codebase()

# Query evolution of a file
evolution = index.query_evolution('src/network/packet.c')
print(f"Evolution depth: {evolution['evolution_depth']}")
print(f"Lineage: {evolution['lineage']}")

# Find files that co-evolved
related = index.find_related_by_evolution('src/network/packet.c')
for r in related:
    print(f"{r['file']}: {r['shared_count']} shared commits")

# Trace a specific commit
files = index.trace_evolution_path('bugfix_v2')
print(f"{len(files)} files changed in bugfix_v2")
```

---

## 🗺️ Benefits for LLMs

### 1. Context-Aware Prompts

**Without AI_COMMIT_HISTORY:**
```
Fix this network code error...
[Shows only current code]
```

**With AI_COMMIT_HISTORY (git hashes):**
```
Fix this network code error...

Evolution History:
  1. a3b2c1d: Initial implementation
  2. f6e18ee: Fixed memory leak
  3. 228bbf9: Optimized performance (CURRENT)

Git blame shows:
  a3b2c1d - Tried simple buffer allocation → leaked memory
  f6e18ee - Added manual free() calls → slow performance
  228bbf9 - Now using memory pool

You can verify:
  $ git show a3b2c1d -- network/packet.c
  $ git show f6e18ee -- network/packet.c

[Shows current code + git-verifiable history]
```

The LLM now knows:
- This code has been iterated 3 times
- Memory leak was an issue
- Performance is a concern
- Memory pool approach is current strategy

### 2. Co-Evolution Detection

Find files that changed together:

```python
# These files share commit history (git hashes are verifiable!)
files_with_shared_evolution = [
    'src/network/packet.c',    # Has: f6e18ee, 228bbf9
    'src/network/socket.c',    # Has: f6e18ee, 228bbf9
    'include/network/proto.h'  # Has: f6e18ee
]

# You can verify they were changed together:
# $ git show f6e18ee --stat
# $ git show 228bbf9 --stat

# LLM insight: "packet.c and socket.c share commits f6e18ee and 228bbf9,
# meaning they were refactored together. Changes to one likely require
# changes to the other."
```

### 3. Evolutionary Similarity

```python
coord1 = CodeCoordinate(
    file_path='graphics/render.c',
    commit_hash='a3b2c1d',
    commit_history=['f0eda57', 'cbeb0c8', '24c55dd']  # Git hashes
)

coord2 = CodeCoordinate(
    file_path='graphics/shader.c', 
    commit_hash='228bbf9',
    commit_history=['f0eda57', 'cbeb0c8']  # Shares early history
)

# Similarity score includes evolutionary overlap
similarity = coord1.similarity(coord2)  
# Higher score because they share 'f0eda57' and 'cbeb0c8'

# Can verify with git:
# $ git show f0eda57 --stat | grep -E "(render|shader)"
# $ git show cbeb0c8 --stat | grep -E "(render|shader)"
```

### 4. Temporal Context Windows

Build context for Qwen 72B with temporal understanding:

```python
def build_temporal_context(file_path: str, index: ACDSemanticIndex, 
                          repo_path: str) -> str:
    """Build context showing how code evolved.
    
    Args:
        file_path: Path to file
        index: Semantic index instance
        repo_path: Path to git repository
    """
    
    evolution = index.query_evolution(file_path)
    
    context = f"# {file_path} - Evolution History\n\n"
    
    # Show progression
    for step in evolution['lineage']:
        context += f"## Step {step['step']}: {step['commit']} ({step['age']})\n"
        # Get code at that point (via git) - example implementation
        try:
            import subprocess
            result = subprocess.run(
                ['git', 'show', f"{step['commit']}:{file_path}"],
                capture_output=True, text=True, cwd=repo_path
            )
            code_at_commit = result.stdout if result.returncode == 0 else '[Code not available]'
        except Exception:
            code_at_commit = '[Error retrieving code]'
            
        context += f"```c\n{code_at_commit[:500]}...\n```\n\n"  # Truncate for context
    
    return context
```

Now Qwen 72B sees the **complete evolution**, not just final state.

---

## 📊 Metrics & Analysis

### Evolution Depth Distribution

```python
# Assuming index is an ACDSemanticIndex instance
stats = index._generate_evolutionary_stats()

print(f"Files with no tracking: {stats['no_commit_tracking']}")
print(f"Average evolution depth: {stats['average_evolution_depth']}")
print(f"Deep history files (5+ changes): {stats['deep_history_files']}")
print(f"Max evolution depth: {stats['max_evolution_depth']}")
```

**Example Output:**
```
Files with no tracking: 123
Average evolution depth: 3.4
Deep history files (5+ changes): 45
Max evolution depth: 12
```

**Insights:**
- **No tracking (123 files)**: Need to add AI_COMMIT tags
- **Average 3.4 iterations**: Healthy iteration rate
- **45 deep history files**: Actively maintained, complex code
- **Max 12 iterations**: One file has been heavily refactored

### Technical Debt from Evolution

```python
def calculate_evolution_debt(file_path: str, index: ACDSemanticIndex) -> float:
    """Files with many iterations but still PARTIAL = high debt
    
    Args:
        file_path: Path to file
        index: Semantic index instance
    """
    
    coord = index.coordinates.get(file_path)
    if not coord:
        return 0.0
    
    if coord.status == 'PARTIAL' and coord.get_evolution_depth() > 5:
        # Many attempts but still incomplete
        return 1.0  # High debt
    elif coord.status == 'IMPLEMENTED' and coord.get_evolution_depth() > 10:
        # Too many changes to "complete" code
        return 0.7  # Medium debt (may need refactor)
    else:
        return 0.0  # Low debt
```

### Co-Evolution Patterns

```python
# Find clusters of files that always change together
def find_coevolution_clusters(index: ACDSemanticIndex):
    """Find clusters of files that frequently co-evolve.
    
    Args:
        index: Semantic index instance
    """
    clusters = []
    
    for file1 in index.coordinates:
        related = index.find_related_by_evolution(file1, min_shared_commits=3)
        
        if len(related) >= 3:
            cluster = [file1] + [r['file'] for r in related[:5]]
            clusters.append({
                'size': len(cluster),
                'files': cluster,
                'coupling': 'tight'  # High co-evolution
            })
    
    return clusters
```

**Output:**
```
Cluster 1: Graphics subsystem (6 files, tight coupling)
  - graphics/driver.c
  - graphics/render.c
  - graphics/shader.c
  - graphics/buffer.c
  - include/graphics/api.h
  - include/graphics/types.h

Insight: These files form a tightly coupled module.
Changes to driver.c will likely require changes to render.c and shader.c.
```

---

## 🎯 Best Practices

### 1. Semantic Commit IDs

Use descriptive commit identifiers:

```c
// ✅ Good
AI_COMMIT: memory_leak_fix_v2
AI_COMMIT: gpu_acceleration_impl
AI_COMMIT: usb_hid_support_v1

// ❌ Avoid
AI_COMMIT: fix1
AI_COMMIT: update
AI_COMMIT: commit_abc123
```

### 2. Update Only Changed Sections

```bash
# ✅ Good: Update only the function you changed
./update_commit_history.py update file.c bugfix_v2 100:150

# ❌ Avoid: Updating entire file when only one function changed
./update_commit_history.py update file.c bugfix_v2
```

This preserves accurate history per section.

### 3. Consistent Naming Convention

```
<category>_<description>_v<version>

Categories:
  - init: Initial implementation
  - bugfix: Bug fixes
  - perf: Performance improvements
  - refactor: Code refactoring
  - feature: New features
  - security: Security fixes

Examples:
  - init_network_stack_v1
  - bugfix_memory_leak_v2
  - perf_cache_optimization_v1
  - refactor_cleanup_v3
  - feature_ipv6_support_v1
  - security_buffer_overflow_v1
```

### 4. Limit History Depth

Keep history manageable:

```python
MAX_HISTORY_DEPTH = 10

def add_to_history(current: str, history: List[str]) -> List[str]:
    """Add current to history, keeping only last N entries."""
    new_history = history + [current]
    return new_history[-MAX_HISTORY_DEPTH:]  # Keep last 10
```

For very old commits, summarize:

```c
AI_COMMIT: latest_commit_v1
AI_COMMIT_HISTORY: ..., ancient_refactor_v5, recent_bugfix_v2, recent_feature_v1
                    ^--- Ellipsis indicates older history exists
```

### 5. Document Major Milestones

For significant changes, add notes:

```c
/**
 * Network packet handler
 * 
 * AI_PHASE: NETWORK_STACK
 * AI_STATUS: IMPLEMENTED
 * AI_COMPLEXITY: MEDIUM
 * AI_COMMIT: complete_rewrite_v1
 * AI_COMMIT_HISTORY: init_v1, bugfix_v1, bugfix_v2, perf_v1
 * AI_NOTE: Completely rewritten in complete_rewrite_v1 to use async I/O
 * AI_STRATEGY: ASYNC_IO
 */
```

---

## 🔍 Advanced Queries

### Find Files with Specific Evolution Patterns

```python
# Files that went from PARTIAL → IMPLEMENTED
def find_completed_implementations(index: ACDSemanticIndex):
    """Find files that evolved from PARTIAL to IMPLEMENTED status.
    
    Args:
        index: Semantic index instance
    """
    results = []
    
    for file_path, coord in index.coordinates.items():
        if coord.status == 'IMPLEMENTED' and coord.commit_history:
            # File is now implemented and has history
            results.append({
                'file': file_path,
                'evolution_depth': coord.get_evolution_depth(),
                'current_status': coord.status
            })
    
    return results
```

### Find "Stable" vs "Volatile" Code

```python
def classify_stability(file_path: str, index: ACDSemanticIndex) -> str:
    """Classify code stability based on evolution depth.
    
    Args:
        file_path: Path to file
        index: Semantic index instance
    """
    coord = index.coordinates.get(file_path)
    if not coord:
        return 'UNKNOWN'
        
    depth = coord.get_evolution_depth()
    
    if depth == 0:
        return 'NEW'  # No history yet
    elif depth <= 2:
        return 'STABLE'  # Few changes
    elif depth <= 5:
        return 'MODERATE'  # Some iteration
    else:
        return 'VOLATILE'  # Frequent changes
```

### Predict Change Risk

```python
def predict_change_risk(file_path: str, index: ACDSemanticIndex) -> Dict[str, Any]:
    """Predict risk of changing a file based on its evolution.
    
    Args:
        file_path: Path to file
        index: Semantic index instance
    """
    
    coord = index.coordinates.get(file_path)
    if not coord:
        return {'risk': 'UNKNOWN', 'reason': 'File not in index'}
    
    # High evolution depth = well-understood code (lower risk)
    # But also = complex history (higher risk if PARTIAL)
    
    depth = coord.get_evolution_depth()
    
    if coord.status == 'PARTIAL' and depth > 5:
        return {
            'risk': 'HIGH',
            'reason': 'Many attempts but still incomplete'
        }
    elif coord.status == 'IMPLEMENTED' and depth < 3:
        return {
            'risk': 'MEDIUM',
            'reason': 'Implemented but not battle-tested'
        }
    elif coord.status == 'IMPLEMENTED' and depth >= 5:
        return {
            'risk': 'LOW',
            'reason': 'Well-tested, stable implementation'
        }
    else:
        return {
            'risk': 'UNKNOWN',
            'reason': 'Insufficient evolution data'
        }
```

---

## 🚀 Integration with Qwen 72B

### Optimal Context Building

```python
def build_qwen_context_with_evolution(error: Dict) -> str:
    """Build context for Qwen 72B including evolutionary history."""
    
    file_path = error['file']
    
    context = []
    
    # 1. Current code
    context.append(f"# Current Code: {file_path}\n")
    context.append(get_file_content(file_path))
    
    # 2. Evolutionary history
    evolution = index.query_evolution(file_path)
    context.append(f"\n# Evolution History (Depth: {evolution['evolution_depth']})\n")
    
    for step in evolution['lineage']:
        context.append(f"## {step['step']}. {step['commit']} ({step['age']})\n")
    
    # 3. Co-evolved files
    related = index.find_related_by_evolution(file_path)
    if related:
        context.append(f"\n# Files that evolved together:\n")
        for r in related[:3]:
            context.append(f"- {r['file']} ({r['shared_count']} shared commits)\n")
    
    # 4. Error context
    context.append(f"\n# Error to Fix:\n{error['msg']}\n")
    
    return '\n'.join(context)
```

### Reasoning Prompts

```
You are analyzing a build error in AROS.

EVOLUTIONARY CONTEXT:
- This file has been modified 7 times (high iteration count)
- Evolution: init_v1 → bugfix_v1 → perf_v1 → bugfix_v2 → refactor_v1 → bugfix_v3 → current
- Previous fixes addressed: memory leaks, performance issues, race conditions
- Co-evolved with: socket.c, protocol.h (suggests tight coupling)

CURRENT ERROR:
undefined reference to `packet_alloc'

ANALYSIS:
Given the evolution history shows multiple bugfixes and a refactor,
and the file co-evolved with socket.c, this is likely a:
1. Result of recent refactor_v1 that moved packet_alloc to another file
2. Missing update to header files during refactoring

RECOMMENDATION:
Check socket.c and protocol.h for packet_alloc definition.
Add proper #include or move function back if it was incorrectly moved.
```

---

## 📝 Summary

**AI_COMMIT_HISTORY** transforms the codebase from:
- "Snapshot in time" → **"Living evolutionary record"**
- "What is the code" → **"How did it become this way"**
- "Static context" → **"Temporal knowledge graph"**

This enables Qwen 72B to:
- ✅ Understand why code looks the way it does
- ✅ See what approaches were already tried
- ✅ Identify patterns of related changes
- ✅ Make informed decisions based on evolution
- ✅ Avoid repeating past mistakes

**The result:** More intelligent, context-aware code generation and error fixing.

---

**Version**: 1.0  
**Status**: Production Ready  
**Last Updated**: 2025-10-30
