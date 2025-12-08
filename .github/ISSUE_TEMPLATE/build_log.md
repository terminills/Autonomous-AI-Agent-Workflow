---
name: Build Log
about: Report build failure with logs for AI agent analysis
title: '[BUILD] '
labels: 'build, logs, ai-agent'
assignees: ''
---

## AI_BUILD: [build_YYYYMMDD_HHmmss]
## AI_STATUS: FAILED
## AI_ERRORS: [count]
## AI_WARNINGS: [count]
## AI_TASK: [related_task_identifier]
## AI_ITERATION: [iteration_number]

## Build Information
- **Date:** [YYYY-MM-DD HH:MM:SS]
- **Branch:** [git branch name]
- **Commit:** [git commit hash - use `git rev-parse HEAD`]
- **Platform:** [e.g., linux-x86_64, hosted]
- **Build Type:** [e.g., full build, incremental, specific module]

## Build Command
```bash
[Exact command used to build - should use scripts/capture_build.sh]
```

## Error Summary
[Brief description of the main errors encountered]

### Error Categories
- [ ] Missing headers
- [ ] Undefined symbols
- [ ] API incompatibility
- [ ] Build system issues
- [ ] Configuration problems
- [ ] Other: [specify]

## Build Log
```
[Paste relevant portions of the build log, or indicate log file location]
Log file: docs/phase4/build_logs/build_YYYYMMDD_HHmmss.log
```

## Previous Attempts
[If this is a retry, link to previous build logs and what was tried]
- Iteration 1: [link] - [what was tried]
- Iteration 2: [link] - [what was tried]

## Analysis Request
[What you want the agent to investigate and fix]

## Expected Resolution
[If known, describe what type of fix is needed]

---

**For AI Agent:**
1. Analyze the error log in `docs/phase4/build_logs/`
2. Create error analysis document: `docs/phase4/build_logs/error_analysis_XXX.md`
3. Reference Phase 1 discovery documents for AROS API patterns
4. Propose minimal fixes based on AROS conventions
5. Implement fix and rebuild
6. Update this issue with results
