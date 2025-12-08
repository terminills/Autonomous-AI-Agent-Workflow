# GitHub Search and API Difference Analysis

## Overview

The AROS autonomous development agent now includes enhanced GitHub search capabilities that enable it to:
1. **Search GitHub** with authenticated API access for higher rate limits
2. **Find code examples** showing how APIs are implemented across different platforms
3. **Reason about API differences** using LLM-powered analysis
4. **Infer cross-platform compatibility** issues before they occur

This addresses the requirement: *"It should be able to search and reason and infer this will give it the information it needs to deduct API differences across platforms"*

## Features

### 1. Authenticated GitHub API Access

**Benefits:**
- 5,000 requests/hour (vs 60 unauthenticated)
- Access to code search (requires authentication)
- Faster, more reliable searches

**Setup:**
```bash
# Export your GitHub personal access token
export GITHUB_TOKEN="your_token_here"

# Or set in your environment permanently
echo 'export GITHUB_TOKEN="your_token_here"' >> ~/.bashrc
```

**Creating a token:**
1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. Select scopes: `public_repo` (for public repositories)
4. Copy the token and export it as shown above

### 2. Repository and Issue Search

Search for repositories, issues, and solutions on GitHub:

```python
from autonomous_build_agent import WebSearchHelper

# Initialize with token
helper = WebSearchHelper(github_token="your_token")

# Search repositories
repos = helper.search_github_repos("pthread AROS", max_results=5)

# Search issues
issues = helper.search_github_issues("undefined reference pthread_create", max_results=5)
```

### 3. Code Search

Find real-world implementation examples:

```python
# Search for API usage (requires authentication)
code_examples = helper.search_github_code(
    query="pthread_create",
    language="c",
    max_results=10
)

# Results include:
# - Repository name
# - File path
# - Direct URL to code
# - Relevance score
```

**Use cases:**
- Find how others implement specific APIs
- Discover platform-specific workarounds
- Learn best practices from popular projects
- Understand API signatures and usage patterns

### 4. API Difference Analysis

Automatically analyze API differences across platforms:

```python
# Analyze an API across multiple platforms
analysis = helper.analyze_api_differences(
    api_name="pthread_create",
    platforms=["linux", "bsd", "aros", "amiga"],
    llm_backend=llm_backend  # Optional: for AI reasoning
)

# Results include:
# - code_examples: Dict of platform → code examples
# - differences: Known issues from GitHub
# - reasoning: LLM analysis of differences (if available)
# - recommendations: Actionable advice
```

**What it does:**

1. **Searches** for API usage on each platform
2. **Finds** known compatibility issues
3. **Reasons** about differences using LLM (if available)
4. **Recommends** strategies for portable code

**Example output:**
```
🔬 Analyzing API differences for: pthread_create
   Platforms: linux, bsd, aros

   Searching linux implementations...
   ✓ Found 5 linux examples
   
   Searching bsd implementations...
   ✓ Found 4 bsd examples
   
   Searching aros implementations...
   ✗ No aros examples found
   
   Searching for known issues...
   ✓ Found 3 related issues

📊 Analysis complete:
   • Code examples found: 9
   • Platforms covered: 2/3
   • Known issues: 3
   • Recommendations: 2

📋 Recommendations:
   ⚠️  pthread_create may not be available on: aros
   ⚠️  Known compatibility issues exist - review 3 related issues

💡 LLM Reasoning:
   pthread_create has different implementations:
   - Linux: NPTL with full POSIX compliance
   - BSD: Different pthread library with subtle differences
   - AROS: May need custom implementation or wrapper
   
   Key differences:
   1. Stack size defaults vary
   2. Scheduler behavior differs
   3. Error handling not consistent
   
   Recommendation: Use wrapper with platform-specific #ifdefs
```

## Integration with Autonomous Agent

The GitHub search is automatically integrated into the autonomous build agent:

```python
# Initialized automatically when agent starts
agent = AutonomousBuildAgent(repo_path="/path/to/aros")

# GitHub token loaded from environment
# agent.web_search has full search capabilities

# When analyzing errors, agent can:
# 1. Search GitHub for solutions
# 2. Find code examples
# 3. Reason about API differences
# 4. Apply fixes based on real-world usage
```

## Use Cases

### Finding Missing Functions

When you get "undefined reference to pthread_create":

```python
# Search for implementations
analysis = helper.analyze_api_differences("pthread_create")

# Get recommendations
for rec in analysis['recommendations']:
    print(rec)

# Find code examples
if analysis['code_examples']['linux']:
    print("Linux implementation found at:")
    for ex in analysis['code_examples']['linux']:
        print(f"  {ex['repository']}/{ex['path']}")
```

