# Documentation Directory

## AI_PHASE: DOCUMENTATION_ORGANIZATION
## AI_STATUS: COMPLETE
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Generic per-project documentation structure for autonomous agents

---

## Overview

This directory contains all project documentation following the **AGENTIC_AI_WORKFLOW** standard. Documentation is organized **per-project** to prevent cluttered phase directories and provide clear organization for autonomous agents.

This is a **template repository** - when you use this bootstrap in your project, you'll create your own project-specific documentation following this structure.

## Directory Structure

```
docs/
├── README.md                              # This file
├── AGENTIC_AI_WORKFLOW.md                # Master workflow guide
├── GITHUB_SEARCH_API_ANALYSIS.md         # GitHub API reference
├── OLLAMA_STREAMING.md                   # Ollama streaming guide
│
├── acd-system/                           # ACD standard (included in template)
│   └── docs/
│       └── ACD_SPECIFICATION_V1.md       # ACD v1.1.0 specification
│
└── <your-project-name>/                  # Create your project directories
    ├── specs/                            # Project specifications
    ├── docs/                             # Implementation documentation
    └── phases/                           # Active agent sessions
        ├── phase1/                       # Discovery
        ├── phase2/                       # Master Plan
        ├── phase3/                       # Task Segmentation
        ├── phase4/                       # Implementation
        │   └── build_logs/              # Build logs
        └── phase5/                       # Completion
```

## Included Documentation

### Core Workflow
- **AGENTIC_AI_WORKFLOW.md** - Complete 5-phase workflow guide for autonomous development
- **GITHUB_SEARCH_API_ANALYSIS.md** - GitHub API patterns and best practices
- **OLLAMA_STREAMING.md** - Guide for Ollama LLM streaming integration

### Standards
- **acd-system/docs/ACD_SPECIFICATION_V1.md** - Autonomous Continuous Development (ACD) v1.1.0 standard specification

## Creating Your Project Documentation

### Step 1: Create Project Directory

When you start using this template in your repository, create your project directory:

```bash
cd docs/
mkdir -p <your-project-name>/{specs,docs,phases}
```

### Step 2: Set Up Phase Structure

Use the helper script to create the phase directory structure:

```bash
cd docs/<your-project-name>
../../scripts/create_phase_structure.sh
```

This creates:
```
phases/
├── phase1/
├── phase2/
├── phase3/
├── phase4/
│   └── build_logs/
└── phase5/
```

### Step 3: Add Your Specifications

Create specification documents in the `specs/` directory:

```bash
# Example specifications
specs/
├── ARCHITECTURE.md       # Architecture design
├── API_SPEC.md          # API specifications
└── REQUIREMENTS.md       # Requirements
```

### Step 4: Document As You Build

As autonomous agents work on your project, documentation will be created in:

- **specs/** - Design specifications and requirements
- **docs/** - Implementation guides, summaries, and references
- **phases/** - Active work from autonomous agent sessions

## Per-Project Structure Benefits

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

Note the **AI_PROJECT** field to identify which project the document belongs to.

## File Naming Conventions

- Use UPPERCASE for documentation files (e.g., `BUILD_GUIDE.md`)
- Use descriptive prefixes by category:
  - `ACD_*` - ACD-related docs
  - `AI_*` - AI/agent-related guides
  - `AUTONOMOUS_*` - Autonomous agent docs
  - `BUILD_*` - Build guides
  - Project-specific prefixes as appropriate
- Include dates for session-specific docs: `discovery_YYYYMMDD.md`
- Use underscores for word separation

## Archive Policy

### When to Archive
- Completed agent sessions (move phase* dirs to archive/session_YYYYMMDD/)
- Superseded documentation (move to archive/old-versions/)
- Historical reference material

### Archive Structure
```
archive/
├── old-versions/             # Previously superseded docs
├── session_YYYYMMDD/         # Completed agent session
│   ├── phase1/
│   ├── phase2/
│   ├── phase3/
│   ├── phase4/
│   └── phase5/
└── examples/                 # Example implementations
```

## Example Projects

Looking for examples? Check the `archive/examples/` directory in the main repository, which contains real-world examples of how this system has been used (note: these may be project-specific and require adaptation).

## Related Documentation

- Main workflow guide: `AGENTIC_AI_WORKFLOW.md`
- Bootstrap guide: `../BOOTSTRAP_AUTONOMOUS_AGENT.md`
- Documentation entry point: `../DOCUMENTATION_GUIDE.md`
- ACD specification: `acd-system/docs/ACD_SPECIFICATION_V1.md`

---

**For questions or clarifications, refer to:**
- AGENTIC_AI_WORKFLOW.md - Complete workflow guide
- GitHub issue templates in `../.github/ISSUE_TEMPLATE/`
- Helper scripts in `../scripts/`
