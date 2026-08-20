---
name: doc-guard
description: ANY documentation related task MUST use this skill as basic workflow (version 2.1)
---

# Doc-Guard: Technical Documentation Skill

Goal is to help the user with their TASK involving writing, reading, updating, and reviewing technical and architectural documentation.
This architectural and technical documentation is stored in individual ./doc/04-tech/ folders.

## ⚠️ MANDATORY WORKFLOW - MUST FOLLOW EVERY TIME

**This skill MUST be invoked and followed for ANY documentation-related task. Do NOT treat documentation tasks as generic search or information retrieval tasks.**

Ultimate goal of running the task with this skill is to identify the correct location, style, and required content based on the user task,
and then perform the user task.


### Step 1: IDENTIFY TASK PARAMETERS (MANDATORY - ALWAYS FIRST)

Before performing any action, you MUST explicitly identify and display:

1. **TASK** - What is the user asking me to do? (e.g., "check for known bugs", "document API", "update security review")
2. **TOPIC** - What is the subject matter? (e.g., "known bugs", "API specification", "security vulnerabilities")
3. **TARGET_FOLDER(s)** - Which doc/04-tech/ folder(s) are relevant? Use the Quick Reference below
4. **CROSS_REFERENCES** - What other folders relate to this task?

**Display this analysis to the user in a clear format before proceeding.**

Use the **Quick Reference** tables below to map user request to folders. If unclear, consult ./FOLDER_INDEX.md for detailed information.

### Step 2: UNDERSTAND DOCUMENTATION STRUCTURE (MANDATORY - ALWAYS SECOND)

Based on identified TARGET_FOLDER(s), you MUST:

1. Read the TARGET_FOLDER/_content.md file to understand:
   - Documentation format and structure
   - Level of detail expected
   - Existing content and gaps
   - Naming conventions and style

2. Read any existing files in TARGET_FOLDER to understand:
   - What is already documented
   - What is missing
   - Current state of documentation

3. You MUST summarize TASK PARAMETERS and tell the user WHERE and WHAT you plan to do. The HOW is not important now; it is the subject of the next step.

**Do NOT skip this step. This ensures consistency and prevents duplicating or contradicting existing documentation.**

### Step 3: PERFORM THE TASK (MANDATORY - ALWAYS THIRD)

Execute the user's TASK following the rules and structure learned in Steps 1 and 2.

### Step 4: SUMMARIZE AND VERIFY (MANDATORY - ALWAYS FOURTH)

When the task is complete or when the user asks:
1. Summarize what was done
2. Verify it aligns with the documentation structure
3. Confirm that all cross-references are properly documented
4. List any follow-up actions needed


## 🚨 ANTI-PATTERNS TO AVOID

**These mistakes caused the initial failure. NEVER do these:**

1. ❌ **Treating documentation tasks as generic search** - Do NOT use simple keyword search without skill methodology
2. ❌ **Skipping Step 1 (IDENTIFY)** - Do NOT proceed without explicitly identifying TASK, TOPIC, TARGET_FOLDER
3. ❌ **Skipping Step 2 (UNDERSTAND)** - Do NOT assume documentation structure; always read _content.md first
4. ❌ **Missing cross-references** - Do NOT ignore related folders; check Folder Relationships section
5. ❌ **Incomplete searches** - Do NOT search only one folder when multiple folders are relevant
6. ❌ **Ignoring existing documentation** - Do NOT create duplicate documentation; check what exists first

## ✅ CORRECT WORKFLOW EXAMPLE

**User Request**: "Check technical documentation for known bugs"

**Step 1 - IDENTIFY (Display this):**
```
TASK: Check technical documentation for known bugs
TOPIC: Known bugs, vulnerabilities, issues, limitations
TARGET_FOLDERS:
  - Primary: 17-Security (vulnerabilities, security issues)
  - Secondary: 16-Operational (known issues, troubleshooting)
  - Secondary: 20-Misc (known issues, limitations)
  - Related: 12-Development (bug tracking)
  - Related: 18-Verification (defect management)
CROSS_REFERENCES: Security reviews, defect tracking, operational procedures
```

**Step 2 - UNDERSTAND:**
- Read doc/04-tech/17-security/_content.md
- Read doc/04-tech/16-operational/_content.md
- Read doc/04-tech/20-misc/_content.md
- Check for existing bug documentation files
- Understand the structure and format

**Step 3 - PERFORM:**
- Search all identified folders for bug-related content
- Read existing bug documentation (e.g., mermaid_convert_security_review.md)
- Compile comprehensive bug report following documentation structure

**Step 4 - SUMMARIZE:**
- Display what was found
- Show where bugs are documented
- Provide recommendations for improvements

---

