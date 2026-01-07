---
date: 2026-01-07T11:49:28Z
researcher: Claude
git_commit: d4db43b3932030954d153e1be741bcb0520bb5f5
branch: main
repository: bloggy
topic: "Extending RPI Workflow with Review and Task Commands"
tags: [research, claude-commands, workflow, humanlayer-patterns]
status: complete
last_updated: 2026-01-07
last_updated_by: Claude
---

# Research: Extending RPI Workflow with Review and Task Commands

**Date**: 2026-01-07T11:49:28Z
**Researcher**: Claude
**Git Commit**: d4db43b3932030954d153e1be741bcb0520bb5f5
**Branch**: main
**Repository**: bloggy

## Research Question

The user has an RPI (Research, Plan, Implement) workflow using Humanlayer commands and wants to extend it with:
1. **Reviewer** - A gatekeeper step after planning to enforce simplicity, DRY, and YAGNI
2. **Tasker** - Break plans into ordered, atomic tasks with dependency tracking
3. **Updated Implementor** - Spawn parallel agents ("swarms") to execute tasks

The user has draft prompts for these but wants them rewritten to match Humanlayer's command style.

## Summary

### Humanlayer Command Structure Patterns

The Humanlayer commands follow consistent structural patterns:

1. **YAML Frontmatter** with `description` and optional `model` fields
2. **Clear Initial Response** section defining behavior when invoked
3. **Numbered Process Steps** with detailed sub-instructions
4. **Interactive Checkpoints** requiring user feedback at key points
5. **Sub-agent Spawning Patterns** for parallel research
6. **Output File Conventions** with date-prefixed naming
7. **Error Handling** with graceful degradation
8. **Guidelines Section** with best practices

### Key Files Analyzed

| File | Purpose | Relevance |
|------|---------|-----------|
| `.claude/commands/research_codebase.md` | Comprehensive codebase research | Foundation command |
| `.claude/commands/create_plan.md` | Interactive planning | Foundation command |
| `.claude/commands/implement_plan.md` | Plan execution | Foundation command |
| `.claude/commands/validate_plan.md` | Post-implementation validation | Similar to Reviewer |

### User's Draft Analysis

The user's drafts have good conceptual foundations but differ from Humanlayer style:

| Aspect | User's Drafts | Humanlayer Style |
|--------|---------------|------------------|
| Frontmatter | Missing | YAML with description, model |
| Initial Response | Missing | Explicit "respond with:" section |
| Steps | Conceptual bullets | Numbered steps with sub-bullets |
| Interactivity | None | User checkpoints throughout |
| File output | Not specified | Date-prefixed paths to thoughts/ |
| Error handling | Minimal | Explicit patterns |
| Tool usage | Implicit | Explicit sub-agent spawning |

## Detailed Findings

### Humanlayer Command Structure

#### 1. YAML Frontmatter Pattern

All commands begin with:
```yaml
---
description: Brief description of command purpose
model: opus  # optional, defaults to sonnet
---
```

Example from `create_plan.md:1-4`:
```yaml
---
description: Create detailed implementation plans through interactive research and iteration
model: opus
---
```

#### 2. Initial Response Section

Commands define explicit behavior when invoked:

```markdown
## Initial Response

When this command is invoked:

1. **Check if parameters were provided**:
   - If a file path or ticket reference was provided as a parameter, skip the default message
   - Immediately read any provided files FULLY
   - Begin the research process

2. **If no parameters provided**, respond with:
[literal response text in code block]

Then wait for the user's input.
```

#### 3. Numbered Process Steps

Steps use hierarchical numbering:
- `## Step 1: Title`
- Sub-points use numbered lists
- Actions are bold: `**Read the plan**`
- Critical instructions use emphasis: `**IMPORTANT**`, `**CRITICAL**`

#### 4. Sub-Agent Spawning

Commands spawn specialized agents for parallel work:

```markdown
**Spawn parallel research tasks**:
- Use the **codebase-locator** agent to find files
- Use the **codebase-analyzer** agent to understand implementation
- Use the **codebase-pattern-finder** agent to find similar patterns
```

Key pattern: Always wait for ALL sub-agents to complete before proceeding.

#### 5. Output File Conventions

All outputs go to `thoughts/shared/` with naming:
```
thoughts/shared/[type]/YYYY-MM-DD-[ticket]-description.md
```

Types include: `plans/`, `research/`, `reviews/`, `prs/`

#### 6. Interactive Checkpoints

Commands pause for user feedback at decision points:

```markdown
Present findings and design options:
```
Based on my research, here's what I found...

Which approach aligns best with your vision?
```
```

### Comparison: validate_plan.md vs User's Reviewer

The existing `validate_plan.md` is post-implementation validation. The user's Reviewer is pre-implementation plan review. Key differences:

