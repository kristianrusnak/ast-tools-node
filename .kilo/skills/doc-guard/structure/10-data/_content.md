# 10-data

## Data View - Data Architecture and Management

**Purpose:** Document the system's data architecture, including data storage, management, security, and how data flows through the system. For data-centric systems, this view may require decomposition into sub-views covering all architectural aspects.

The Data View addresses data-specific architectural concerns. For systems where data is central to the architecture (databases, data warehouses, data lakes), this view may expand to cover all architectural aspects (context, functional, process, non-functional, etc.) with a data focus.

## Key Objectives

This view shall answer the following questions:

* **What data does the system manage?** - Identification of key data entities
* **How is data stored?** - Storage technologies and strategies
* **How does data flow?** - Data movement and transformations
* **How is data accessed?** - Access patterns and interfaces
* **How is data secured?** - Data security and encryption
* **How is data backed up?** - Backup and recovery strategies
* **How is data replicated?** - Replication and synchronization
* **How is data monitored?** - Data quality and monitoring

## Content to Include

### 1. Data Architecture Overview

* **Data Strategy** - Overall approach to data management
* **Data Scope** - What data is managed
* **Data Stakeholders** - Who uses and manages data
* **Data Criticality** - Business importance of data
* **Data Constraints** - Constraints on data management
* **Data Governance** - How data is governed

### 2. Data Context

* **Data Entities** - Key data entities and their purposes
* **Data Sources** - Where data originates
* **Data Consumers** - Who uses the data
* **Data Flows** - How data flows through the system
* **Data Integration Points** - Where data is integrated
* **Data Storage Concepts** - Storage approaches (RDBMS, filesystem, cloud, etc.)

### 3. Data Functional View

* **Data Operations** - Create, Read, Update, Delete operations
* **Data Queries** - Common queries and searches
* **Data Reporting** - Reporting and analytics
* **Data Export** - Data export capabilities
* **Data Import** - Data import capabilities
* **Data Transformation** - Data transformation processes

### 4. Data Process View

* **Data Processing Workflows** - How data is processed
* **Batch Processing** - Batch data processing
* **Real-Time Processing** - Real-time data processing
* **Data Pipelines** - Data pipeline architecture
* **ETL Processes** - Extract, Transform, Load processes
* **Data Quality Checks** - Data quality validation

### 5. Data Non-Functional Requirements

* **Data Volume** - Expected data volume
* **Data Growth** - Expected data growth rate
* **Query Performance** - Query response time requirements
* **Data Availability** - Data availability requirements
* **Data Consistency** - Data consistency requirements
* **Data Retention** - Data retention policies
* **Data Archiving** - Data archiving strategies

### 6. Data Principles

* **Data Quality** - Data should be accurate and complete
* **Data Consistency** - Data should be consistent across systems
* **Data Security** - Data should be secure
* **Data Privacy** - Data privacy should be protected
* **Data Ownership** - Clear data ownership
* **Data Lineage** - Data lineage should be traceable
* **Data Reusability** - Data should be reusable

### 7. Data Standards and Common Solutions

* **Data Standards** - Industry standards for data (SQL, XML, JSON, etc.)
* **Data Models** - Common data models (relational, dimensional, etc.)
* **Data Formats** - Standard data formats
* **Data Interchange** - Standard data interchange formats
* **Data Quality Standards** - Data quality standards

### 8. Data Logical View

* **Data Model** - Logical data model
* **Entities** - Data entities and their attributes
* **Relationships** - Relationships between entities
* **Constraints** - Data constraints and rules
* **Database Objects** - Tables, views, indexes, etc.
* **Data Layers** - Logical layers for data management

### 9. Data Interface View

* **Database Interfaces** - How systems access the database
* **Database Users** - Roles and permissions
* **Database APIs** - Stored procedures, functions, views
* **Data Replication** - Replication interfaces
* **Data Extraction** - Data extraction interfaces
* **External Data Access** - How external systems access data

### 10. Data Design View

* **Database Schema** - Database schema design
* **Table Design** - Table structure and design
* **Index Strategy** - Indexing strategy
* **Partitioning** - Data partitioning strategy
* **Normalization** - Database normalization level
* **Denormalization** - Denormalization for performance
* **Stored Procedures** - Stored procedure design
* **Triggers** - Database triggers

### 11. Data Development View

* **Database Access** - How developers access the database
* **Development Tools** - Tools for database development
* **Database Management Tools** - Tools for database management
* **Monitoring Tools** - Tools for database monitoring
* **Profiling Tools** - Tools for performance profiling
* **Testing Tools** - Tools for database testing
* **Naming Conventions** - Database naming conventions
* **Coding Guidelines** - Database coding guidelines

### 12. Data Technology/Product Mapping

* **Database Product** - Database product used (Oracle, PostgreSQL, MySQL, etc.)
* **Database Version** - Database version
* **Replication Technologies** - Technologies for data replication
* **High Availability** - HA technologies and solutions
* **Backup/Restore** - Backup and restore products
* **Security Products** - Data security products
* **Monitoring Products** - Data monitoring products
* **Additional Software** - Other database-related software

