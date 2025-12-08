# AROS Autonomous Build Agent - Web Search Capabilities

## Overview

The AROS Autonomous Build Agent has been enhanced with web search capabilities to automatically discover ports, documentation, and fixes for build errors by exploring GitHub and other sources.

## New Features

### 1. GitHub Port Discovery

The agent can now search GitHub for port sources when a dependency is missing during the build process.

**Usage:**
```bash
./scripts/autonomous_build_agent.py --search-port <package-name>
```

**Examples:**
```bash
# Search for libpng
./scripts/autonomous_build_agent.py --search-port libpng

# Search for SDL2
./scripts/autonomous_build_agent.py --search-port SDL2

# Search for boost
./scripts/autonomous_build_agent.py --search-port boost
```

**Output:**
```
[12:38:01] 🤔 Searching for port: libpng
🔍 Searching GitHub: libpng official
  Found 3 repositories
✅ Found libpng: pnggroup/libpng
[12:38:01] ✅ Discovered port: pnggroup/libpng
[12:38:01] 🤔   URL: https://github.com/pnggroup/libpng
[12:38:01] 🤔   Clone: https://github.com/pnggroup/libpng.git
```

### 2. Port Inventory

List all currently available ports in your AROS installation.

**Usage:**
```bash
./scripts/autonomous_build_agent.py --list-ports
```

**Example Output:**
```
[12:37:53] 🤔 Available ports (15): libheif, acpica, libde265, libtiff, 
           glu, jpeg, libaom, libpng, zlib, libwebp, freetype2, 
           mesa, boost, bzip2, codesets
```

### 3. Documentation Search

Search for documentation on GitHub for specific AROS topics.

**Usage:**
```bash
./scripts/autonomous_build_agent.py --search-docs "<topic>"
```

**Examples:**
```bash
# Search for graphics documentation
./scripts/autonomous_build_agent.py --search-docs "AROS graphics"

# Search for driver documentation
./scripts/autonomous_build_agent.py --search-docs "mesa driver"

# Search for specific component documentation
./scripts/autonomous_build_agent.py --search-docs "radeonsi"
```

### 4. Automatic Error Fix Search

During the build process, when errors are encountered, the agent automatically searches GitHub for similar issues and their solutions.

**How it works:**
1. Build error is detected
2. Error message is cleaned and normalized
3. GitHub issues are searched for similar errors
4. Closed issues with solutions are prioritized
5. Results are displayed with links for manual review

**Example:**
```
[12:40:15] 🤔 Analyzing error with LLM reasoning and web search...
[12:40:15] 🤔 Searching GitHub for similar error fixes...
🔍 Searching GitHub issues: undefined reference is:closed
  Found 3 issues
✅ Found 3 potential fixes on GitHub:
  1. Fix undefined reference error - https://github.com/example/repo/issues/123
  2. Resolve linker error - https://github.com/example/repo/issues/456
  3. Add missing library - https://github.com/example/repo/issues/789
```

## Architecture

### WebSearchHelper Class

The new `WebSearchHelper` class provides the following methods:

- `search_github_repos(query, max_results)` - Search GitHub repositories
- `search_github_issues(query, max_results)` - Search GitHub issues
- `find_port_source(package_name)` - Find official port source
- `search_error_fixes(error_message)` - Search for error solutions

### Enhanced AutonomousBuildAgent

The `AutonomousBuildAgent` class has been enhanced with:

- `web_search` - Instance of WebSearchHelper
- `discovered_ports` - List of ports discovered during build
- `search_for_missing_dependency(library_name)` - Search for missing deps
- `discover_available_ports()` - List available ports
- `search_documentation(topic)` - Search for documentation
- Enhanced `analyze_error_with_llm()` - Now includes web search

## API Integration

### GitHub API

The agent uses the GitHub REST API v3 to search for:
- Repositories (sorted by stars)
- Issues (sorted by reactions)
- Documentation repositories

**Note on API Version:** While GitHub REST API v4 (GraphQL) is available, we use v3 (REST) for:
- Simpler integration without GraphQL query complexity
- Better compatibility with standard HTTP libraries
- Sufficient functionality for our search needs
- v3 is still fully supported and maintained by GitHub

