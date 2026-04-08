---
name: project-initialization
description: Use when a brand-new project needs initial setup artifacts, but prefer the AI-team intake and orchestration skills for the primary delivery flow.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - project
  - initialization
  - setup
  - github
tags:
  - project-init
  - setup
  - github
  - quick-start
---

# Project Initialization Skill - Master Workflow

## Status

Supporting legacy initialization skill.

For the AI-team operating model, prefer:

1. `client-intake-normalizer`
2. `solution-options-tradeoffs`
3. `scope-convergence`
4. `ai-project-manager-orchestrator`
5. `ai-team-planner`
6. `backlog-management`
7. `task-assignment-governance`

Use this legacy setup skill only when the project explicitly needs setup work outside the standard AI TEAM flow.

## Mode Gate

- Use GitHub setup steps only when `tracking_mode=github_enabled`.
- If the user does not want GitHub, skip auth, repo creation, project board creation, and GitHub milestones.
- If the project is new and GitHub is enabled, create a new repo.
- If the project already has a usable repository, reuse the existing one instead of creating another.

## Overview

This is the **master skill** that orchestrates the complete project setup workflow. Use this skill when starting a new project to automatically:

1. Set up GitHub authentication
2. Create repository and project board
3. Define team structure
4. Create requirements documents
5. Set up timeline and roadmap
6. Create initial backlog
7. Configure sprints

## Complete Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PROJECT INITIALIZATION WORKFLOW                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐           │
│  │  STEP 1      │───▶│  STEP 2      │───▶│  STEP 3      │           │
│  │  GitHub Auth │    │  Repository  │    │  Team Setup  │           │
│  │  & Config    │    │  Setup       │    │  & Roles     │           │
│  └──────────────┘    └──────────────┘    └──────────────┘           │
│         │                   │                    │                   │
│         ▼                   ▼                    ▼                   │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐           │
│  │  STEP 4      │───▶│  STEP 5      │───▶│  STEP 6      │           │
│  │  Requirements│    │  Timeline &  │    │  Backlog &   │           │
│  │  Documents   │    │  Roadmap     │    │  Sprint Plan │           │
│  └──────────────┘    └──────────────┘    └──────────────┘           │
│                                                    │                 │
│                                                    ▼                 │
│                                           ┌──────────────┐          │
│                                           │  STEP 7       │          │
│                                           │  Ready for    │          │
│                                           │  Development! │          │
│                                           └──────────────┘          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

## Step 1: GitHub Authentication

### Check Authentication
```bash
gh auth status
```

### If Not Authenticated
```
╔══════════════════════════════════════════════════════════════════╗
║                    GitHub Authentication Required                   ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  Please authenticate with GitHub to continue.                      ║
║                                                                   ║
║  Option 1: Interactive Login                                       ║
║  ─────────────────────────────────────────────────────────────    ║
║  Run: gh auth login                                               ║
║                                                                   ║
║  Option 2: Personal Access Token                                 ║
║  ─────────────────────────────────────────────────────────────    ║
║  1. Create token at:                                             ║
║     https://github.com/settings/tokens                            ║
║  2. Required scopes: repo, project, workflow                      ║
║  3. Run: export GH_TOKEN=ghp_xxxx                                 ║
║                                                                   ║
║  I will wait for authentication before proceeding.                ║
║                                                                   ║
╚══════════════════════════════════════════════════════════════════╝
```

## Step 2: Repository Setup

### Create Repository
```bash
# Create new repository
gh repo create $PROJECT_NAME \
  --public \
  --description "$PROJECT_DESCRIPTION" \
  --gitignore-template $TEMPLATE \
  --license $LICENSE

# Clone repository
git clone https://github.com/$USERNAME/$PROJECT_NAME.git
cd $PROJECT_NAME
```

### Setup Project Board
```bash
# Create project board with columns
gh api repos/$USERNAME/$PROJECT_NAME/projects -X POST \
  -f name="$PROJECT_NAME Sprint Board" \
  -f body="Sprint planning and tracking"

# Create columns: Backlog, To Do, In Progress, In Review, Done
```

## Step 3: Team Setup