| validate_plan.md | User's Reviewer |
|------------------|-----------------|
| After implementation | Before implementation |
| Checks code against plan | Checks plan against principles |
| Runs automated tests | Evaluates architecture |
| Generates validation report | Outputs revised plan |

The Reviewer fills a different gap - it's a **plan quality gate**, not implementation verification.

### Analysis of User's Draft Commands

#### The Reviewer (Draft)

**Strengths:**
- Clear objectives (Simplicity, DRY, YAGNI)
- Good "rewrite entirely" instruction (avoids comment lists)
- Structured output expectation

**Gaps:**
- No YAML frontmatter
- No initial response section
- No sub-agent research for DRY violations
- No file output convention
- No interactive checkpoints
- No specific codebase patterns to look for

#### The Tasker (Draft)

**Strengths:**
- Clear atomicity requirements
- Good JSON schema for DAG
- Dependency tracking concept
- STOP_FOR_HUMAN error handling

**Gaps:**
- No YAML frontmatter
- No initial response section
- No guidance on reading the plan first
- No integration with thoughts/ directory
- JSON output may be challenging for Claude Code workflow
- No interactive checkpoints

#### The Implementor (Draft)

**Strengths:**
- Git worktree isolation concept
- Parallel execution vision
- Commit locking awareness
- DAG-based task tracking

**Gaps:**
- More like script specification than Claude command
- No YAML frontmatter
- Missing integration with existing implement_plan.md
- Worktree management may be overly complex
- No guidance on existing command patterns
- Swarm concept needs Claude Code adaptation

## Architecture Documentation

### Existing RPI Workflow

```
/research_codebase → thoughts/shared/research/
       ↓
/create_plan → thoughts/shared/plans/
       ↓
/implement_plan → Code changes + commits
```

### Proposed Extended Workflow

```
/research_codebase → thoughts/shared/research/
       ↓
/create_plan → thoughts/shared/plans/ (draft)
       ↓
/review_plan → thoughts/shared/plans/ (revised)  ← NEW
       ↓
/task_plan → thoughts/shared/tasks/  ← NEW
       ↓
/implement_tasks → Parallel execution  ← MODIFIED
       ↓
/validate_plan → Verification
```

### Key Design Decisions for New Commands

1. **review_plan.md** should:
   - Read the draft plan completely
   - Spawn codebase-pattern-finder to check for DRY violations
   - Either approve or rewrite the entire plan
   - Save to same location as original plan (overwrite or version)
   - Integrate with existing plan template structure

2. **task_plan.md** should:
   - Read the reviewed plan completely
   - Break into atomic, committable tasks
   - Track dependencies as markdown (not JSON for simplicity)
   - Save to `thoughts/shared/tasks/` or inline in plan
   - Provide clear execution order

3. **implement_tasks.md** should:
   - Work with or without explicit task breakdown
   - Spawn parallel Task agents for independent work
   - Maintain git commit atomicity
   - Use existing implement_plan.md patterns
   - Avoid complex worktree management (keep simple)

## Code References

### Bloggy Commands
- `.claude/commands/research_codebase.md` - Research workflow with sub-agents
- `.claude/commands/create_plan.md` - Interactive planning with templates
- `.claude/commands/implement_plan.md` - Phase-based implementation

### Humanlayer Commands (Reference)
- `~/dev/humanlayer/.claude/commands/validate_plan.md` - Post-implementation validation pattern
- `~/dev/humanlayer/.claude/commands/create_plan.md` - Canonical planning command
- `~/dev/humanlayer/.claude/commands/iterate_plan.md` - Plan refinement pattern

## Recommendations for Rewriting

### For review_plan.md

1. Add YAML frontmatter with `description` and `model: opus`
2. Add Initial Response section with parameter detection
3. Add explicit codebase research step for DRY violations
4. Define output as either "APPROVED" with stamp or "REVISED" with full rewrite
5. Save reviews to `thoughts/shared/reviews/` or update plan in-place
6. Add guidelines section with anti-patterns to watch for

### For task_plan.md

1. Add YAML frontmatter
2. Use markdown task list format instead of JSON (simpler for Claude Code)
3. Include dependency notation in markdown
4. Add validation step to ensure all dependencies exist
5. Save to plan file as new section or separate task file
6. Add guidelines for task granularity

### For implement_tasks.md

1. Extend existing implement_plan.md rather than replace
2. Add optional parallel execution using Task tool
3. Keep git operations simple (no worktree complexity)
4. Add synchronization points for dependent tasks
5. Maintain commit message conventions
6. Add progress tracking with TodoWrite

## Open Questions

1. Should review_plan.md update the plan in-place or create a versioned copy?
2. Should tasks be inline in the plan or a separate file?
3. How aggressive should parallel task execution be? (e.g., max concurrency)
4. Should the Tasker output remain JSON for potential tooling integration?
