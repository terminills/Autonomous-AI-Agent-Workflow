# Documentation Guide for AI Agents and Developers

## 🏠 Repository Home

**This bootstrap archive is maintained at:** https://github.com/terminills/Autonomous-AI-Agent-Workflow

## 🚨 IMPORTANT: All Documentation is in `docs/`

**All project documentation, specifications, implementation guides, and active development phases are located in the `docs/` directory.**

## Quick Navigation

👉 **START HERE:** [`docs/AGENTIC_AI_WORKFLOW.md`](docs/AGENTIC_AI_WORKFLOW.md) - Complete workflow guide for AI agents

📁 **All Documentation:** [`docs/README.md`](docs/README.md) - Master index of all projects and documentation

## Why This Matters

AI models and developers naturally look at the repository root for documentation. This guide ensures you're directed to the correct location where **all** project documentation lives.

---

## 📂 Documentation Structure

All documentation follows a **per-project structure** under `docs/`:

```
docs/
├── AGENTIC_AI_WORKFLOW.md          # Master workflow guide
├── README.md                        # Documentation index
│
└── <project-name>/                 # Each project has its own directory
    ├── specs/                      # Specifications
    ├── docs/                       # Implementation docs
    └── phases/                     # Active agent sessions
        ├── phase1/                 # Discovery
        ├── phase2/                 # Master Plan
        ├── phase3/                 # Task Segmentation
        ├── phase4/                 # Implementation + build logs
        └── phase5/                 # Completion
```

---

## 🎯 For AI Agents (GitHub Copilot, Local LLMs, etc.)

### Before Starting Any Task:

1. **Read the workflow guide:**
   ```
   docs/AGENTIC_AI_WORKFLOW.md
   ```

2. **Check the documentation index:**
   ```
   docs/README.md
   ```

3. **Navigate to your project:**
   ```
   docs/<project-name>/
   ```

4. **Review project context:**
   - Specifications: `docs/<project-name>/specs/`
   - Existing docs: `docs/<project-name>/docs/`
   - Active work: `docs/<project-name>/phases/`

### ⚠️ DO NOT Create Documentation in Repository Root

All AI-generated documentation MUST go in `docs/<project-name>/`:
- ❌ **WRONG:** `/PROJECT_SPEC.md` (root directory)
- ✅ **CORRECT:** `/docs/<project-name>/specs/PROJECT_SPEC.md`

---

## 📋 Available Projects

Navigate to `docs/` to see all projects:

| Project | Location | Description |
|---------|----------|-------------|
| **ACD System** | `docs/acd-system/` | Autonomous Continuous Development standard |
| **Autonomous Agents** | `docs/autonomous-agent-system/` | AI agent architecture and workflows |
| **AROS Core** | `docs/aros-core/` | Core AROS OS development |
| **Build System** | `docs/build-system/` | Build infrastructure and toolchains |
| **Electron & V8** | `docs/electron-v8/` | Electron integration and V8 porting |
| **Integrations** | `docs/integrations/` | Third-party tool integrations |
| **LLM Infrastructure** | `docs/llm-infrastructure/` | LLM system configuration |
| **RadeonSI Driver** | `docs/radeonsi-driver/` | AMD graphics driver |

**Full list:** See [`docs/README.md`](docs/README.md)

---

## 🔧 Helper Scripts

All helper scripts for agents are in `scripts/`:

```bash
# Set up new project phases
cd docs/<project-name>
../../scripts/create_phase_structure.sh

# Capture build with metadata
./scripts/capture_build.sh "make"

# Analyze build failures
./scripts/analyze_build_log.sh docs/<project>/phases/phase4/build_logs/<log>

# Validate metadata
./scripts/validate_metadata.sh docs/<project>/
```

---

## 📝 For Human Developers

### Finding Documentation

All project documentation is in `docs/`:
1. Open [`docs/README.md`](docs/README.md) for the complete index
2. Navigate to your project: `docs/<project-name>/`
3. Check specs, docs, and active phases

### Adding New Documentation

1. Identify the project (or create a new one)
2. Add files to appropriate subdirectory:
   - Specifications → `docs/<project>/specs/`
   - Guides/docs → `docs/<project>/docs/`
   - Active work → `docs/<project>/phases/`

