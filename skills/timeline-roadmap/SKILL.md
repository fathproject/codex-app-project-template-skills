---
name: timeline-roadmap
description: Use when a human-readable roadmap or milestone artifact is needed, but prefer ai-project-manager-orchestrator for live AI-team sequencing.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - timeline
  - roadmap
  - planning
  - milestones
tags:
  - timeline
  - roadmap
  - milestones
  - phases
  - gantt
---

# Timeline & Roadmap Skill

## Status

Supporting legacy roadmap skill.

For the AI-team operating model, use `ai-project-manager-orchestrator` to sequence workstreams, then use this skill only when a human-readable roadmap artifact is still needed.

## Overview

AI creates comprehensive project timelines and roadmaps with phases, milestones, and team allocation.

## Project Timeline Structure

```
PROJECT TIMELINE
═══════════════════════════════════════════════════════════════════

Phase 1: Discovery          Phase 2: Foundation        Phase 3: Core MVP
█████████████████████████   ████████████████████████   ████████████████████
Week 1-2                   Week 3-6                   Week 7-12


Phase 4: Enhancement       Phase 5: Testing          Phase 6: Launch
█████████████████████████   ██████████████████████     ██████████
Week 13-16                 Week 17-20                 Week 21-22


Phase 7: Stabilization      Phase 8: Handover
███████████████████████     ██████████
Week 23-26                 Week 27-28

═══════════════════════════════════════════════════════════════════
```

## Phase Templates

### Phase 1: Discovery & Planning
```markdown
## Phase 1: Discovery & Planning
**Duration**: Weeks 1-2
**Goal**: Complete project setup and requirements finalization

### Activities
- [ ] Requirements finalization
- [ ] Architecture design
- [ ] Tech stack selection
- [ ] Development environment setup
- [ ] Team onboarding
- [ ] GitHub repository setup
- [ ] CI/CD pipeline setup

### Deliverables
- [ ] Project Charter (signed)
- [ ] Requirements Document (approved)
- [ ] Architecture Diagram
- [ ] Technical Design Document
- [ ] Sprint 0 backlog created

### Team Allocation
| Role | Allocation | Key Activities |
|------|------------|---------------|
| Project Manager | 80% | Planning, coordination |
| Senior Developer | 60% | Architecture, setup |
| Designer | 40% | Design system setup |
| BA | 80% | Requirements finalization |

### Milestones
| Milestone | Date | Criteria |
|-----------|------|----------|
| Kickoff Complete | Week 1 | All stakeholders aligned |
| Requirements Signed | Week 2 | BA approved |
| Architecture Approved | Week 2 | Tech lead sign-off |
```

### Phase 2: Foundation
```markdown
## Phase 2: Foundation
**Duration**: Weeks 3-6 (4 weeks)
**Goal**: Core infrastructure and authentication

### Activities
- [ ] Database schema creation
- [ ] API foundation
- [ ] Authentication system
- [ ] User management
- [ ] Base UI components
- [ ] Design system implementation
- [ ] CI/CD deployment

### Deliverables
- [ ] Database migrations
- [ ] Auth API endpoints
- [ ] User API endpoints
- [ ] Design system component library
- [ ] Automated deployment pipeline

### Sprint Breakdown
| Sprint | Focus | Key Items |
|--------|-------|-----------|
| Sprint 1 | Database & Auth | User model, JWT, login/register |
| Sprint 2 | Foundation UI | Dashboard skeleton, navigation |
```

### Phase 3: Core MVP
```markdown
## Phase 3: Core MVP
**Duration**: Weeks 7-12 (6 weeks)
**Goal**: Complete core features for MVP

### Features (P0 Priority)
- [ ] Feature A
- [ ] Feature B
- [ ] Feature C

### Sprint Breakdown
| Sprint | Focus | Key Items |
|--------|-------|-----------|
| Sprint 3 | Feature A | CRUD, UI, tests |
| Sprint 4 | Feature B | Integration, APIs |
| Sprint 5 | Feature C | Complex logic |
| Sprint 6 | Integration | Feature cross-linking |
```

### Phase 4: Enhancement
```markdown
## Phase 4: Enhancement
**Duration**: Weeks 13-16 (4 weeks)
**Goal**: Polish and add P1 features

### Features (P1 Priority)
- [ ] Advanced search
- [ ] Notifications
- [ ] Reporting dashboard
- [ ] Settings/Preferences

### Sprint Breakdown
| Sprint | Focus | Key Items |
|--------|-------|-----------|
| Sprint 7 | Search & Filters | Advanced queries |
| Sprint 8 | Notifications | Email, push, in-app |
```

### Phase 5: Testing & QA
```markdown
## Phase 5: Testing & QA
**Duration**: Weeks 17-20 (4 weeks)
**Goal**: Comprehensive testing and bug fixing

### Activities
- [ ] Integration testing
- [ ] Performance testing
- [ ] Security testing
- [ ] UAT (User Acceptance Testing)
- [ ] Bug fixing sprint
- [ ] Regression testing

### Testing Types
| Type | Coverage Target | Tools |
|------|-----------------|-------|
| Unit Tests | 80% | Jest, Pytest |
| Integration | 70% | Postman, Supertest |
| E2E | Critical paths | Cypress |
| Performance | <2s response | k6, JMeter |
| Security | OWASP Top 10 | Burp, OWASP ZAP |
```