### Porting Libraries

When porting a library from Linux to AROS:

```python
# Analyze all potentially problematic APIs
problematic_apis = [
    "pthread_create",
    "pthread_mutex_init",
    "sem_init",
    "dlopen"
]

for api in problematic_apis:
    print(f"\nAnalyzing {api}...")
    analysis = helper.analyze_api_differences(
        api,
        platforms=["linux", "aros"]
    )
    
    if not analysis['code_examples'].get('aros'):
        print(f"⚠️  {api} not found on AROS - needs implementation")
    
    if analysis['differences']:
        print(f"⚠️  Known issues: {len(analysis['differences'])}")
```

### Learning Platform Differences

Use the agent to learn about platform-specific behavior:

```python
# Compare how signal handling works
signal_analysis = helper.analyze_api_differences(
    "signal",
    platforms=["linux", "bsd", "aros"],
    llm_backend=llm_backend
)

# LLM will reason about differences
print(signal_analysis['reasoning'])

# Get actionable recommendations
for rec in signal_analysis['recommendations']:
    print(rec)
```

## Rate Limits

| Authentication | Requests/Hour | Code Search |
|---------------|---------------|-------------|
| None          | 60            | ❌          |
| Token         | 5,000         | ✅          |

**Recommendations:**
- Always use a token for serious development
- Code search requires authentication
- Check rate limit status: https://api.github.com/rate_limit

## Error Handling

The system gracefully handles common errors:

```python
# No token - limited access
helper = WebSearchHelper()  # Uses 60 req/hour

# Rate limit exceeded - returns empty results
results = helper.search_github_code("...")
# returns [] with warning message

# API errors - logged and handled
if not results:
    print("Search failed - check logs")
```

## Testing

Test the enhanced GitHub search:

```bash
# Basic test (no token required)
python3 scripts/test_github_search.py

# With authentication (recommended)
export GITHUB_TOKEN="your_token"
python3 scripts/test_github_search.py
```

**Expected output:**
```
🧪 Testing Enhanced GitHub Search and API Analysis

Test 1: Basic GitHub Search
  ✅ Repository search works
  ✅ Issue search works

Test 2: Authenticated Search
  ✅ Code search works
  ✅ Higher rate limits active

Test 3: API Difference Analysis
  ✅ Multi-platform search works
  ✅ LLM reasoning works
  ✅ Recommendations generated

Results: 3/3 tests passed
✅ All tests passed!
```

## Advanced Usage

### Custom Platform Comparison

```python
# Compare custom set of platforms
analysis = helper.analyze_api_differences(
    "mmap",
    platforms=["linux", "darwin", "freebsd", "aros"]
)
```

### Language-Specific Search

```python
# Search C++ implementations
cpp_examples = helper.search_github_code(
    "std::thread",
    language="cpp",
    max_results=20
)
```

### Combining with LLM

```python
# Full AI-powered analysis
from llm_backends import LLMBackendManager

llm = LLMBackendManager()
analysis = helper.analyze_api_differences(
    "pthread_create",
    platforms=["linux", "aros"],
    llm_backend=llm.primary_backend
)

# Get detailed reasoning
print(analysis['reasoning'])
```

## Security Considerations

**Token Storage:**
- Never commit tokens to git
- Use environment variables
- Rotate tokens periodically
- Use read-only tokens (public_repo scope)

**Rate Limiting:**
- Respect GitHub's rate limits
- Cache results when possible
- Don't spam the API

## Troubleshooting

### "GitHub token not configured"
```bash
export GITHUB_TOKEN="your_token_here"
```

### "Code search requires authentication"
- Code search needs a token
- Repository and issue search work without token

### "Rate limit exceeded"
- Wait for rate limit reset (shown in error)
- Use authentication for higher limits
- Cache results to reduce requests

### "HTTP Error 401: Unauthorized"
- Token is invalid or expired
- Generate a new token on GitHub
- Check token has correct scopes

## Future Enhancements

Potential improvements:
1. Cache code search results locally
2. Build knowledge base of API differences
3. Automatic API compatibility matrix generation
4. Integration with AROS API documentation
5. Proactive API difference warnings
6. Platform-specific code generation

## See Also

- [Ollama Streaming](OLLAMA_STREAMING.md) - LLM reasoning capabilities
- [ACD Specification](ACD_SPECIFICATION.md) - Code annotation system
- [Autonomous Agent](AUTONOMOUS_AGENT.md) - Agent architecture

## Related GitHub Issues

- "Ollama agent should show thoughts" - Addressed with streaming
- "Scanner should read all files" - Addressed with comprehensive scanning
- "Add GitHub search capability" - This document