## QUICK REFERENCE - FOLDER MAPPING CHEAT SHEET



### Artifact Type → Folder Mapping

---

| Artifact Type | Primary Folder | Secondary | Tertiary |
|---------------|----------------|-----------|----------|
| **Diagrams & Visuals** | | | |
| System landscape diagram | 01 | 07 | 14 |
| Context diagram (C4 L1) | 01 | 07 | - |
| Component diagram | 07 | 09 | 11 |
| Data flow diagram | 07 | 10 | 03 |
| Deployment diagram | 14 | 15 | 16 |
| Network topology | 15 | 14 | 16 |
| Security architecture | 17 | 01 | 14 |
| Entity-relationship diagram | 10 | 07 | - |
| UML class diagram | 11 | 07 | 12 |
| UML sequence diagram | 11 | 09 | 03 |
| Activity/process diagram | 03 | 07 | - |
| Threat model diagram | 17 | 04 | - |
| **Requirements & Specifications** | | | |
| Functional requirements | 02 | 07 | 04 |
| Non-functional requirements | 04 | 05 | 06 |
| Use cases | 02 | 07 | - |
| User stories | 02 | 07 | - |
| Performance requirements | 04 | 18 | 13 |
| Security requirements | 17 | 04 | 06 |
| Availability/SLA | 04 | 16 | 14 |
| Scalability targets | 04 | 13 | 18 |
| **Architecture & Design** | | | |
| Architectural principles | 05 | 06 | 12 |
| Design patterns | 11 | 05 | 12 |
| Reference architecture | 06 | 05 | 13 |
| Technology stack | 13 | 06 | 12 |
| Integration patterns | 09 | 07 | 01 |
| Layering strategy | 07 | 11 | 05 |
| **Interfaces & Integration** | | | |
| API specification | 09 | 13 | 12 |
| REST API contract | 09 | 13 | - |
| SOAP service definition | 09 | 13 | - |
| Message format/schema | 09 | 10 | - |
| Database interface | 10 | 09 | - |
| Message queue definition | 09 | 10 | - |
| Interface versioning | 09 | 13 | - |
| **Data & Database** | | | |
| Database schema | 10 | 07 | - |
| Data model | 10 | 07 | - |
| Database procedures | 10 | 12 | - |
| Replication strategy | 10 | 14 | 16 |
| Backup/recovery plan | 10 | 16 | 14 |
| Data archiving policy | 10 | 16 | - |
| Data encryption spec | 10 | 17 | - |
| Data classification | 10 | 17 | 04 |
| **Development & Quality** | | | |
| Coding standards | 12 | 05 | 06 |
| Code quality tools config | 12 | 18 | - |
| Code review process | 12 | 17 | - |
| Build process | 12 | 13 | - |
| CI/CD pipeline | 12 | 13 | - |
| Testing framework | 12 | 18 | - |
| Secure coding practices | 12 | 17 | 06 |
| Dependency check report | 12 | 17 | - |
| **Testing & Verification** | | | |
| Test plan | 18 | 04 | 12 |
| Test cases | 18 | 12 | - |
| Functional test results | 18 | 04 | - |
| Performance test results | 18 | 04 | 13 |
| Load test results | 18 | 04 | - |
| Stress test results | 18 | 04 | - |
| Penetration test results | 17 | 18 | 04 |
| Vulnerability assessment | 17 | 18 | 12 |
| Test coverage report | 18 | 12 | - |
| **Deployment & Operations** | | | |
| Deployment topology | 14 | 15 | 01 |
| Deployment configuration | 14 | 13 | 16 |
| Installation guide | 14 | 16 | - |
| Rollout procedure | 14 | 16 | - |
| Recovery procedure | 14 | 16 | 10 |
| Operations runbook | 16 | 14 | 15 |
| Monitoring specification | 16 | 04 | 13 |
| SLA/KPI definition | 16 | 04 | - |
| Maintenance schedule | 16 | 14 | - |
| Incident response plan | 16 | 17 | - |
| Change management | 16 | 14 | - |
| **Security & Compliance** | | | |
| Security architecture | 17 | 01 | 14 |
| Authentication spec | 17 | 09 | 12 |
| Authorization policy | 17 | 12 | 04 |
| Encryption specification | 17 | 10 | 14 |
| Compliance documentation | 17 | 04 | 06 |
| Threat model | 17 | 04 | 01 |
| Access control matrix | 17 | 12 | - |
| Certificate management | 17 | 14 | 16 |
| OWASP ASVS mapping | 17 | 06 | 12 |
| **Infrastructure & Hardware** | | | |
| Infrastructure diagram | 15 | 14 | 01 |
| Hardware specifications | 15 | 13 | 14 |
| Network topology | 15 | 14 | 01 |
| Capacity planning | 15 | 04 | 16 |
| Redundancy specification | 15 | 14 | 16 |
| Disaster recovery plan | 15 | 16 | 14 |
| **Documentation & Meta** | | | |
| Document structure | 00 | - | - |
| Naming conventions | 00 | - | - |
| Glossary | 20 | - | - |
| Acronyms | 20 | - | - |

