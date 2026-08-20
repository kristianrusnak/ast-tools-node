---
title: Architecture Documentation Structure - Folder Index
description: Dense, searchable index for rapid folder identification
version: 1.0
date: 2026-02-27
---

# Folder Index - Quick Reference Guide

**Purpose:** Enable LLMs to quickly identify the correct folder for any documentation artifact without loading full _content.md files.

**Usage:** Load this file first. When user provides artifact/question, search this index to identify target folder(s), then load specific _content.md for details.

---

## Index Format

Each section contains:
- **Folder ID** (00-20)
- **Folder Name**
- **Keywords** - Searchable terms
- **Artifact Types** - What gets stored here
- **Related Folders** - Cross-references
- **Example Queries** - Sample user questions

---

## 00-architecture-documentation

**Keywords:** documentation, structure, template, blueprint, document-layout, organization, conventions

**Artifact Types:**
- Documentation templates
- Document structure guidelines
- Naming conventions
- Folder organization plans
- Document metadata

**Related Folders:** All (meta-documentation)

**Example Queries:**
- "How should I organize my architecture documents?"
- "What's the document template structure?"
- "Document naming conventions"
- "Create documentation outline"

---

## 01-context

**Keywords:** context, landscape, system-overview, external-systems, actors, integration-points, boundaries, stakeholders, system-scope, deployment-context

**Artifact Types:**
- System landscape diagrams
- Context diagrams (C4 Level 1)
- External system lists
- Actor/user identification
- System boundary definitions
- Integration point maps
- Stakeholder lists
- System scope statements

**Related Folders:** 09-interfaces, 14-deployment, 16-operational, 17-security

**Example Queries:**
- "Document system landscape"
- "List external systems"
- "Create context diagram"
- "Identify system boundaries"
- "Who are the actors?"
- "What systems integrate with us?"

---

## 02-functional

**Keywords:** functional, requirements, use-cases, features, user-stories, actors, roles, functional-users, business-functions, capabilities

**Artifact Types:**
- Use case diagrams
- User story maps
- Feature lists
- Functional requirements
- Actor/role definitions
- Business capability maps
- Functional architecture diagrams

**Related Folders:** 03-process, 04-non-functional, 07-logical

**Example Queries:**
- "Document use cases"
- "List functional requirements"
- "Define user roles"
- "Create feature map"
- "What are the key functions?"

---

## 03-process

**Keywords:** process, workflow, business-process, automation, flow, parallelism, asynchronous, concurrency, process-flow, activity-diagram

**Artifact Types:**
- Process flow diagrams
- Activity diagrams
- Workflow descriptions
- Business process models
- Sequence flows
- Parallel process definitions
- Error handling flows

**Related Folders:** 02-functional, 04-non-functional, 07-logical

**Example Queries:**
- "Document business process"
- "Create workflow diagram"
- "Show process flow"
- "Define parallel processes"
- "How does the system automate this?"

---

## 04-non-functional

**Keywords:** non-functional, requirements, NFR, performance, scalability, availability, security, reliability, constraints, SLA, throughput, latency, uptime

**Artifact Types:**
- Non-functional requirements
- Constraint lists
- Performance requirements
- Scalability targets
- Availability/SLA definitions
- Security requirements
- Reliability specifications
- Capacity planning

**Related Folders:** 05-principles, 06-standards, 17-security

**Example Queries:**
- "Document non-functional requirements"
- "Define performance targets"
- "Set availability SLA"
- "List constraints"
- "Scalability requirements"
- "Security requirements"

---

## 05-principles

**Keywords:** principles, architectural-principles, guidelines, standards, patterns, consistency, design-principles, best-practices

**Artifact Types:**
- Architectural principles
- Design guidelines
- Development principles
- Consistency rules
- Best practice statements
- Principle definitions

**Related Folders:** 06-standards, 12-development

**Example Queries:**
- "Define architectural principles"
- "Document design guidelines"
- "What principles guide this architecture?"

---

## 06-standards

**Keywords:** standards, industry-standards, common-solutions, reference-architecture, best-practices, patterns, frameworks, technologies, OWASP, ISO, W3C

**Artifact Types:**
- Industry standard references
- Reference architecture descriptions
- Common solution patterns
- Framework documentation
- Standard compliance statements
- Best practice references