### Define Team Structure
```markdown
## Team Structure: $PROJECT_NAME

| Role | Count | Responsibilities |
|------|-------|------------------|
| Project Manager | 1 | Planning, coordination, reporting |
| Senior Developer | $SENIOR_COUNT | Architecture, code review, complex features |
| Junior Developer | $JUNIOR_COUNT | Feature development, bug fixes |
| UI/UX Designer | $DESIGNER_COUNT | UI design, user experience |
| QA Engineer | $QA_COUNT | Test strategy, quality assurance |
| Tester | $TESTER_COUNT | Test execution, bug reporting |

### Capacity per Sprint (2 weeks)
| Role | Capacity (hours) |
|------|-----------------|
| Senior Dev | 64h |
| Junior Dev | 56h |
| Designer | 72h |
| QA | 64h |
| Tester | 72h |
```

## Step 4: Requirements Documents

### Create Documents
```markdown
# Creating Requirements Documents

## 4.1 Project Charter
- Project name and description
- Objectives and success criteria
- Stakeholders
- Scope (in/out)
- Timeline overview
- Budget
- Sign-off

## 4.2 Business Requirements (BRD)
- Business objectives
- User characteristics
- Functional requirements
- Non-functional requirements
- Assumptions and constraints

## 4.3 Functional Requirements (FRD)
- Detailed feature specifications
- User stories (Gherkin format)
- Acceptance criteria
- UI/UX requirements
- Data requirements
- Integration points

## 4.4 User Stories
Format:
```
As a [user type]
I want to [action]
So that [benefit]

Acceptance Criteria:
- Given [context] when [action] then [outcome]
- Given [context] when [action] then [outcome]
```
```

## Step 5: Timeline & Roadmap

### Create Timeline
```markdown
## Project Timeline: $PROJECT_NAME

| Phase | Duration | Start | End | Key Deliverables |
|-------|----------|-------|-----|------------------|
| Phase 1: Discovery | 2 weeks | Week 1 | Week 2 | Requirements, Architecture |
| Phase 2: Foundation | 4 weeks | Week 3 | Week 6 | Core infrastructure, Auth |
| Phase 3: Core MVP | 6 weeks | Week 7 | Week 12 | Main features |
| Phase 4: Enhancement | 4 weeks | Week 13 | Week 16 | P1 features, Polish |
| Phase 5: Testing | 4 weeks | Week 17 | Week 20 | QA, UAT, Bug fixes |
| Phase 6: Launch | 2 weeks | Week 21 | Week 22 | Deployment, Launch |
| Phase 7: Stabilize | 4 weeks | Week 23 | Week 26 | Post-launch support |
| Phase 8: Handover | 2 weeks | Week 27 | Week 28 | Documentation, Close |

## Milestones
| Milestone | Target | Deliverable |
|-----------|--------|-------------|
| M1: Kickoff | Week 1 | Project charter signed |
| M2: Requirements | Week 2 | All requirements approved |
| M3: MVP | Week 12 | Core features complete |
| M4: Launch | Week 22 | Production ready |
| M5: Close | Week 28 | Project archived |
```

## Step 6: Backlog & Sprint Planning

### Create Backlog
```bash
# Create initial backlog issues
gh issue create \
  --title "[FEATURE] User Authentication" \
  --body "$(cat <<'EOF'
## User Story
As a user, I want to login so that I can access my account.

## Acceptance Criteria
- [ ] User can register
- [ ] User can login
- [ ] User can logout
- [ ] Passwords are hashed

## Story Points: 5
EOF
)" \
  --label "feature,P0" \
  --milestone "Sprint 1"

# Create more issues for backlog...
```

### Sprint Structure
```markdown
## Sprint Breakdown

| Sprint | Duration | Focus | Capacity | Points |
|--------|----------|-------|----------|--------|
| Sprint 0 | 2 weeks | Setup, Planning | 100% | 0 |
| Sprint 1 | 2 weeks | Foundation | 80% | 20 |
| Sprint 2 | 2 weeks | Foundation | 90% | 25 |
| Sprint 3 | 2 weeks | Core Features | 90% | 30 |
| Sprint 4 | 2 weeks | Core Features | 90% | 30 |
| Sprint 5 | 2 weeks | Enhancement | 90% | 28 |
| Sprint 6 | 2 weeks | Testing | 100% | 15 |
| Sprint 7 | 2 weeks | Launch | 100% | 10 |
```

## Step 7: Initialize Complete Project

