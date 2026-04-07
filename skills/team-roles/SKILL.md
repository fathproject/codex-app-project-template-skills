---
name: team-roles
description: Use when a generic catalog of project roles is needed, but prefer ai-team-planner for concrete AI worker ownership and role allocation.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - team
  - roles
  - development
tags:
  - team-roles
  - senior-developer
  - junior-developer
  - ui-ux
  - tester
  - qa
---

# AI Team Roles Skill

## Status

Supporting legacy role-catalog skill.

For the AI-team operating model, prefer `ai-team-planner` for the roster and `cross-agent-handover` for coordination.

## Overview

The AI acts as the complete development team. Based on the task, switch roles appropriately.

## Team Structure

```
┌─────────────────────────────────────────────────────────────┐
│                      AI Development Team                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Project    │  │   Senior    │  │   Junior    │         │
│  │   Manager    │  │  Developer  │  │  Developer  │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │    UI/UX    │  │   Tester    │  │     QA      │         │
│  │   Designer  │  │             │  │  Engineer   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Tech      │  │  Business   │  │  DevOps     │         │
│  │   Lead      │  │  Analyst    │  │  Engineer   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Role Definitions

### 1. Project Manager
**When acting as PM:**
- Plan sprints and releases
- Coordinate team activities
- Track progress and blockers
- Report to stakeholders
- Manage backlog prioritization

### 2. Senior Developer
**When acting as Senior Dev:**
- Design system architecture
- Make technical decisions
- Review code
- Guide junior developers
- Handle complex problems
- Set coding standards

### 3. Junior Developer
**When acting as Junior Dev:**
- Implement features under guidance
- Write unit tests
- Fix bugs
- Learn from code reviews
- Ask clarifying questions
- Document simple components

### 4. UI/UX Designer
**When acting as Designer:**
- Create wireframes and mockups
- Design user interfaces
- Ensure accessibility
- Create design systems
- Prototype interactions
- Conduct usability reviews

### 5. Tester
**When acting as Tester:**
- Write test cases
- Execute test plans
- Report bugs
- Verify bug fixes
- Perform regression testing
- Automate tests

### 6. QA Engineer
**When acting as QA:**
- Define quality standards
- Create test strategies
- Ensure test coverage
- Monitor quality metrics
- Process improvement
- Compliance verification

### 7. Tech Lead
**When acting as Tech Lead:**
- Technical vision
- Architecture decisions
- Technology choices
- Code review oversight
- Performance optimization
- Technical mentorship

### 8. Business Analyst
**When acting as BA:**
- Gather requirements
- Analyze business processes
- Create user stories
- Bridge tech and business
- Validate solutions

### 9. DevOps Engineer
**When acting as DevOps:**
- CI/CD pipelines
- Infrastructure as code
- Deployment automation
- Monitoring setup
- Security compliance

## Role Switching

Based on the task, switch perspective:

| Task Type | Primary Role | Supporting Roles |
|-----------|--------------|-----------------|
| Planning | PM | Tech Lead, BA |
| Architecture | Tech Lead | Senior Dev |
| Feature Dev | Senior Dev | Junior Dev |
| Bug Fix | Junior Dev | Senior Dev (review) |
| UI Design | Designer | PM, Senior Dev |
| Testing | Tester | QA, Developer |
| QA Strategy | QA | PM, Tech Lead |
| Deployment | DevOps | Senior Dev |
| Requirements | BA | PM, Designer |

## Team Capacity

### Sprint Capacity Planning

```
Team Members:
- Senior Dev: 40h/week
- Junior Dev: 32h/week (80% - learning time)
- Designer: 40h/week
- Tester: 40h/week
- QA: 32h/week (part-time on project)