**Related Folders:** 05-principles, 13-technology-product-mapping

**Example Queries:**
- "What standards apply?"
- "Reference architecture"
- "Industry best practices"
- "OWASP guidelines"
- "Common solutions"

---

## 07-logical

**Keywords:** logical, components, architecture, decomposition, layers, logical-layers, responsibilities, dependencies, data-flow, component-diagram

**Artifact Types:**
- Component diagrams
- Logical architecture diagrams
- Component responsibility lists
- Layer definitions
- Data flow diagrams
- Dependency matrices
- Component interaction diagrams

**Related Folders:** 02-functional, 03-process, 09-interfaces, 11-design

**Example Queries:**
- "Create component diagram"
- "Define logical layers"
- "Component responsibilities"
- "System decomposition"
- "Data flows between components"

---

## 08-[RESERVED]

**Status:** Gap in numbering (Interface View moved to 09)

---

## 09-interfaces

**Keywords:** interface, integration, API, messaging, protocol, synchronous, asynchronous, message-format, SOAP, REST, HTTP, database, queue, topic, versioning, idempotency

**Artifact Types:**
- Interface specifications
- API documentation
- Message format definitions
- Protocol specifications
- Integration contracts
- Interface versioning plans
- WSDL/WADL documents
- XSD/DTD schemas
- Interface ownership documentation

**Related Folders:** 01-context, 07-logical, 12-development, 13-technology-product-mapping

**Example Queries:**
- "Document API interface"
- "Define message format"
- "Interface specification"
- "REST API contract"
- "Message queue definition"
- "Interface versioning"
- "SOAP service definition"

---

## 10-data

**Keywords:** data, database, RDBMS, storage, schema, tables, views, procedures, data-model, replication, backup, archiving, data-security, encryption, audit

**Artifact Types:**
- Database schemas
- Entity-relationship diagrams
- Data models
- Database procedures/functions
- Replication strategies
- Backup/recovery plans
- Data archiving policies
- Data security specifications
- Database sizing estimates
- Data classification schemes

**Related Folders:** 04-non-functional, 09-interfaces, 14-deployment, 16-operational, 17-security

**Example Queries:**
- "Database schema"
- "Data model"
- "Backup strategy"
- "Data replication"
- "Database sizing"
- "Data encryption"
- "Archiving policy"

---

## 11-design

**Keywords:** design, detailed-design, patterns, implementation, architecture-patterns, design-patterns, layering, frameworks, blueprints, UML, class-diagram, sequence-diagram

**Artifact Types:**
- Detailed design documents
- Design pattern descriptions
- UML class diagrams
- UML sequence diagrams
- Implementation blueprints
- Framework usage patterns
- Technology-specific designs
- Code architecture patterns

**Related Folders:** 07-logical, 12-development

**Example Queries:**
- "Detailed design"
- "Design patterns"
- "UML diagrams"
- "Implementation blueprint"
- "Framework usage"

---

## 12-development

**Keywords:** development, tools, source-control, git, svn, build, release, coding-standards, code-quality, testing, CI/CD, code-review, secure-coding, OWASP

**Artifact Types:**
- Development tool lists
- Source control configuration
- Build process documentation
- Release process documentation
- Coding standards/guidelines
- Code quality tool configurations
- Code review processes
- Testing frameworks
- CI/CD pipeline definitions
- Secure coding practices
- Dependency check reports

**Related Folders:** 04-non-functional, 06-standards, 17-security, 18-verification

**Example Queries:**
- "Development tools"
- "Coding standards"
- "Code quality tools"
- "Build process"
- "Code review process"
- "Testing framework"
- "CI/CD pipeline"
- "Secure coding"

---

## 12-development/code-quality

**Keywords:** code-quality, tools, JSHint, ESLint, Sonar, PMD, code-review, quality-metrics, code-analysis

**Artifact Types:**
- Code quality tool configurations
- Code quality metrics
- Code review guidelines
- Quality gates
- Tool integration documentation
- Quality reports

**Related Folders:** 12-development, 18-verification

**Example Queries:**
- "Code quality tools"
- "Code review"
- "Quality metrics"
- "Sonar configuration"

