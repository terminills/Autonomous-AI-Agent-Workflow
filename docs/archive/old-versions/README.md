# Old Versions Directory

## AI_PHASE: DOCUMENTATION_ORGANIZATION
## AI_STATUS: COMPLETE
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
## AI_NOTE: Archive for superseded documentation versions

---

## Overview

This directory stores previous versions of documentation, specifications, and guides that have been superseded by newer versions. Maintaining old versions provides historical context and helps track the evolution of the project.

## Purpose

Archiving old versions helps with:
- **Version tracking** - Understanding how documentation evolved
- **Historical reference** - Looking back at previous approaches
- **Migration support** - Helping users transition from old to new versions
- **Audit trail** - Maintaining a complete record of changes

## Current Status

🚀 **Clean Bootstrap State**

This directory is currently empty as part of the clean bootstrap condition. As documentation evolves and new versions are created, superseded versions will be archived here.

## What Belongs Here

### Documentation to Archive
- Superseded specifications
- Previous workflow versions
- Outdated implementation guides
- Deprecated API documentation
- Old standard versions
- Historical design documents

### What NOT to Archive
- Current active documentation
- Work in progress
- Incomplete drafts
- Test documents

## Archive Structure

When old versions are archived, they should follow this structure:

```
old-versions/
├── <project-name>/
│   ├── README.md                    # Version history for project
│   ├── SPEC_V1.0.md                # Old specification version
│   ├── GUIDE_V2.3.md               # Superseded guide
│   └── deprecated_YYYYMMDD/         # Batch of deprecated docs
│       └── ...
└── workflow-versions/
    ├── AGENTIC_AI_WORKFLOW_V1.0.md
    └── AGENTIC_AI_WORKFLOW_V2.0.md
```

## Required Metadata

All archived documents MUST include this metadata at the top:

```markdown
## ARCHIVED: YYYY-MM-DD
## SUPERSEDED_BY: <filename or URL>
## REASON: <brief explanation>
## LAST_ACTIVE_VERSION: <version number>
## AI_PROJECT: <project-name>
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
```

### Example Metadata

```markdown
## ARCHIVED: 2025-12-08
## SUPERSEDED_BY: docs/build-system/specs/BUILD_SPEC_V3.0.md
## REASON: Updated to support new build toolchain
## LAST_ACTIVE_VERSION: 2.1
## AI_PROJECT: build-system
## AI_WORKFLOW: AGENTIC_AI_WORKFLOW
```

## How to Archive Documentation

### Step 1: Prepare the Document

Add archive metadata to the top of the document:

```bash
# Create archive header
cat > /tmp/archive_header.md << 'EOF'
## ARCHIVED: $(date +%Y-%m-%d)
## SUPERSEDED_BY: <path-to-new-version>
## REASON: <explanation>
## LAST_ACTIVE_VERSION: <version>

---
**⚠️ ARCHIVED DOCUMENT - DO NOT USE FOR CURRENT DEVELOPMENT**
---

EOF

# Prepend to document
cat /tmp/archive_header.md old_document.md > temp.md
mv temp.md old_document.md
```

### Step 2: Move to Archive

```bash
# Create project directory if needed
mkdir -p docs/archive/old-versions/<project-name>/

# Move the document
mv docs/<project-name>/specs/OLD_SPEC.md \
   docs/archive/old-versions/<project-name>/OLD_SPEC_V1.0.md

# Update any references
grep -r "OLD_SPEC.md" docs/ # Find references
# Update them to point to new version
```

### Step 3: Update Version Tracking

Create or update the project's version history:

```bash
# Create/update version history
cat >> docs/archive/old-versions/<project-name>/README.md << EOF

## Version History Entry

### <Document Name> V<X.Y>
- **Archived:** $(date +%Y-%m-%d)
- **Superseded By:** <new version>
- **Reason:** <explanation>
- **Location:** \`<filename>\`

EOF
```

## Version Tracking

### Naming Conventions

When archiving, use clear version identifiers:

