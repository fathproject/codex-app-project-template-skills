---
name: requirements-analysis
description: Use when formal BRD, FRD, or user-story artifacts are needed, but prefer the AI-team intake and scope skills for early discovery and convergence.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - requirements
  - analysis
  - documentation
tags:
  - requirements
  - brd
  - frd
  - user-stories
  - acceptance-criteria
---

# Requirements Analysis Skill

## Status

Supporting formal-document skill.

For early-stage AI-team work, prefer:

1. `client-intake-normalizer`
2. `solution-options-tradeoffs`
3. `scope-convergence`

Use this skill after scope direction is stable enough to justify formal requirement artifacts.

## Overview

The AI creates comprehensive requirements documentation for projects.

## Requirements Documents

### 1. Project Charter
```markdown
# Project Charter

## Project Information
| Field | Value |
|-------|-------|
| Project Name | |
| Project Manager | AI-PM |
| Start Date | |
| Target Date | |
| Budget | |
| Status | Draft/Active/Completed |

## Project Purpose
[Why this project exists]

## Business Objectives
1. [Objective 1]
2. [Objective 2]
3. [Objective 3]

## Scope
### In Scope
- [Item 1]
- [Item 2]

### Out of Scope
- [Item 1]
- [Item 2]

## Stakeholders
| Name | Role | Interest | Influence |
|------|------|----------|-----------|

## High-Level Requirements
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

## Risks
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|

## Approval
| Name | Role | Signature | Date |
|------|------|-----------|------|
```

### 2. Business Requirements Document (BRD)
```markdown
# Business Requirements Document

## 1. Executive Summary
### 1.1 Purpose
### 1.2 Scope
### 1.3 Business Context

## 2. Business Objectives
### 2.1 Primary Objectives
- [ ] [Objective with measurable KPI]
- [ ] [Objective with measurable KPI]

### 2.2 Success Metrics
| Metric | Current | Target | Measurement |
|--------|---------|--------|-------------|

## 3. Stakeholder Analysis
| Stakeholder | Role | Needs | Expectations |
|-------------|------|-------|--------------|

## 4. Business Requirements
### 4.1 Functional Requirements
| ID | Requirement | Priority | Category |
|----|-------------|----------|----------|
| BR-001 | | Must Have | |
| BR-002 | | Should Have | |

### 4.2 Non-Functional Requirements
| Type | Requirement | Target |
|------|-------------|--------|
| Performance | Response time < 2s | 95th percentile |
| Availability | 99.9% uptime | Monthly |
| Scalability | Support 10K users | Year 1 |

## 5. Business Rules
1. [Rule 1]
2. [Rule 2]

## 6. Assumptions
- [Assumption 1]
- [Assumption 2]

## 7. Constraints
- [Constraint 1]
- [Constraint 2]

## 8. Dependencies
| Dependency | Impact | Owner |
|------------|--------|-------|
```

### 3. Functional Requirements Document (FRD)
```markdown
# Functional Requirements Document

## 1. Introduction
### 1.1 Purpose
### 1.2 Scope
### 1.3 Definitions

## 2. System Overview
### 2.1 System Context
### 2.2 User Characteristics

## 3. Functional Requirements

### 3.1 [Feature Name]
**ID**: FR-001
**Priority**: Must Have / Should Have / Could Have / Won't Have
**Description**: [What the feature does]

**User Story**:
```
As a [user type]
I want to [action]
So that [benefit]
```

**Actors**:
- Primary: [Actor]
- Secondary: [Actor]

**Preconditions**:
1. [Condition 1]
2. [Condition 2]

**Postconditions**:
1. [Outcome 1]
2. [Outcome 2]

**Main Flow**:
| Step | Actor | Action | System Response |
|------|-------|--------|-----------------|
| 1 | User | Clicks "Submit" | Validates input |
| 2 | System | | Saves to database |
| 3 | System | | Returns success |

**Alternative Flows**:
| Flow | Condition | Action |
|------|-----------|--------|
| A1 | Invalid input | Show error message |

**Acceptance Criteria**:
- [ ] [Criterion 1 - Given/When/Then format]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

**UI Requirements**:
- [Screen mockup reference]
- [Layout description]

**Data Requirements**:
| Field | Type | Validation | Required |
|-------|------|------------|----------|
| name | string | max 100 chars | Yes |

### 3.2 [Next Feature]
...
```

### 4. User Story Template
```markdown
## User Story: [Title]

**ID**: US-[Number]
**Feature**: [Feature Name]
**Priority**: High / Medium / Low
**Story Points**: [1/2/3/5/8/13]
**Iteration**: [Sprint]

### Story
```
As a [type of user]
I want to [perform action]
So that [achieve benefit]
```

### Acceptance Criteria
- [ ] Given [context] when [action] then [outcome]
- [ ] Given [context] when [action] then [outcome]
- [ ] Given [context] when [action] then [outcome]

### Technical Notes
- [Implementation hint]
- [Dependencies]

### Tasks
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]

### Test Scenarios
| Scenario | Test Data | Expected Result |
|----------|-----------|-----------------|
| Happy path | Valid data | Success message |
| Error case | Invalid data | Error message |
```

## Requirements Gathering Process

### Step 1: Discovery
```
1. Interview stakeholders
2. Review existing systems
3. Analyze business processes
4. Identify pain points
5. Document assumptions
```

### Step 2: Analysis
```
1. Categorize requirements
2. Prioritize using MoSCoW
3. Identify dependencies
4. Clarify ambiguities
5. Create models/diagrams
```

### Step 3: Specification
```
1. Write requirements documents
2. Create user stories
3. Define acceptance criteria
4. Add visual mockups
5. Review with stakeholders
```

### Step 4: Validation
```
1. Stakeholder review
2. Technical review
3. Feasibility check
4. Completeness check
5. Sign-off
```

## Prioritization Framework

### MoSCoW Method
| Priority | Description | Allocation |
|----------|-------------|------------|
| **M**ust Have | Core functionality, no go-live without | 60% |
| **S**hould Have | Important but not critical | 20% |
| **C**ould Have | Desirable improvements | 15% |
| **W**on't Have | Explicitly out of scope | 5% |

### Kano Model
| Category | Description | Impact |
|----------|-------------|--------|
| Must-be | Basic expectations | Dissatisfied if missing |
| Performance | Direct correlation | Satisfaction linear |
| Attractive | Delighters | Excited if present |

## Requirements Quality Checklist

### Completeness
- [ ] All user types identified
- [ ] All use cases covered
- [ ] Edge cases addressed
- [ ] Error scenarios defined
- [ ] Non-functional requirements included

### Clarity
- [ ] Unambiguous language
- [ ] No jargon without definition
- [ ] Single interpretation
- [ ] Testable criteria

### Consistency
- [ ] No contradictions
- [ ] Consistent terminology
- [ ] Aligned with business rules

### Feasibility
- [ ] Technically possible
- [ ] Within budget
- [ ] Within timeline
- [ ] Resources available

### Traceability
- [ ] Unique ID for each requirement
- [ ] Linked to business objectives
- [ ] Traced to design elements
- [ ] Traced to test cases

---

*Requirements Analysis Skill v1.0.0*