### Phase 6: Launch Preparation
```markdown
## Phase 6: Launch Preparation
**Duration**: Weeks 21-22 (2 weeks)
**Goal**: Production-ready deployment

### Activities
- [ ] Production environment setup
- [ ] Data migration scripts
- [ ] Monitoring setup
- [ ] Documentation
- [ ] Training materials
- [ ] Launch plan
- [ ] Rollback plan

### Launch Checklist
- [ ] Domain configured
- [ ] SSL certificates
- [ ] CDN configured
- [ ] Backup strategy
- [ ] Monitoring dashboards
- [ ] Alerting configured
- [ ] Runbooks created
```

### Phase 7: Stabilization
```markdown
## Phase 7: Stabilization
**Duration**: Weeks 23-26 (4 weeks post-launch)
**Goal**: Ensure production stability

### Activities
- [ ] Monitor metrics
- [ ] Fix production bugs
- [ ] Performance optimization
- [ ] Security patches
- [ ] User feedback incorporation

### SLA Targets
| Metric | Target |
|--------|--------|
| Uptime | 99.9% |
| Response Time | < 2s |
| Error Rate | < 0.1% |
| Availability | 24/7 |
```

### Phase 8: Handover
```markdown
## Phase 8: Handover
**Duration**: Weeks 27-28 (2 weeks)
**Goal**: Knowledge transfer and project closure

### Activities
- [ ] Documentation finalization
- [ ] Knowledge transfer sessions
- [ ] Team transition
- [ ] Project retrospective
- [ ] Archive project artifacts
- [ ] Close GitHub project

### Handover Package
- [ ] Complete source code
- [ ] API documentation
- [ ] Deployment guide
- [ ] User manual
- [ ] Support documentation
- [ ] Code style guide
```

## Timeline Template

```markdown
# Project Timeline

## Project Overview
| Field | Value |
|-------|-------|
| Project Name | |
| Start Date | YYYY-MM-DD |
| End Date | YYYY-MM-DD |
| Duration | X weeks |
| Total Budget | $XXX |

## Phase Timeline

| Phase | Name | Start | End | Duration | Status |
|-------|------|-------|-----|----------|--------|
| 1 | Discovery & Planning | Week 1 | Week 2 | 2 weeks | 🔴 Not Started |
| 2 | Foundation | Week 3 | Week 6 | 4 weeks | 🔴 Not Started |
| 3 | Core MVP | Week 7 | Week 12 | 6 weeks | 🔴 Not Started |
| 4 | Enhancement | Week 13 | Week 16 | 4 weeks | 🔴 Not Started |
| 5 | Testing & QA | Week 17 | Week 20 | 4 weeks | 🔴 Not Started |
| 6 | Launch Prep | Week 21 | Week 22 | 2 weeks | 🔴 Not Started |
| 7 | Stabilization | Week 23 | Week 26 | 4 weeks | 🔴 Not Started |
| 8 | Handover | Week 27 | Week 28 | 2 weeks | 🔴 Not Started |

## Milestone Timeline

| Milestone | Target Date | Phase | Status |
|-----------|-------------|-------|--------|
| M1: Kickoff | Week 1 | Phase 1 | ⬜ Pending |
| M2: Requirements Approved | Week 2 | Phase 1 | ⬜ Pending |
| M3: Architecture Approved | Week 2 | Phase 1 | ⬜ Pending |
| M4: MVP Complete | Week 12 | Phase 3 | ⬜ Pending |
| M5: QA Sign-off | Week 20 | Phase 5 | ⬜ Pending |
| M6: Production Launch | Week 22 | Phase 6 | ⬜ Pending |
| M7: Project Close | Week 28 | Phase 8 | ⬜ Pending |

## Resource Allocation

### Team Size
| Role | Count | Allocation |
|------|-------|------------|
| Project Manager | 1 | 100% |
| Senior Developer | 1-2 | 100% |
| Junior Developer | 2-3 | 100% |
| UI/UX Designer | 1 | 60% |
| Tester | 1-2 | 80% |
| QA Engineer | 1 | 40% |

### Budget Breakdown
| Category | Allocation | Amount |
|----------|-------------|--------|
| Development | 50% | $XX,XXX |
| Design | 15% | $XX,XXX |
| Testing/QA | 15% | $XX,XXX |
| Project Management | 10% | $XX,XXX |
| Infrastructure | 10% | $XX,XXX |

## Gantt Chart

```
         W1 W2 W3 W4 W5 W6 W7 W8 W9 W10 W11 W12 W13 W14 W15 W16 W17 W18 W19 W20 W21 W22
Phase 1   ████████████
Phase 2            ████████████████
Phase 3                         ████████████████████████████████
Phase 4                                               ████████████████
Phase 5                                                           ████████████████
Phase 6                                                                        ████████
Phase 7                                                                                  ████████████████
Phase 8                                                                                                          ████████
```

## Dependencies

| Dependency | Type | Impact | Mitigation |
|------------|------|--------|------------|
| Third-party API | External | High | Fallback options |
| Design assets | Internal | Medium | Early design sprint |
| External team | External | Medium | Regular sync meetings |

---

*Timeline & Roadmap Skill v1.0.0*