- `SPEC_V1.0.md` - Major version 1, minor version 0
- `GUIDE_V2.3.md` - Major version 2, minor version 3
- `WORKFLOW_2025-01-15.md` - Date-based versioning

### Version History Format

Each project should maintain a version history in its README:

```markdown
# Version History for <Project Name>

## Current Version
- **File:** docs/<project>/specs/SPEC_V3.0.md
- **Date:** 2025-12-08
- **Status:** Active

## Previous Versions

### V2.1 (Archived)
- **File:** old-versions/<project>/SPEC_V2.1.md
- **Date:** 2025-06-15
- **Superseded:** 2025-12-08
- **Reason:** Updated API specifications

### V1.0 (Archived)
- **File:** old-versions/<project>/SPEC_V1.0.md
- **Date:** 2024-01-01
- **Superseded:** 2025-06-15
- **Reason:** Complete redesign
```

## Accessing Old Versions

### Finding Archived Documents

```bash
# List all archived versions
find docs/archive/old-versions/ -type f -name "*.md"

# Search for specific project
ls docs/archive/old-versions/<project-name>/

# Find specific version
find docs/archive/old-versions/ -name "*V1.0*"
```

### Reading Historical Context

```bash
# View archive metadata
head -20 docs/archive/old-versions/<project>/OLD_SPEC_V1.0.md

# Compare versions
diff docs/archive/old-versions/<project>/SPEC_V1.0.md \
     docs/<project>/specs/SPEC_V2.0.md
```

## Maintenance Guidelines

### Retention Policy

- **Keep indefinitely:** Major version milestones
- **Keep 2 years:** Minor version updates
- **Review annually:** Rarely accessed versions

### Cleanup

```bash
# Find old versions older than 2 years
find docs/archive/old-versions/ -name "*.md" -mtime +730

# Review and remove if no longer needed
# Always keep major versions!
```

### Organization

- Group related documents by project
- Maintain version history files
- Keep metadata up to date
- Ensure archive references are valid

## Migration Guide Reference

When archiving, consider creating migration guides:

```markdown
# Migration Guide: V1.0 → V2.0

## What Changed
- API endpoints restructured
- New authentication method
- Deprecated features removed

## Migration Steps
1. Update configuration
2. Modify API calls
3. Test thoroughly

## Backwards Compatibility
- Legacy endpoints supported until 2026-01-01
- Deprecation warnings enabled
```

## Common Archive Scenarios

### Scenario 1: Specification Update

```bash
# Old spec superseded by new version
mv docs/project/specs/API_SPEC.md \
   docs/archive/old-versions/project/API_SPEC_V1.0.md
   
# Add metadata
# Create new version in active location
```

### Scenario 2: Workflow Evolution

```bash
# Archive old workflow version
cp docs/AGENTIC_AI_WORKFLOW.md \
   docs/archive/old-versions/workflow-versions/AGENTIC_AI_WORKFLOW_V1.0.md
   
# Update with new version
# Add archive metadata to old version
```

### Scenario 3: Bulk Deprecation

```bash
# Create dated archive directory
mkdir docs/archive/old-versions/project/deprecated_2025-12-08/

# Move multiple deprecated files
mv docs/project/docs/OLD_*.md \
   docs/archive/old-versions/project/deprecated_2025-12-08/
```

## Integration with Workflow

Old versions archiving is part of the documentation lifecycle:

1. **Document Created** → Active documentation
2. **Updates Made** → New versions created
3. **Superseded** → Move to old-versions/
4. **Historical Reference** → Available when needed

## Related Documentation

- **Archive Main:** [`../README.md`](../README.md)
- **Workflow Guide:** [`../../AGENTIC_AI_WORKFLOW.md`](../../AGENTIC_AI_WORKFLOW.md)
- **Documentation Guide:** [`../../README.md`](../../README.md)

---

**Last Updated:** 2025-12-08  
**Status:** Empty - Clean Bootstrap State  
**Ready for:** Future documentation version archival
