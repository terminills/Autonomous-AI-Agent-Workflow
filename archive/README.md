# Archive Directory

This directory contains archived documentation and examples that are project-specific or superseded.

## Purpose

The main repository serves as a **generic template** for autonomous AI agent workflows. This archive preserves valuable examples and project-specific documentation for reference while keeping the template clean and project-agnostic.

## Contents

### `examples/autonomous-agent-system/`

AROS-specific examples and documentation for autonomous agent systems. These files were originally part of the template but contained too many AROS-specific references and examples.

**What's included:**
- Autonomous agent architecture examples
- Dual-agent system implementation examples
- AI development workflow examples (AROS-specific)
- Breadcrumb and reasoning guides with AROS examples
- Fix cycle examples
- Training data pipeline guides for AROS

**Why archived:**
These documents provide excellent examples of how to implement autonomous agent systems, but they are specific to AROS (Amiga Research Operating System) development and not generic enough for a template repository.

**How to use:**
- Review these as reference examples when implementing autonomous agents for your own project
- Adapt the patterns and approaches to your project's needs
- Use as inspiration for creating your own project-specific documentation

## Archive Policy

### What Gets Archived
- Project-specific documentation with detailed references to specific codebases
- Superseded documentation when better generic versions are created
- Completed agent sessions and historical reference material
- Examples that are too specialized for the generic template

### What Stays in Main Repository
- Generic workflow guides (AGENTIC_AI_WORKFLOW.md)
- Generic standards (ACD specification)
- Reusable scripts and tools
- Issue templates
- Bootstrap guides (made generic)

## Version History

- **2025-12-08**: Initial archive created
  - Moved `autonomous-agent-system/` from `docs/` to `archive/examples/`
  - Contains 28 documents with AROS-specific autonomous agent examples

---

**Note:** This archive is part of the repository to preserve valuable examples and historical context. The archived content remains accessible for reference but is not included in the bootstrap archive distributed to users.