**Rate Limits:**
- Unauthenticated: 60 requests per hour
- Authenticated: 5,000 requests per hour (requires GitHub token)

**To use with authentication (optional):**
```python
# Future enhancement - add GitHub token support
export GITHUB_TOKEN="your_token_here"
```

## Logs and Output

### Discovered Ports Log

When the agent discovers new ports during the build, they are logged to:
```
<build-dir>/logs/discovered_ports.json
```

**Format:**
```json
[
  {
    "name": "libpng",
    "source": {
      "name": "libpng",
      "full_name": "pnggroup/libpng",
      "url": "https://github.com/pnggroup/libpng",
      "clone_url": "https://github.com/pnggroup/libpng.git",
      "stars": 1500,
      "language": "C"
    },
    "timestamp": "2025-10-30T12:38:01.123456"
  }
]
```

## Testing

A comprehensive test suite is included:

```bash
cd scripts
python3 test_autonomous_build_agent.py
```

**Test Coverage:**
- WebSearchHelper initialization
- GitHub repository search
- GitHub issue search
- Port source discovery
- Error fix search
- AutonomousBuildAgent initialization
- Port inventory
- Dependency search
- Build error parsing
- Command-line interface

## Use Cases

### Use Case 1: Missing Dependency During Build

**Scenario:** Build fails with "fatal error: png.h: No such file or directory"

**Agent Actions:**
1. Detects missing header file `png.h`
2. Extracts library name: `png` or `libpng`
3. Searches GitHub for `libpng official`
4. Finds `pnggroup/libpng`
5. Logs the discovery to `discovered_ports.json`
6. Displays clone URL for manual integration

### Use Case 2: Unknown Linker Error

**Scenario:** Build fails with "undefined reference to `some_function`"

**Agent Actions:**
1. Parses linker error
2. Searches GitHub issues for similar errors
3. Finds closed issues with solutions
4. Displays top 3 most relevant issues with links
5. Allows developer to review and apply fixes manually

### Use Case 3: Port Exploration

**Scenario:** Developer wants to see what libraries are available

**Agent Actions:**
1. Scans the Ports directory
2. Lists all available ports
3. Developer can search for additional ports on GitHub
4. Facilitates port discovery and integration

## Future Enhancements

### Planned Features

1. **Automatic Port Download**
   - Clone repository automatically
   - Integrate with AROS build system
   - Generate port configuration

2. **Google Search Integration**
   - Search beyond GitHub
   - Find documentation on websites
   - Aggregate results from multiple sources

3. **Machine Learning Fix Suggestions**
   - Train on historical build errors
   - Predict likely fixes
   - Auto-apply safe patches

4. **Port Database**
   - Maintain database of known ports
   - Track versions and compatibility
   - Update notifications

5. **Enhanced Documentation Search**
   - Search wikis and forums
   - Parse documentation automatically
   - Create local knowledge base

## Contributing

To contribute to the web search capabilities:

1. Add new search providers in `WebSearchHelper`
2. Enhance error pattern recognition
3. Improve documentation parsing
4. Add tests for new features
5. Update this README

## Troubleshooting

### Issue: Rate Limit Exceeded

**Error:** `GitHub API rate limit exceeded`

**Solution:**
- Wait for rate limit to reset (check response headers)
- Use GitHub authentication token (future feature)
- Reduce search frequency

### Issue: No Results Found

**Error:** Search returns empty results

**Solution:**
- Try different search terms
- Check internet connectivity
- Verify GitHub is accessible
- Try broader search queries

### Issue: Timeout

**Error:** `urllib.error.URLError: <urlopen error timed out>`

**Solution:**
- Check firewall settings
- Verify proxy configuration
- Increase timeout in code
- Check network connectivity

## References

- [GitHub REST API Documentation](https://docs.github.com/en/rest)
- [AROS Development Wiki](http://aros.sourceforge.net/)
- [ACD Standard v1.0](./AI_AUTONOMOUS_DEVELOPMENT.md)

## License

This code follows the AROS project license. See LICENSE files in the repository root.

---

**AI_PHASE:** WEB_SEARCH_INTEGRATION  
**AI_STATUS:** IMPLEMENTED  
**AI_COMPLEXITY:** MEDIUM  
**AI_NOTE:** Comprehensive web search capabilities for autonomous AROS development