---

### Keyword → Folder Mapping

| Keyword | Folder | Keyword | Folder | Keyword | Folder |
|---------|--------|---------|--------|---------|--------|
| API | 09 | Monitoring | 16 | Scalability | 04 |
| Authentication | 17 | NFR | 04 | Schema | 10 |
| Authorization | 17 | OWASP | 17 | Security | 17 |
| Availability | 04 | Performance | 04 | SLA | 16 |
| Backup | 10 | Penetration | 17 | SOAP | 09 |
| Build | 12 | Process | 03 | Standards | 06 |
| Capacity | 15 | Protocol | 09 | Storage | 10 |
| Certificate | 17 | Quality | 12 | Test | 18 |
| CI/CD | 12 | Recovery | 16 | Threat | 17 |
| Code | 12 | Redundancy | 15 | Tool | 13 |
| Component | 07 | Requirement | 04 | Topology | 14 |
| Compliance | 17 | REST | 09 | Vulnerability | 17 |
| Constraint | 04 | Rollout | 14 | Workflow | 03 |
| Context | 01 | Runbook | 16 | - | - |

---

### Common User Queries → Folder

| User Says | Go To | Then Load |
|-----------|-------|-----------|
| "Save pen-test result" | 17 | 17-security/_content.md |
| "Document API" | 09 | 09-interfaces/_content.md |
| "Database schema" | 10 | 10-data/_content.md |
| "Deployment plan" | 14 | 14-deployment/_content.md |
| "Code review" | 12 | 12-development/code-quality/_content.md |
| "Performance test" | 18 | 18-verification/performance-testing/_content.md |
| "Security requirement" | 17 | 17-security/_content.md |
| "Use case" | 02 | 02-functional/_content.md |
| "System landscape" | 01 | 01-context/_content.md |
| "Build process" | 12 | 12-development/_content.md |
| "Monitoring setup" | 16 | 16-operational/_content.md |
| "Backup strategy" | 10 | 10-data/_content.md |
| "Coding standard" | 12 | 12-development/_content.md |
| "Disaster recovery" | 15 | 15-infrastructure/_content.md |
| "Threat model" | 17 | 17-security/_content.md |
| "Load test" | 18 | 18-verification/performance-testing/_content.md |
| "Component diagram" | 07 | 07-logical/_content.md |
| "Encryption" | 17 | 17-security/_content.md |
| "Scalability" | 04 | 04-non-functional/_content.md |
| "Integration" | 09 | 09-interfaces/_content.md |

---

### Folder Descriptions (One-Liner)

| # | Folder | Description |
|---|--------|-------------|
| 00 | Architecture Documentation | Document structure, templates, conventions |
| 01 | Context | System landscape, external systems, boundaries |
| 02 | Functional | Use cases, features, user roles, capabilities |
| 03 | Process | Business processes, workflows, automation flows |
| 04 | Non-Functional | Performance, scalability, availability, constraints |
| 05 | Principles | Architectural guidelines, design principles |
| 06 | Standards | Industry standards, reference architectures |
| 07 | Logical | Components, layers, decomposition, data flows |
| 09 | Interfaces | APIs, messaging, protocols, integration contracts |
| 10 | Data | Database, schemas, replication, backup, security |
| 11 | Design | Detailed design, patterns, UML, implementation |
| 12 | Development | Tools, build, code quality, testing, secure coding |
| 13 | Technology/Product | Technology selection, products, vendors, stack |
| 14 | Deployment | Deployment topology, configuration, rollout |
| 15 | Infrastructure | Hardware, network, capacity, redundancy, DR |
| 16 | Operational | Operations, monitoring, SLA, backup, incidents |
| 17 | Security | Authentication, authorization, encryption, threats |
| 18 | Verification | Testing, test plans, test results, benchmarks |
| 20 | Misc | Glossary, acronyms, references, appendices |

---

### Folder Relationships (Cross-References)