### Run Full Setup Script
```bash
#!/bin/bash
# project-init.sh

PROJECT_NAME="$1"
PROJECT_DESC="$2"
GITHUB_USERNAME="$3"

# 1. Create repository
gh repo create "$PROJECT_NAME" --public --description "$PROJECT_DESC"

# 2. Clone
git clone "https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git"
cd "$PROJECT_NAME"

# 3. Create project board
gh api repos/$GITHUB_USERNAME/$PROJECT_NAME/projects -X POST \
  -f name="$PROJECT_NAME Board"

# 4. Create labels
bash <(curl -s https://raw.githubusercontent.com/.../setup-labels.sh) "$GITHUB_USERNAME/$PROJECT_NAME"

# 5. Create milestone structure
gh issue milestone create --title "Sprint 0" --due "2024-01-15"
gh issue milestone create --title "Sprint 1" --due "2024-01-29"
# ... more sprints

# 6. Create issue templates
mkdir -p .github/ISSUE_TEMPLATE
# ... create templates

# 7. Initial commit
git add .
git commit -m "Initial project structure"
git push origin main

echo "✅ Project $PROJECT_NAME initialized successfully!"
```

## Output: Complete Project Structure

```
$PROJECT_NAME/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── feature_request.md
│   │   └── bug_report.md
│   └── PULL_REQUEST_TEMPLATE.md
│
├── memory/                      # Memory bank
│   ├── PROJECT.md
│   ├── DECISIONS.md
│   ├── requirements/
│   │   ├── CHARTER.md
│   │   ├── BRD.md
│   │   ├── FRD.md
│   │   └── USER_STORIES.md
│   ├── team/
│   │   ├── ROLES.md
│   │   └── CAPACITY.md
│   ├── timeline/
│   │   ├── ROADMAP.md
│   │   └── MILESTONES.md
│   └── backlog/
│       ├── BACKLOG.md
│       └── SPRINTS.md
│
├── src/                         # Source code
├── tests/                       # Tests
├── docs/                        # Documentation
├── README.md
├── LICENSE
└── .gitignore
```

## Interactive Setup Questions

When user says "Start new project", ask:

```
╔══════════════════════════════════════════════════════════════════╗
║                  New Project Setup                              ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  Let's set up your new project! I'll need some information:       ║
║                                                                   ║
║  1. Project Name: _______________                               ║
║                                                                   ║
║  2. Description: _______________                                 ║
║                                                                   ║
║  3. GitHub Username: _______________                             ║
║                                                                   ║
║  4. Project Type:                                                ║
║     [ ] Web Application                                          ║
║     [ ] API / Backend                                            ║
║     [ ] Mobile App                                               ║
║     [ ] Desktop App                                             ║
║     [ ] Library / Package                                        ║
║     [ ] Other: _______________                                   ║
║                                                                   ║
║  5. Team Size:                                                   ║
║     [ ] Just me (Solo)                                           ║
║     [ ] Small (2-4 people)                                       ║
║     [ ] Medium (5-8 people)                                      ║
║     [ ] Large (9+ people)                                        ║
║                                                                   ║
║  6. Timeline:                                                    ║
║     [ ] ASAP (< 1 month)                                         ║
║     [ ] Short (1-3 months)                                        ║
║     [ ] Medium (3-6 months)                                       ║
║     [ ] Long (6+ months)                                          ║
║                                                                   ║
║  7. GitHub Token: (for automation)                               ║
║     Set GH_TOKEN environment variable or I'll prompt for login   ║
║                                                                   ║
║  Press Enter when ready to continue...                            ║
║                                                                   ║
╚══════════════════════════════════════════════════════════════════╝
```

## After Setup: Ready for Development

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║     ✅ PROJECT INITIALIZED SUCCESSFULLY!                          ║
║                                                                   ║
║     Repository: https://github.com/$USER/$PROJECT                 ║
║     Project Board: https://github.com/users/$USER/projects/       ║
║                                                                   ║
║     What's Next?                                                  ║
║     ──────────────                                                ║
║     1. Requirements finalized? → Start Sprint 1                   ║
║     2. Need to add features? → Add to backlog                    ║
║     3. Ready to code? → Check first issue!                        ║
║                                                                   ║
║     Your AI Team is Ready:                                        ║
║     • Project Manager (planning, coordination)                   ║
║     • Senior Developer (architecture, code review)               ║
║     • Junior Developer (feature implementation)                  ║
║     • UI/UX Designer (interface design)                         ║
║     • QA Engineer (quality strategy)                             ║
║     • Tester (verification)                                       ║
║                                                                   ║
║     Just tell me what to work on!                                ║
║                                                                   ║
╚══════════════════════════════════════════════════════════════════╝
```

---

*Project Initialization Skill v1.0.0*