---

## 12-development/unit-testing

**Keywords:** testing, unit-test, test-framework, test-tools, test-coverage, TDD, test-process

**Artifact Types:**
- Unit test frameworks
- Test coverage reports
- Test process documentation
- Test tools configuration
- Test case examples

**Related Folders:** 12-development, 18-verification

**Example Queries:**
- "Unit testing"
- "Test framework"
- "Test coverage"

---

## 12-development/secure-coding-practices

**Keywords:** security, secure-coding, OWASP, code-security, vulnerability, dependency-check, code-review-security, secure-patterns

**Artifact Types:**
- Secure coding guidelines
- OWASP references
- Vulnerability checklists
- Dependency check reports
- Security code review guidelines
- Secure code patterns

**Related Folders:** 12-development, 17-security

**Example Queries:**
- "Secure coding"
- "OWASP guidelines"
- "Vulnerability check"
- "Dependency security"

---

## 13-technology-product-mapping

**Keywords:** technology, products, tools, software, hardware, vendor, selection, decision, technology-stack, framework, library, database-product, application-server

**Artifact Types:**
- Technology selection documents
- Product comparison matrices
- Technology stack definitions
- Vendor selection justifications
- Product version specifications
- Technology constraint mappings
- Tool selection decisions

**Related Folders:** 04-non-functional, 06-standards, 14-deployment

**Example Queries:**
- "Technology selection"
- "Product comparison"
- "Technology stack"
- "Vendor selection"
- "Framework choice"

---

## 14-deployment

**Keywords:** deployment, deployment-topology, deployment-units, WAR, EAR, clustering, HA, failover, rollout, recovery, installation, configuration, environment

**Artifact Types:**
- Deployment topology diagrams
- Deployment unit definitions
- Deployment configuration
- Rollout procedures
- Recovery procedures
- Installation guides
- Environment specifications
- Clustering configuration

**Related Folders:** 01-context, 13-technology-product-mapping, 15-infrastructure, 16-operational

**Example Queries:**
- "Deployment topology"
- "Deployment configuration"
- "Rollout procedure"
- "Recovery plan"
- "Installation guide"

---

## 15-infrastructure

**Keywords:** infrastructure, hardware, network, physical, servers, storage, networking, firewall, load-balancer, redundancy, disaster-recovery, capacity

**Artifact Types:**
- Infrastructure diagrams
- Hardware specifications
- Network topology diagrams
- Capacity planning documents
- Redundancy specifications
- Disaster recovery plans
- Infrastructure sizing

**Related Folders:** 14-deployment, 16-operational

**Example Queries:**
- "Infrastructure diagram"
- "Hardware specifications"
- "Network topology"
- "Capacity planning"
- "Disaster recovery"

---

## 16-operational

**Keywords:** operational, operations, monitoring, management, support, SLA, KPI, backup, recovery, maintenance, troubleshooting, escalation, runbook, incident, problem

**Artifact Types:**
- Operations runbooks
- Monitoring specifications
- SLA/KPI definitions
- Backup/recovery procedures
- Maintenance schedules
- Troubleshooting guides
- Escalation procedures
- Incident response plans
- Operations calendars
- Change management procedures

**Related Folders:** 14-deployment, 15-infrastructure, 17-security

**Example Queries:**
- "Operations runbook"
- "Monitoring setup"
- "SLA definition"
- "Backup procedure"
- "Troubleshooting guide"
- "Incident response"
- "Maintenance schedule"

---

## 17-security

**Keywords:** security, authentication, authorization, encryption, confidentiality, compliance, OWASP, ASVS, penetration-test, pen-test, vulnerability, threat, risk, access-control, firewall, SSL, TLS, certificate

**Artifact Types:**
- Security architecture diagrams
- Authentication specifications
- Authorization policies
- Encryption specifications
- Security requirements
- Compliance documentation
- Penetration test results
- Vulnerability assessments
- Security threat models
- Access control matrices
- Certificate management plans
- Security incident procedures

**Related Folders:** 04-non-functional, 06-standards, 12-development, 18-verification

**Example Queries:**
- "Security architecture"
- "Authentication"
- "Authorization"
- "Encryption"
- "Penetration test"
- "Vulnerability assessment"
- "Compliance"
- "OWASP ASVS"
- "Threat model"
- "Access control"

