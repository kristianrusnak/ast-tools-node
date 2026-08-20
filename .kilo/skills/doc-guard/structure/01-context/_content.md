# 01-context

## Context View - Understanding the System Landscape

**Purpose:** Establish the big picture by identifying the system and all external systems it interfaces with.

One of the hardest things about software development is being asked to come up with a design when all you're given is a set of requirements and a blank sheet of paper. The Context View is your starting point to step back and see the big picture. What exactly is the context here? What is this all about? What is it we're building and how does it fit in with the existing environment?

## Key Objectives

This view shall answer the following questions:

* **What is the system?** - Clear definition and scope of the system being documented
* **What systems does it interact with?** - Identification of all external systems, applications, and services
* **What are the system boundaries?** - Clear delineation of what is inside vs. outside the system
* **Who are the key actors/users?** - Identification of external systems, users, and stakeholders
* **What are the integration points?** - Clear understanding of all interfaces and connections
* **How does it fit in the landscape?** - Understanding of the system's role in the broader IT environment

## Content to Include

### 1. System Overview

* **System Name and Version** - Clear identification of the system being documented
* **System Purpose** - High-level statement of what the system does and why it exists
* **System Scope** - What is included and what is explicitly excluded
* **Key Stakeholders** - Business owners, users, operations teams, development teams
* **Business Context** - Business drivers, strategic importance, competitive advantage

### 2. System Landscape Diagram

A simple block diagram showing:

* **Your System** - Typically shown in the center or as the focal point
* **External Systems** - All systems that your system interfaces with or depends on
* **External Actors** - Users, customers, third-party systems, external services
* **Integration Points** - Connections between your system and external entities
* **Data Flows** - High-level indication of data movement between systems

**Diagram Characteristics:**
* Abstraction is key - detail isn't important at this level
* Use simple boxes/cards to represent systems
* Annotate connections with brief descriptions of purpose
* Show direction of communication (inbound/outbound)
* Use consistent visual notation

### 3. External Systems and Dependencies

For each external system, document:

* **System Name** - Clear identification
* **System Owner/Operator** - Who is responsible for this system
* **Purpose of Integration** - Why does your system need to interact with this system
* **Type of Integration** - Synchronous/Asynchronous, Real-time/Batch, etc.
* **Data Exchanged** - What information flows between systems
* **Criticality** - Is this system critical to your system's operation
* **Availability Requirements** - What uptime/SLA is required
* **Contact Information** - Technical contact for integration issues

### 4. External Actors and Users

Identify and describe:

* **User Roles** - Different types of users (customers, administrators, operators, etc.)
* **External Systems Acting as Users** - Other systems that consume your system's services
* **Third-Party Integrations** - External services, APIs, cloud services
* **Regulatory Bodies** - External entities with compliance requirements
* **Support/Operations Teams** - External teams that support the system

### 5. System Interfaces and Protocols

Document:

* **Communication Protocols** - HTTP/HTTPS, SOAP, REST, messaging, database connections, etc.
* **Data Formats** - XML, JSON, CSV, binary, proprietary formats
* **Authentication/Authorization** - How external systems authenticate
* **Network Connectivity** - Network paths, firewalls, DMZs, VPNs
* **Performance Characteristics** - Expected throughput, latency, volume

### 6. Integration Patterns

Describe the patterns used for integration:

* **Point-to-Point** - Direct connections between systems
* **Hub-and-Spoke** - Central integration hub (ESB, API Gateway)
* **Publish-Subscribe** - Event-driven integration
* **Request-Response** - Synchronous request/reply patterns
* **Batch Processing** - Scheduled data exchanges

### 7. System Dependencies

Document:

* **Required Systems** - Systems that must be available for your system to function
* **Optional Systems** - Systems that enhance functionality but aren't critical
* **Dependency Chain** - How dependencies cascade (A depends on B, B depends on C)
* **Failure Impact** - What happens if each external system fails
* **Fallback Strategies** - How your system handles external system failures

