# AROS Documentation Directory

## AI_PHASE: DOCUMENTATION_ORGANIZATION
## AI_STATUS: COMPLETE
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Per-project documentation structure for autonomous agents

---

## Overview

This directory contains all project documentation following the **AGENTIC_AI_WORKFLOW** standard. Documentation is organized **per-project** to prevent cluttered phase directories and provide clear organization for autonomous agents.

## Directory Structure

```
docs/
├── README.md                              # This file
├── AGENTIC_AI_WORKFLOW.md                # Master workflow guide
│
├── <project-name>/                       # Per-project structure
│   ├── specs/                            # Project specifications
│   ├── docs/                             # Project documentation
│   └── phases/                           # Active agent sessions
│       ├── phase1/                       # Discovery
│       ├── phase2/                       # Master Plan
│       ├── phase3/                       # Task Segmentation
│       ├── phase4/                       # Implementation
│       │   └── build_logs/              # Build logs
│       └── phase5/                       # Completion
│
└── archive/                              # Archived documentation
```

## Projects

### 1. **acd-system/** - Autonomous Continuous Development
The ACD (Autonomous Continuous Development) system and standard.

**Contents:**
- ACD specification and standards
- Implementation guides
- Infrastructure documentation
- LLM integration patterns

**Files:** 10 documents

---

### 2. **autonomous-agent-system/** - Autonomous AI Agents
The autonomous coding agent system for AI-driven development.

**Contents:**
- Autonomous agent architecture
- Dual-agent system
- AI development workflows
- Breadcrumb and reasoning guides
- Fix cycle examples

**Files:** 27 documents

---

### 3. **aros-core/** - AROS Core System
Core AROS operating system development and specifications.

**Contents:**
- AmigaOS 3.1 compatibility analysis
- Printer stack implementation
- MUI 5.0 upgrade guide
- Gameport/joystick enhancements
- General implementation summaries

**Files:** 7 documents

---

### 4. **build-system/** - Build Infrastructure
AROS build system, toolchains, and compilation infrastructure.

**Contents:**
- LLVM toolchain workflows
- GCC 15 implementation
- Build artifact generation
- Build configuration guides

**Files:** 11 documents

---

### 5. **electron-v8/** - Electron & V8 Engine
Electron integration and V8 JavaScript engine porting.

**Contents:**
- V8 porting guides
- Electron roadmap
- Integration specifications

**Files:** 3 documents

---

### 6. **integrations/** - Third-Party Integrations
External tool and system integrations.

**Contents:**
- Context7 integration
- Kilocode integration
- EmuMiga integration
- Integration evaluation reports

**Files:** 11 documents

---

### 7. **llm-infrastructure/** - LLM Systems
Large Language Model infrastructure and configuration.

**Contents:**
- Ollama system guides
- Qwen model setup
- LLM downloader
- Auto-install guides

**Files:** 5 documents

---

### 8. **radeonsi-driver/** - RadeonSI Graphics Driver
AMD RadeonSI graphics driver for AROS.

**Contents:**
- RadeonSI build instructions
- LLVM build guide
- Driver implementation status
- Quick start guide

**Files:** 4 documents

---

## Per-Project Structure

Each project follows this structure:

```
<project-name>/
├── specs/                    # Specifications and design docs
│   ├── ARCHITECTURE.md       # Architecture design
│   ├── API_SPEC.md          # API specifications
│   └── REQUIREMENTS.md       # Requirements
│
├── docs/                     # Implementation documentation
│   ├── IMPLEMENTATION_*.md   # Implementation guides
│   ├── GUIDE_*.md           # User/developer guides
│   └── SUMMARY_*.md         # Status summaries
│
└── phases/                   # Active agent sessions
    ├── phase1/              # Discovery & Analysis
    │   └── discovery_YYYYMMDD.md
    ├── phase2/              # Master Plan
    │   └── plan_YYYYMMDD.md
    ├── phase3/              # Task Segmentation
    │   └── tasks_YYYYMMDD.md
    ├── phase4/              # Implementation Loop
    │   ├── iteration_XXX.md
    │   └── build_logs/
    │       ├── build_YYYYMMDD_HHmmss.log
    │       └── error_analysis_XXX.md
    └── phase5/              # Completion
        └── completion_YYYYMMDD.md
```

## Benefits of Per-Project Structure

✅ **No Cluttered Phase Directories**
- Each project maintains its own phase directories
- Easy to track project-specific progress
- Clean separation of concerns

