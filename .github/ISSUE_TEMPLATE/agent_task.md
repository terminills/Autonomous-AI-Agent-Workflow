---
name: Agent Task
about: Task for autonomous AI agent following AGENTIC_AI_WORKFLOW
title: '[AGENT] '
labels: 'ai-agent, task'
assignees: ''
---

## AI_PHASE: [DISCOVERY|MASTER_PLAN|TASK_SEGMENTATION|IMPLEMENTATION|COMPLETION]
## AI_STATUS: [PENDING|IN_PROGRESS|BLOCKED|COMPLETE]
## AI_COMPLEXITY: [LOW|MEDIUM|HIGH|CRITICAL]
## AI_PRIORITY: [LOW|MEDIUM|HIGH|CRITICAL]
## AI_ASSIGNED_TO: [Agent identifier - e.g., copilot, local-llm]

## Task Description
[Clear description of what needs to be accomplished]

## Context
[Background information and references to discovery/planning documents in docs/]

## Dependencies
- [ ] Dependency 1
- [ ] Dependency 2

## Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Documentation Location
[Path to relevant phase documents in docs/ directory]
- Discovery: `docs/phase1/`
- Plan: `docs/phase2/`
- Tasks: `docs/phase3/`
- Implementation: `docs/phase4/`

## Build Logs
[Links to build logs if applicable - should be in docs/phase4/build_logs/]

## Notes
[Additional information for the agent]

---

**Agent Instructions:**
1. Read the [AGENTIC_AI_WORKFLOW](../../../docs/AGENTIC_AI_WORKFLOW.md) guide
2. Follow the phase structure (Discovery → Planning → Segmentation → Implementation → Completion)
3. Document all findings in `docs/` with proper metadata
4. Capture all build logs using `scripts/capture_build.sh`
5. Commit changes with `AI_COMMIT` tags
6. Update this issue with progress