---

## 18-verification

**Keywords:** verification, testing, functional-testing, performance-testing, test-plan, test-case, test-result, acceptance-testing, regression-testing, load-testing, stress-testing

**Artifact Types:**
- Test plans
- Test cases
- Test results
- Functional test reports
- Performance test reports
- Load test results
- Stress test results
- Acceptance test criteria
- Regression test suites
- Test coverage reports

**Related Folders:** 12-development, 04-non-functional

**Example Queries:**
- "Test plan"
- "Test cases"
- "Test results"
- "Performance test"
- "Load test"
- "Functional test"

---

## 18-verification/functional-testing

**Keywords:** functional-testing, test-case, acceptance-test, regression-test, test-tool, Selenium, test-automation

**Artifact Types:**
- Functional test cases
- Acceptance test criteria
- Regression test suites
- Test automation scripts
- Functional test reports

**Related Folders:** 18-verification

**Example Queries:**
- "Functional test"
- "Test case"
- "Acceptance criteria"

---

## 18-verification/performance-testing

**Keywords:** performance-testing, load-test, stress-test, benchmark, throughput, latency, response-time, JMeter, LoadRunner

**Artifact Types:**
- Performance test plans
- Load test results
- Stress test results
- Performance benchmarks
- Response time measurements
- Throughput measurements
- Performance test reports

**Related Folders:** 18-verification

**Example Queries:**
- "Performance test"
- "Load test"
- "Stress test"
- "Benchmark"
- "Response time"

---

## 20-misc

**Keywords:** miscellaneous, other, additional, appendix, reference, glossary, acronyms

**Artifact Types:**
- Glossaries
- Acronym lists
- Reference materials
- Additional documentation
- Appendices

**Related Folders:** All

**Example Queries:**
- "Glossary"
- "Acronyms"
- "Reference"

---

## Quick Search Matrix

| User Query | Target Folder(s) | Priority |
|------------|------------------|----------|
| "Save pen-test result" | 17-security, 18-verification | 17 |
| "Document API" | 09-interfaces, 13-technology-product-mapping | 09 |
| "Database schema" | 10-data, 07-logical | 10 |
| "Deployment plan" | 14-deployment, 15-infrastructure | 14 |
| "Code review" | 12-development/code-quality, 17-security | 12 |
| "Performance test" | 18-verification/performance-testing, 04-non-functional | 18 |
| "Security requirement" | 17-security, 04-non-functional | 17 |
| "Use case" | 02-functional, 07-logical | 02 |
| "System landscape" | 01-context, 07-logical | 01 |
| "Build process" | 12-development, 13-technology-product-mapping | 12 |
| "Monitoring" | 16-operational, 04-non-functional | 16 |
| "Backup strategy" | 10-data, 16-operational | 10 |
| "Coding standard" | 12-development, 05-principles | 12 |
| "Disaster recovery" | 15-infrastructure, 16-operational | 15 |
| "Threat model" | 17-security, 01-context | 17 |

---

## LLM Usage Pattern

### Step 1: Load Index
```
Load FOLDER_INDEX.md into context
```

### Step 2: User Query
```
User: "Save pen-test result"
```

### Step 3: Search Index
```
Search keywords: "pen-test", "penetration", "security", "vulnerability"
Match: 17-security (primary), 18-verification (secondary)
```

### Step 4: Load Detailed Content
```
Load 17-security/_content.md for detailed guidance
```

### Step 5: Provide Guidance
```
Based on 17-security/_content.md, provide specific folder structure,
file naming, format requirements, and cross-references
```

---

## File Size Comparison

| File | Size | Purpose |
|------|------|---------|
| FOLDER_INDEX.md | ~15 KB | Quick search, folder identification |
| 17-security/_content.md | ~50 KB | Detailed guidance, examples, checklists |
| structure.md-review.md | ~80 KB | Analysis, comparison, recommendations |

**Total Context Load:**
- Index only: 15 KB (fast, searchable)
- Index + 1 detailed section: 65 KB (manageable)
- All detailed sections: 1+ MB (prohibitive)

---

Generated/modified by AI RooCode google/claude-haiku-4-5