### Creating a New Project

```bash
# Create project structure
mkdir -p docs/<project-name>/{specs,docs,phases}

# Set up phase directories
cd docs/<project-name>
../../scripts/create_phase_structure.sh

# Add README for the project
cat > docs/<project-name>/README.md << EOF
# <Project Name>

## Overview
[Project description]

## Documentation
- Specs: specs/
- Guides: docs/
- Active work: phases/

## Quick Start
[Getting started guide]
EOF
```

---

## 🎓 Workflow Guide

The complete autonomous agent workflow is defined in:
**[`docs/AGENTIC_AI_WORKFLOW.md`](docs/AGENTIC_AI_WORKFLOW.md)**

This guide includes:
- 5-phase development workflow
- Build log integration
- Error analysis procedures
- Metadata standards
- AROS-specific patterns

**All AI agents must follow this workflow.**

---

## 🔍 Quick Reference

| Need | Location |
|------|----------|
| Workflow guide | `docs/AGENTIC_AI_WORKFLOW.md` |
| Documentation index | `docs/README.md` |
| Project docs | `docs/<project-name>/docs/` |
| Project specs | `docs/<project-name>/specs/` |
| Active sessions | `docs/<project-name>/phases/` |
| Build logs | `docs/<project-name>/phases/phase4/build_logs/` |
| Helper scripts | `scripts/` |
| Issue templates | `.github/ISSUE_TEMPLATE/` |

---

## ⚙️ Metadata Requirements

All AI-generated documents must include:

```markdown
## AI_PHASE: [DISCOVERY|MASTER_PLAN|TASK_SEGMENTATION|IMPLEMENTATION|COMPLETION]
## AI_STATUS: [PENDING|IN_PROGRESS|BLOCKED|COMPLETE|FAILED]
## AI_PROJECT: <project-name>
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: [Brief description]
```

Validate with: `./scripts/validate_metadata.sh docs/<project>/`

---

## 🚀 Getting Started Checklist

### For AI Agents:
- [ ] Read `docs/AGENTIC_AI_WORKFLOW.md`
- [ ] Check `docs/README.md` for project list
- [ ] Navigate to `docs/<project-name>/`
- [ ] Review specs and existing docs
- [ ] Follow 5-phase workflow
- [ ] Use helper scripts for builds
- [ ] Maintain metadata in all documents

### For Developers:
- [ ] Check `docs/README.md` for project index
- [ ] Find your project in `docs/<project-name>/`
- [ ] Review specs in `specs/` subdirectory
- [ ] Check active work in `phases/`
- [ ] Add new docs to appropriate location
- [ ] Use per-project structure for new projects

---

## 📢 Remember

**ALL DOCUMENTATION LIVES IN `docs/`**

Do not create documentation in:
- ❌ Repository root (except this file, README.md, BUILDING.md, CONTRIBUTING.md)
- ❌ Source code directories
- ❌ Build directories
- ❌ Random locations

Always use:
- ✅ `docs/<project-name>/specs/` for specifications
- ✅ `docs/<project-name>/docs/` for implementation docs
- ✅ `docs/<project-name>/phases/` for active agent work

---

## 📚 Core Root Files

These files remain in the repository root:
- **README.md** - Project overview and quick start
- **BUILDING.md** - Build instructions
- **CONTRIBUTING.md** - Contribution guidelines
- **DOCUMENTATION_GUIDE.md** - This file (directs to docs/)
- **LICENSE*** - License files

**Everything else** → `docs/`

---

## 🔗 Essential Links

- **Workflow Guide:** [`docs/AGENTIC_AI_WORKFLOW.md`](docs/AGENTIC_AI_WORKFLOW.md)
- **Documentation Index:** [`docs/README.md`](docs/README.md)
- **ACD System:** [`docs/acd-system/`](docs/acd-system/)
- **Autonomous Agents:** [`docs/autonomous-agent-system/`](docs/autonomous-agent-system/)
- **Build System:** [`docs/build-system/`](docs/build-system/)

**When in doubt, check `docs/README.md` for the complete navigation guide.**

---

**Last Updated:** 2025-12-08  
**Structure Version:** 2.0 (Per-Project)  
**Workflow:** AGENTIC_AI_WORKFLOW