Total Sprint Capacity (2 weeks):
Senior Dev: 80h
Junior Dev: 64h
Designer: 80h
Tester: 80h
QA: 64h
────────────────
Total: 368h
```

### Role Allocation by Phase

| Phase | PM | Senior | Junior | Designer | Tester | QA |
|-------|-----|--------|--------|----------|--------|-----|
| Planning | 50% | 30% | 10% | 20% | 10% | 20% |
| Development | 20% | 60% | 80% | 40% | 30% | 20% |
| Testing | 10% | 20% | 20% | 20% | 60% | 40% |
| Launch | 30% | 30% | 10% | 10% | 20% | 40% |

## Collaboration Patterns

### Code Review Flow
```
Developer → Submit PR → Senior Dev Review → Feedback → 
Fix → Senior Dev Approve → Merge
```

### Design Review Flow
```
Designer → Create Mockup → PM Review → 
Stakeholder Review → Feedback → Finalize → Dev Handoff
```

### Test Flow
```
Developer → Write Code → Write Tests → CI Run → 
Tester → Manual Test → QA Sign-off → Deploy
```

## Skill Matrix

| Skill | Senior Dev | Junior Dev | Designer | Tester | QA |
|-------|------------|------------|----------|--------|-----|
| Architecture | ✅ Expert | ❌ | ❌ | ❌ | ❌ |
| UI Design | ❌ | ❌ | ✅ Expert | ❌ | ❌ |
| Unit Testing | ✅ Expert | 🟡 Intermediate | ❌ | 🟡 Intermediate | 🟡 Intermediate |
| E2E Testing | 🟡 Intermediate | 🟡 Intermediate | ❌ | ✅ Expert | 🟡 Intermediate |
| Code Review | ✅ Expert | 🟡 Intermediate | ❌ | ❌ | 🟡 Intermediate |
| API Design | ✅ Expert | 🟡 Intermediate | ❌ | 🟡 Intermediate | ❌ |
| Database | ✅ Expert | 🟡 Intermediate | ❌ | 🟡 Intermediate | ❌ |
| CI/CD | 🟡 Intermediate | 🟡 Intermediate | ❌ | 🟡 Intermediate | 🟡 Intermediate |

Legend: ✅ Expert | 🟡 Intermediate | ❌ Not Primary

## Task Assignment

### By Complexity

| Complexity | Assign To | Example |
|------------|-----------|---------|
| Critical/Complex | Senior Dev | Auth system, API design |
| Standard | Senior + Junior | CRUD features |
| Simple | Junior Dev | Bug fixes, small changes |
| UI/UX | Designer | Screens, components |
| Testing | Tester/QA | Test plans, test automation |

### By Domain

| Domain | Primary | Secondary |
|---------|---------|-----------|
| Backend | Senior Dev | Junior Dev |
| Frontend | Junior Dev | Designer |
| Database | Senior Dev | Junior Dev |
| DevOps | Senior Dev | DevOps |
| Security | Senior Dev | QA |

## Role Templates

### Senior Developer Checklist
```
[ ] Architecture designed
[ ] Technical approach documented
[ ] Code standards followed
[ ] Tests written
[ ] Code reviewed
[ ] Integration verified
```

### Junior Developer Checklist
```
[ ] Requirements understood
[ ] Design reviewed
[ ] Code implemented
[ ] Tests written
[ ] PR submitted
[ ] Review feedback addressed
```

### Designer Checklist
```
[ ] User research done
[ ] Wireframes created
[ ] Design system used
[ ] Accessibility checked
[ ] Handoff documented
[ ] Feedback incorporated
```

### Tester Checklist
```
[ ] Test plan created
[ ] Test cases written
[ ] Manual tests executed
[ ] Bugs reported
[ ] Regression tested
[ ] Sign-off given
```

### QA Engineer Checklist
```
[ ] Test strategy defined
[ ] Quality gates set
[ ] Metrics tracked
[ ] Process improved
[ ] Documentation reviewed
[ ] Compliance verified
```

---

*AI Team Roles Skill v1.0.0*
