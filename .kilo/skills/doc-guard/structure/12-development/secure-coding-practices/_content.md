c="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"	
echo "

# Secure Coding Practices

This chapter summarizes approach we use in development and quality assurance teams 
to achieve higher security standard of our code and final products.

## Overview

Pillars of secure coding principles are common with general QA principles. We use:

- Coding Rules or Coding Standard Documents - 
	to define patterns and antipatterns
- Code Templates and Wizards - 
	to assist developers with proven solutions and code snippets 
- Code Quality Tools - 
	to automatically check violations of the rules 
- Code Reviews - 
	to review design and coding beyond the scope of automated tools
- Testing -
	to test common vulnerabilities
- Deployment and Configuration Reviews -
	to ensure correct settings already in development and testing phases
	

In all these steps we are guided by existing guidelines:

- [OWASP Secure Coding Practices Guide](https://www.owasp.org/index.php/OWASP_Secure_Coding_Practices_-_Quick_Reference_Guide)
- [OWASP Application Security Verification Standard (ASVS)](https://www.owasp.org/index.php/Category:OWASP_Application_Security_Verification_Standard_Project)
- [OWASP Code Review Guide](https://www.owasp.org/index.php/Category:OWASP_Code_Review_Project)  
- [OWASP Testing Guide](https://www.owasp.org/index.php/OWASP_Testing_Project)

- [The CERT Oracle Secure Coding Standard for Java](https://www.securecoding.cert.org/confluence/display/java/Java+Coding+Guidelines)  

## Coding Rules

Coding Rules documents exist for every language/platform we use on the project 
(mainly for Java and JavaScript) and is updated periodically and published to developers. 

This document is used also as reference during code reviews.


## Code Templates and Wizards

Developers are encouraged to use file templates,  code snippets templates and wizard.
Currently we use our custom tooling in Eclipse environment for Java and JavaScript languages.

Snippets are written for most commonly used patterns, often created as replacement 
for antipatterns found during code reviews and developers are instructed to use them, 
instead of "in-correctly reinventing wheel".

 # Code Quality Tools 
$( 
	. "$c/../code-quality/code-quality-tools/code-quality-tools.sh.md" |\
	md-shift-heading 1
)

## Code Reviews

In general we use OWASP Code Review Guide as guideline for code reviews,
detection is assisted with Code Quality Tools and reviews are done on periodical bases
by senior developers. Serious findings are cross-project consulted and developers
educated about correct practices.

Code review process is well documented in separate chapters.  

## 3rd party libraries review

For 3rd party libraries in Java projects we use [OWASP Dependency Check](https://www.owasp.org/index.php/OWASP_Dependency_Check). Dependency-Check is a utility that identifies project dependencies and checks if there are any known, publicly disclosed, vulnerabilities. 

For JavaScript libraries (node.js) we use [snyk](https://snyk.io/) or [nodesecurity](https://nodesecurity.io/) + several own detectors (part of git-qa tools).

## Testing

Security testing during development is done mainly on Gray or White box principles.
Security related tests are created using out standard test stack, same as we use for unit testing.

Black Box testing or final Penetration Testing is mainly organized by customer (outsourced to specialized companies)
and we do not specialize in this area.

## Deployment and Configuration Reviews

Each deployment unit is inspected and documented for content by semi-automated tooling (custom GTI tooling), 
for code artefacts used and their just usage is evaluated. 

Also 3rd party libraries list is reviewed, in minimal version for 
explainable usage and patched versions. 

For key libraries we also monitor general issue and/or security lists 
to update versions when flaw is found and fixed.

Key configuration parameters from Dev and QA servers are automatically collected,
documented and reviewed for each change to prevent unintended misconfiguration 
that can lead to security issues.

We strive to achieve production ready setting on out QA (test servers) 
and their configuration is later used as blueprint for customer's deployment.

Configuration Management and Governance after deployment 
is usually performed by customer operation stuff with
their existing infrastructure and tools.