### 13. Data Deployment View

* **Database Instances** - Database instances and their purposes
* **Database Sizing** - Database sizing and capacity
* **Storage Configuration** - Storage configuration
* **Network Configuration** - Network configuration for database
* **Backup Strategy** - Backup strategy and frequency
* **Recovery Strategy** - Recovery strategy and RTO/RPO
* **Archiving Strategy** - Data archiving strategy

### 14. Data Infrastructure View

* **Disk Configuration** - Disk layout and configuration
* **Storage Systems** - Storage systems used
* **Network Configuration** - Network configuration
* **Redundancy** - Redundancy and failover
* **Disaster Recovery** - Disaster recovery setup
* **Capacity Planning** - Capacity planning for data

### 15. Data Operational View

* **Backup and Recovery** - Backup and recovery procedures
* **Monitoring** - Data monitoring and alerting
* **Performance Tuning** - Performance tuning procedures
* **Maintenance** - Database maintenance procedures
* **Change Management** - Change management procedures
* **User Management** - User and permission management
* **Troubleshooting** - Troubleshooting procedures

### 16. Data Security View

* **Access Control** - User and role management
* **Authentication** - Database authentication
* **Authorization** - Database authorization
* **Data Encryption** - Data encryption at rest and in transit
* **Data Masking** - Data masking for sensitive data
* **Audit Logging** - Audit logging and tracking
* **Data Classification** - Data classification and labeling
* **Compliance** - Compliance requirements (GDPR, HIPAA, etc.)

## Documentation Techniques

### Approach 1: Entity-Relationship Diagrams

* ER diagrams showing entities and relationships
* Attribute documentation
* Constraint documentation
* Cardinality notation

### Approach 2: Data Flow Diagrams

* Diagrams showing how data flows through the system
* Data sources and destinations
* Data transformations
* Data storage locations

### Approach 3: Data Dictionary

* Comprehensive data dictionary
* Entity definitions
* Attribute definitions
* Data type specifications
* Constraint documentation

### Approach 4: Database Schema Documentation

* Database schema diagrams
* Table definitions
* Column specifications
* Index documentation
* Constraint documentation

## Key Principles

* **Data Quality** - Data should be accurate and complete
* **Data Security** - Data should be secure and protected
* **Data Consistency** - Data should be consistent
* **Data Accessibility** - Data should be accessible to authorized users
* **Data Maintainability** - Data architecture should be maintainable
* **Data Scalability** - Data architecture should scale with growth
* **Data Auditability** - Data changes should be auditable

## Common Pitfalls to Avoid

* **Poor Data Modeling** - Data model should be well-designed
* **Inadequate Indexing** - Indexes should be optimized
* **Inadequate Backup** - Backup strategy should be comprehensive
* **Poor Data Security** - Data should be properly secured
* **Inadequate Monitoring** - Data should be monitored
* **Poor Documentation** - Data architecture should be documented
* **Inadequate Capacity Planning** - Plan for data growth

## Checklist

- [ ] Data entities and attributes identified
- [ ] Data model documented
- [ ] Data flows documented
- [ ] Data storage strategy documented
- [ ] Database product selected and documented
- [ ] Database schema designed
- [ ] Indexing strategy documented
- [ ] Backup and recovery strategy documented
- [ ] Data security strategy documented
- [ ] Data replication strategy documented
- [ ] Data archiving strategy documented
- [ ] Data monitoring approach documented
- [ ] Data access controls documented
- [ ] Data quality standards defined
- [ ] Data dictionary created
- [ ] ER diagrams created
- [ ] Data flow diagrams created

## Related Documentation

* **Context View** - See 01-context for system scope
* **Functional View** - See 02-functional for data-related functions
* **Process View** - See 03-process for data processing workflows
* **Non-Functional View** - See 04-non-functional for data requirements
* **Logical View** - See 07-logical for data components
* **Interface View** - See 09-interfaces for data access interfaces
* **Design View** - See 11-design for detailed data design
* **Security View** - See 17-security for data security

## Example Structure

For a typical data-centric system, the Data View might include:

1. **Executive Summary** - Overview of data architecture
2. **Data Architecture Overview** - Overall approach to data
3. **Data Entities** - Key data entities and their purposes
4. **Data Model** - Logical and physical data models
5. **Database Design** - Database schema and design
6. **Data Flows** - How data flows through the system
7. **Data Access** - How data is accessed
8. **Data Security** - Data security and encryption
9. **Backup and Recovery** - Backup and recovery strategies
10. **Data Monitoring** - Data monitoring and quality
11. **Data Dictionary** - Complete data dictionary
12. **ER Diagrams** - Entity-relationship diagrams

---

Generated/modified by AI RooCode google/claude-haiku-4-5, used model google/claude-haiku-4-5