✅ **Clear Project Boundaries**
- All project files in one location
- Specs, docs, and active work together
- Easy to archive completed projects

✅ **Scalable**
- Adding new projects doesn't clutter existing structure
- Each project is self-contained
- Can easily move/archive entire projects

✅ **Agent-Friendly**
- Agents know exactly where to look for project context
- Phase directories scoped to specific projects
- Clear documentation hierarchy

## Usage for AI Agents

### Starting a New Project
1. Create project directory: `docs/<project-name>/`
2. Create subdirectories: `specs/`, `docs/`, `phases/`
3. Run helper script:
   ```bash
   cd docs/<project-name>
   ../../scripts/create_phase_structure.sh
   ```

### Working on Existing Project
1. Navigate to project: `cd docs/<project-name>/`
2. Review specs: `cat specs/*.md`
3. Review existing docs: `ls docs/`
4. Check phase status: `ls phases/phase*/`
5. Follow AGENTIC_AI_WORKFLOW phases

### Build and Test
```bash
# Capture build logs (from project root)
./scripts/capture_build.sh "make"

# Logs saved to: docs/<project-name>/phases/phase4/build_logs/
```

## Helper Scripts

Located in `../scripts/`:

- **capture_build.sh** - Capture build output with metadata
- **analyze_build_log.sh** - Analyze build failures
- **validate_metadata.sh** - Validate document metadata
- **create_phase_structure.sh** - Set up new project phases

## Metadata Standards

All AI-generated documents must include:
```markdown
## AI_PHASE: [DISCOVERY|MASTER_PLAN|TASK_SEGMENTATION|IMPLEMENTATION|COMPLETION]
## AI_STATUS: [PENDING|IN_PROGRESS|BLOCKED|COMPLETE|FAILED]
## AI_PROJECT: <project-name>
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: [Brief description]
```

Note the new **AI_PROJECT** field to identify which project the document belongs to.

## File Naming Conventions

- Use UPPERCASE for documentation files (e.g., `BUILD_GUIDE.md`)
- Use descriptive prefixes by category:
  - `ACD_*` - ACD-related docs
  - `AI_*` - AI/agent-related guides
  - `AUTONOMOUS_*` - Autonomous agent docs
  - `BUILD_*` - Build guides
  - `LLVM_*` - LLVM toolchain docs
  - `OLLAMA_*` - Ollama system docs
  - Project names (e.g., `V8_*`, `ELECTRON_*`)
- Include dates for session-specific docs: `discovery_YYYYMMDD.md`
- Use underscores for word separation

## Archive Policy

### When to Archive
- Completed agent sessions (move phase* dirs to archive/session_YYYYMMDD/)
- Superseded documentation (move to archive/old-root/)
- Historical reference material

### Archive Structure
```
archive/
├── old-root/                 # Previously root-level docs
│   └── [old documentation files]
├── session_20231207/         # Completed agent session
│   ├── phase1/
│   ├── phase2/
│   ├── phase3/
│   ├── phase4/
│   └── phase5/
└── [other archived sessions]
```

## Helper Scripts

Located in `../scripts/`:

- **capture_build.sh** - Capture build output with metadata
- **analyze_build_log.sh** - Analyze build failures
- **validate_metadata.sh** - Validate document metadata
- **create_phase_structure.sh** - Set up new agent session

## Migration Notes

All documentation has been migrated from the root directory to this structured location as of December 2025. This follows the AGENTIC_AI_WORKFLOW principle:

> **Rule:** Never place AI documents in the root directory or in source code folders.

**Exception:** Core project files remain in root:
- README.md
- BUILDING.md
- CONTRIBUTING.md
- LICENSE files

**Note:** SKIAMUI documentation will be migrated separately.

## Related Documentation

- Main workflow guide: `AGENTIC_AI_WORKFLOW.md`
- Autonomous agent guide: `autonomous-agents/AUTONOMOUS_CODING_AGENT.md`
- ACD specification: `acd/ACD_SPECIFICATION_V1.md`
- Dual agent system: `autonomous-agents/DUAL_AGENT_SYSTEM.md`

---

**For questions or clarifications, refer to:**
- AGENTIC_AI_WORKFLOW.md - Complete workflow guide
- GitHub issue templates in `.github/ISSUE_TEMPLATE/`
- Helper scripts in `../scripts/`
