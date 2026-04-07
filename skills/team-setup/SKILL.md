---
name: team-setup
description: Use when a generic team structure or capacity plan is needed, but prefer ai-team-planner for the logical AI-team operating model.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - team
  - resource-planning
  - roles
tags:
  - team-structure
  - roles
  - capacity
  - resource-planning
---

# Team Setup Skill

## Status

Supporting legacy team-planning skill.

For the AI-team operating model, prefer `ai-team-planner`.

## Overview

AI defines complete team structure including roles, responsibilities, capacity planning, and resource allocation.

## Team Structure Template

```markdown
# Team Structure

## Project: [Project Name]
**Total Team Size**: X people
**Project Duration**: X weeks
**Start Date**: YYYY-MM-DD

## Organizational Chart

                    ┌─────────────────┐
                    │   Project       │
                    │   Sponsor       │
                    │   (Executive)   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  Project        │
                    │  Manager        │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────▼───────┐    ┌───────▼───────┐    ┌──────▼──────┐
│   Tech Lead   │    │  UI/UX Lead   │    │  QA Lead    │
│   / Senior    │    │   / Designer  │    │  / Tester   │
│   Developer   │    │               │    │             │
└───────┬───────┘    └───────┬───────┘    └──────┬──────┘
        │                    │                    │
┌───────▼───────┐    ┌───────▼───────┐    ┌──────▼──────┐
│   Junior      │    │   Junior      │    │   Junior    │
│   Developer 1 │    │   Designer    │    │   Tester    │
│               │    │               │    │             │
│   Junior      │    │               │    │             │
│   Developer 2 │    │               │    │             │
└───────────────┘    └───────────────┘    └─────────────┘
```

## Role Definitions

### 1. Project Manager
```markdown
## Project Manager

### Role Summary
- **Reports To**: Project Sponsor
- **Manages**: Full project team

### Responsibilities
- Project planning and scheduling
- Stakeholder management
- Risk management
- Budget tracking
- Team coordination
- Progress reporting

### Skills Required
- Project management (PMP, Scrum Master)
- Communication
- Problem-solving
- Leadership

### Time Allocation
| Activity | % Time |
|----------|--------|
| Planning | 20% |
| Meetings | 25% |
| Coordination | 30% |
| Reporting | 15% |
| Unplanned | 10% |

### Available Hours/Week
- Total: 40h
- Billable: 36h (90%)

### Cost per Hour
- Internal: $XX
- External: $XX
```

### 2. Senior Developer
```markdown
## Senior Developer

### Role Summary
- **Reports To**: Tech Lead / PM
- **Manages**: Junior developers (indirect)

### Responsibilities
- System architecture
- Technical decisions
- Code review
- Mentor junior developers
- Complex feature implementation
- Code quality assurance

### Skills Required
- 5+ years experience
- Expert in primary language/framework
- System design
- Database design
- Security best practices

### Time Allocation
| Activity | % Time |
|----------|--------|
| Development | 50% |
| Code Review | 20% |
| Architecture | 15% |
| Meetings | 10% |
| Unplanned | 5% |

### Available Hours/Week
- Total: 40h
- Billable: 32h (80%)

### Cost per Hour
- Internal: $XX
- External: $XX
```

### 3. Junior Developer
```markdown
## Junior Developer

### Role Summary
- **Reports To**: Senior Developer
- **Manages**: None

### Responsibilities
- Feature implementation
- Bug fixes
- Unit testing
- Documentation
- Learning and development

### Skills Required
- 1-3 years experience
- Proficient in primary language
- Basic understanding of architecture
- Willingness to learn

### Time Allocation
| Activity | % Time |
|----------|--------|
| Development | 60% |
| Learning | 15% |
| Testing | 15% |
| Meetings | 10% |

### Available Hours/Week
- Total: 32h (80% utilization - 20% for learning)
- Billable: 28h (87.5%)

### Cost per Hour
- Internal: $XX
- External: $XX
```

### 4. UI/UX Designer
```markdown
## UI/UX Designer

### Role Summary
- **Reports To**: PM / Design Lead
- **Manages**: None

### Responsibilities
- User research
- Wireframing
- UI design
- Design system maintenance
- Prototype creation
- Usability testing

### Skills Required
- Figma/Sketch proficiency
- User research
- Interaction design
- Accessibility (WCAG)
- Design systems

### Time Allocation
| Activity | % Time |
|----------|--------|
| Design | 55% |
| Research | 15% |
| Meetings | 15% |
| Handoff | 10% |
| Unplanned | 5% |

### Available Hours/Week
- Total: 40h
- Billable: 36h (90%)

### Cost per Hour
- Internal: $XX
- External: $XX
```

### 5. QA Engineer
```markdown
## QA Engineer

### Role Summary
- **Reports To**: PM / QA Lead
- **Manages**: Testers

### Responsibilities
- Test strategy
- Test planning
- Test case creation
- Test automation
- Bug tracking
- Quality metrics

### Skills Required
- Test planning
- Test automation (Selenium, Cypress)
- API testing
- Performance testing
- Bug tracking tools (JIRA)

### Time Allocation
| Activity | % Time |
|----------|--------|
| Test Planning | 20% |
| Test Execution | 45% |
| Automation | 20% |
| Meetings | 10% |
| Unplanned | 5% |

### Available Hours/Week
- Total: 40h
- Billable: 36h (90%)

### Cost per Hour
- Internal: $XX
- External: $XX
```