### 8. Deployment Context

* **Hosting Environment** - On-premise, cloud, hybrid
* **Network Topology** - DMZ, internal networks, external networks
* **Geographic Distribution** - Single location, multi-site, global
* **Regulatory/Compliance Context** - Data residency, compliance requirements
* **Infrastructure Dependencies** - Load balancers, firewalls, proxies, etc.

## Diagram Approaches

### Approach 1: System-Centric View

Place your system in the center with external systems surrounding it:

```
                    [External System A]
                            |
                            |
[External System B] -- [YOUR SYSTEM] -- [External System C]
                            |
                            |
                    [External System D]
```

### Approach 2: Actor-Centric View

Show key actors and their interactions with your system:

```
[User/Actor A] --|
                 |
[User/Actor B] --|-- [YOUR SYSTEM] -- [External System A]
                 |                     [External System B]
[User/Actor C] --|
```

### Approach 3: Layered View

Show systems organized by tier or layer:

```
[Presentation Layer]
    |
[Application Layer] -- [YOUR SYSTEM] -- [Integration Layer]
    |
[Data Layer]
```

## Documentation Techniques

### Whiteboard/Index Card Approach

* Use physical index cards to represent systems
* Annotate each card with system name and high-level responsibilities
* Similar to Class-Responsibility-Collaboration (CRC) cards but at system level
* Arrange cards to show relationships and dependencies
* Photograph or digitize the result

### Formal Diagram Tools

* UML Component Diagrams
* C4 Model - Context Diagram (Level 1)
* ArchiMate Diagrams
* Draw.io, Lucidchart, Visio, or similar tools

### Narrative Description

* Textual description of system landscape
* Organized by system type or integration pattern
* Cross-references to detailed integration documentation

## Key Principles

* **Abstraction First** - Focus on the big picture, not implementation details
* **Clarity Over Completeness** - Show what matters, omit what doesn't
* **Consistency** - Use consistent notation and terminology
* **Traceability** - Link to detailed documentation for each external system
* **Maintainability** - Keep the diagram simple enough to update easily

## Common Pitfalls to Avoid

* **Too Much Detail** - Don't show internal system components at this level
* **Missing Systems** - Ensure all integration points are identified
* **Unclear Boundaries** - Make it obvious what is inside vs. outside the system
* **Outdated Diagrams** - Keep the context diagram current as systems change
* **Ambiguous Connections** - Clearly label what data/information flows

## Checklist

- [ ] System name, version, and purpose clearly defined
- [ ] System scope and boundaries clearly stated
- [ ] All external systems identified and documented
- [ ] All external actors/users identified
- [ ] System landscape diagram created and reviewed
- [ ] Integration points clearly marked
- [ ] Data flows between systems documented
- [ ] External system dependencies documented
- [ ] Criticality and availability requirements noted
- [ ] Contact information for external systems provided
- [ ] Deployment context understood
- [ ] Diagram reviewed by stakeholders
- [ ] Diagram linked to detailed integration documentation

## Related Documentation

* **Detailed Integration Specifications** - See Interface View (09-interfaces) for detailed interface specifications
* **Deployment View** - See 14-deployment for how systems are deployed
* **Operational View** - See 16-operational for operational dependencies
* **Security View** - See 17-security for security context and trust boundaries

## Example Structure

For a typical system, the Context View might include:

1. **Executive Summary** - One paragraph overview
2. **System Overview** - Purpose, scope, stakeholders
3. **System Landscape Diagram** - Visual representation
4. **External Systems Table** - Tabular list of all external systems
5. **Integration Points** - Detailed description of each integration
6. **External Actors** - User roles and external systems
7. **Dependencies** - What the system depends on
8. **Deployment Context** - Where and how it's deployed

---

Generated/modified by AI RooCode google/claude-haiku-4-5