```
01-Context
  ├─ depends on: 07-Logical, 09-Interfaces
  ├─ feeds into: 14-Deployment, 17-Security
  └─ related: 16-Operational

02-Functional
  ├─ depends on: 01-Context
  ├─ feeds into: 03-Process, 07-Logical
  └─ related: 04-Non-Functional

03-Process
  ├─ depends on: 02-Functional
  ├─ feeds into: 07-Logical
  └─ related: 04-Non-Functional

04-Non-Functional
  ├─ depends on: 02-Functional, 03-Process
  ├─ feeds into: 05-Principles, 13-Technology, 18-Verification
  └─ related: 17-Security

05-Principles
  ├─ depends on: 04-Non-Functional
  ├─ feeds into: 12-Development
  └─ related: 06-Standards

06-Standards
  ├─ depends on: 05-Principles
  ├─ feeds into: 13-Technology
  └─ related: 17-Security

07-Logical
  ├─ depends on: 01-Context, 02-Functional, 03-Process
  ├─ feeds into: 09-Interfaces, 11-Design
  └─ related: 10-Data

09-Interfaces
  ├─ depends on: 07-Logical
  ├─ feeds into: 12-Development, 13-Technology
  └─ related: 10-Data

10-Data
  ├─ depends on: 07-Logical, 09-Interfaces
  ├─ feeds into: 14-Deployment, 16-Operational, 17-Security
  └─ related: 04-Non-Functional

11-Design
  ├─ depends on: 07-Logical
  ├─ feeds into: 12-Development
  └─ related: 09-Interfaces

12-Development
  ├─ depends on: 05-Principles, 06-Standards, 11-Design
  ├─ feeds into: 17-Security, 18-Verification
  └─ related: 13-Technology

13-Technology/Product
  ├─ depends on: 04-Non-Functional, 06-Standards
  ├─ feeds into: 14-Deployment
  └─ related: 12-Development

14-Deployment
  ├─ depends on: 13-Technology, 15-Infrastructure
  ├─ feeds into: 16-Operational
  └─ related: 01-Context

15-Infrastructure
  ├─ depends on: 04-Non-Functional
  ├─ feeds into: 14-Deployment, 16-Operational
  └─ related: 17-Security

16-Operational
  ├─ depends on: 14-Deployment, 15-Infrastructure
  ├─ feeds into: 17-Security
  └─ related: 04-Non-Functional

17-Security
  ├─ depends on: 04-Non-Functional, 06-Standards, 12-Development
  ├─ feeds into: 18-Verification
  └─ related: 14-Deployment, 16-Operational

18-Verification
  ├─ depends on: 04-Non-Functional, 12-Development
  ├─ feeds into: 17-Security
  └─ related: all
```



## APPENDIX A: Skill Directory Structure

### Understanding Path References in This Document

**CRITICAL: All paths in this document are relative to the skill directory, NOT the workspace root.**

This skill is located at `.roo/skills/doc-guard/` (in workspace-rooted skills) or
`~/.roo/skills/doc-guard/` (in global skills).

All file references like `./structure`, `./FOLDER_INDEX.md`, etc. refer to paths relative
to the **skill directory** (`doc-guard/`), not the workspace root.

### Skill Directory Contents

The doc-guard skill consists of the following files and folders:

```
doc-guard/                          # Skill directory (relative to .roo/skills/)
├── SKILL.md                        # This file - main skill instructions
├── FOLDER_INDEX.md                 # Quick reference index for folder identification
├── QUICK_REFERENCE.md              # Additional quick reference tables
└── structure/                      # Template documentation structure
    └── [00-20-*/]                  # Documentation template folders
        └── _content.md             # Each folder's content specification
```

### File Purposes

| File/Folder | Purpose | When Used |
|-------------|---------|-----------|
| `SKILL.md` | Main skill instructions - defines the workflow | Always loaded when skill activates |
| `FOLDER_INDEX.md` | Searchable index for rapid folder identification | Step 1: IDENTIFY - map user request to folders |
| `QUICK_REFERENCE.md` | Quick reference tables for folder mapping | Step 1: IDENTIFY - cheat sheet for folder types |
| `structure/` | Template documentation structure | Step 0: Initial workspace setup (first time only) |

---

## APPENDIX B: Initial Setup (First Time Only)

### Step 0: WORKSPACE INITIALIZATION (ONLY ON FIRST INVOCATION)

When this skill is invoked for the first time in a workspace, check whether `./doc/04-tech/` exists:

- **If NOT exists**: Create it based on the **skill's** `structure/` folder
  - Copy all folders from `./structure/` (skill-relative) to `./doc/04-tech/` (workspace-relative)
- **If EXISTS**: Combine them (diff folders and resolve):
  - Copy all missing files from `./structure/` (skill-relative) to `./doc/04-tech/` (workspace-relative)
  - If a workspace file differs from a `./structure/` file, ask the user which to use
  - Display a readable interpretation of diffs
  - Suggest a merging strategy to the user
- **Always keep**: Extra files and folders in `./doc/04-tech/` not present in `./structure/`

**Key distinction:**
- `./structure/` = skill's template folder (relative to skill directory)
- `./doc/04-tech/` = workspace documentation folder (relative to workspace root)