### 6. Tester
```markdown
## Tester

### Role Summary
- **Reports To**: QA Engineer
- **Manages**: None

### Responsibilities
- Test execution
- Bug reporting
- Regression testing
- Test documentation
- UAT support

### Skills Required
- Manual testing
- Test case writing
- Bug reporting
- Basic automation (optional)

### Time Allocation
| Activity | % Time |
|----------|--------|
| Testing | 70% |
| Bug reporting | 15% |
| Meetings | 10% |
| Unplanned | 5% |

### Available Hours/Week
- Total: 40h
- Billable: 36h (90%)

### Cost per Hour
- Internal: $XX
- External: $XX
```

## Team Matrix

### Small Team (3-4 people)
| Role | Count | Sprint Capacity |
|------|-------|-----------------|
| Senior Dev | 1 | 32h |
| Junior Dev | 1 | 28h |
| Designer | 1 | 36h |
| PM | 1 (shared) | 16h |
| **Total** | **4** | **112h** |

### Medium Team (6-8 people)
| Role | Count | Sprint Capacity |
|------|-------|-----------------|
| PM | 1 | 36h |
| Tech Lead | 1 | 32h |
| Senior Dev | 1 | 32h |
| Junior Dev | 2 | 56h |
| Designer | 1 | 36h |
| QA Engineer | 1 | 36h |
| Tester | 1 | 36h |
| **Total** | **8** | **264h** |

### Large Team (10+ people)
| Role | Count | Sprint Capacity |
|------|-------|-----------------|
| PM | 1 | 36h |
| Tech Lead | 1 | 32h |
| Senior Dev | 2 | 64h |
| Junior Dev | 3 | 84h |
| Designer | 2 | 72h |
| QA Engineer | 1 | 36h |
| Tester | 2 | 72h |
| DevOps | 1 | 32h |
| **Total** | **13** | **428h** |

## Capacity Planning

### Sprint Capacity Calculator

```markdown
## Sprint Capacity Calculation

### Inputs
- Sprint Duration: 2 weeks (10 working days)
- Team members: X
- Public holidays: X days
- Team events/training: X days

### Calculations
| Role | Count | Days | Hours/Day | Utilization | Available |
|------|-------|------|-----------|-------------|-----------|
| Senior Dev | 1 | 10 | 8 | 80% | 64h |
| Junior Dev | 2 | 10 | 8 | 80% | 128h |
| Designer | 1 | 10 | 8 | 90% | 72h |
| Tester | 1 | 10 | 8 | 90% | 72h |

### Total Sprint Capacity: 336h

### Allocation
- Development: 70% = 235h
- Testing: 20% = 67h
- Meetings/Admin: 10% = 34h

### Velocity Planning
- Story points/sprint: [Historical avg] = 30 points
- Capacity buffer: 20% = 24 points usable
```

### Resource Calendar
```markdown
## Resource Availability

| Resource | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 |
|----------|----|----|----|----|----|----|----|----|
| Senior 1 | 80% | 80% | 100% | 100% | 100% | 80% | 80% | 50% |
| Junior 1 | 40% | 80% | 80% | 80% | 80% | 80% | 80% | 80% |
| Junior 2 | 0% | 0% | 0% | 40% | 80% | 80% | 80% | 80% |
| Designer | 100% | 60% | 60% | 60% | 40% | 40% | 60% | 40% |
| Tester | 0% | 0% | 0% | 0% | 40% | 80% | 80% | 80% |

Legend: 0% = Not allocated, 100% = Full availability
```

## RACI Matrix

```markdown
## RACI Matrix

| Activity | PM | Tech Lead | Sr Dev | Jr Dev | Designer | QA | Tester |
|----------|-----|-----------|--------|--------|----------|----|--------|
| Project Planning | A | C | I | I | I | I | I |
| Architecture | A | R | R | I | C | I | I |
| Sprint Planning | R | C | C | C | C | C | I |
| Development | I | A | R | R | C | I | I |
| UI Design | C | I | I | I | R | C | I |
| Testing | I | A | C | C | I | R | R |
| Code Review | A | R | R | C | I | I | I |
| Deployment | I | A | R | C | I | C | I |
| UAT | A | C | C | C | C | R | R |
| Release | A | R | C | I | I | C | I |

R = Responsible, A = Accountable, C = Consulted, I = Informed
```

## Team Onboarding Checklist

```markdown
## Developer Onboarding

### Week 1
- [ ] Access to GitHub/org
- [ ] Development environment setup
- [ ] Codebase walkthrough
- [ ] Architecture overview
- [ ] Meet the team
- [ ] First small task assigned

### Week 2
- [ ] Complete first feature (with help)
- [ ] Submit first PR
- [ ] Code review feedback
- [ ] Understanding of workflow
- [ ] Start working more independently

### Week 3-4
- [ ] Independent development
- [ ] Peer code reviews
- [ ] Participation in sprint ceremonies
- [ ] Comfortable with codebase
```

## Team Communication

```markdown
## Communication Plan

### Daily
- Daily standup: 15 min (async or sync)
- Slack channel for quick questions
- GitHub notifications

### Weekly
- Sprint planning: 1-2 hours
- Sprint review: 1 hour
- Sprint retrospective: 30 min
- Team sync: 1 hour

### As Needed
- 1:1s with manager
- Technical discussions
- Design reviews
- Code reviews
```

---

*Team Setup Skill v1.0.0*
