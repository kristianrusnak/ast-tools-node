

# Code Quality Tools

We use widely adopted stack of code quality tools, integrated to IDE and/or run as part of CI process.
Standard tools are enhanced with out own tooling to check for customized patterns antipatterns 
(including several secure coding detectors) 

Next table is example of setup, used as standard in our projects:

## Usage Overview

| 					| 				|JavaScript |HTML/JSPX 	|Java 	|Groovy |PL/SQL |Dev. Machine 	|Jenkins|
|--------- 			|-------- 		|---------- |---------- |----- 	|-------|-------|------------- 	|-------|
|Sonar 				|tool 			|N 			|N 			|Y 		|N 		|N 		|N 				|Y		|
|JSHint 			|tool 			|Y 			|N 			|N 		|N 		|N 		|Y 				|		|
|ESLint				|tool 			|Y			|N 			|N 		|N 		|N 		|Y 				|		|
|git-qa 			|tool 			|Y 			|Y 			|Y 		|Y 		|N 		|Y 				|Y		|
|cpd (PMD) 			|tool 			| 			| 			| 		| 		| 		| 				| 		| 
|CODEREVIEW 		|source code 	|Y 			|Y 			|Y 		|Y 		|N 		|Y* 			|Y		|
|TODO,FIXME			|source code 	|Y 			|Y 			|Y 		|Y 		|N 		|Y 				|Y		|
|Coding Rules 		|document 		|Y 			|Y 			|Y* 	|Y* 	|Y 		|Y 				|Y		|
|Coding Templates 	|tool 			|Y 			|Y 			|Y* 	|Y* 	|N 		|Y 				|N		| 


## What is Checked  

This covers various architectures, so some points are not applicable to certial projects
Exact configurations per project can be collected from tools config files.

- JavaScript
	- UI codes	(UI/.../views)	
	- mongo import files (BL/upm2-script/src/install/mongo/data/)
	- tests (TST/unit-test)
- Java
	- Business Codes (BL/.../)	

## Appendix - Code Quality Tools

 
### cpd (PMD - Copy Paste Detector)

PMD scans Java source code and looks for potential problems. 

- Possible bugs - empty try/catch/finally/switch statements
- Dead code - unused local variables, parameters and private methods
- Suboptimal code - wasteful String/StringBuffer usage
- Overcomplicated expressions - unnecessary if statements, for loops that could be while loops
- Duplicate code - copied/pasted code means copied/pasted bugs

PMD is licensed under a "BSD-style" license 
and part of this product (mostly the package net.sourceforge.pmd.lang.vm) is licensed under the Apache License, Version 2.0.
 
[(http://pmd.sourceforge.net/pmd-4.3.0/cpd.html)](http://pmd.sourceforge.net/pmd-4.3.0/cpd.html)

[(http://pmd.sourceforge.net)](http://pmd.sourceforge.net)




 
 
### ESLint

ESLint is an open source project. 
It's goal is to provide a pluggable linting utility for JavaScript.

[(https://eslint.org//)](https://eslint.org/)
 
 
### git-qa

Gratex developed validation and reporting tool detecting issues in 
source code, configurations, project layouts and other areas that are beyond scope or capabilities
of "standard" code quality tools. 

Based on bash scripts, backed with simple "greps and finds",
AST analyses (grasp, esprima), Java tools like DependencyExtractor and many others.

Designed to detect violations in our internal coding rules and 
mainly used as supporting tool for code reviews on JavaScript and Java projects.


  
 
### JSHint

JSHint is a community-driven tool to detect errors and potential problems in JavaScript code 
and to enforce coding conventions. 
It is very flexible and can be easily adjusted to particular coding guidelines 
and the environment the code is expected to execute in. 

JSHint is open source and will always stay this way.

[(http://jshint.com)](http://jshint.com)



 
 
### plato

JavaScript source code visualization, static analysis, and complexity tool 

[(https://github.com/es-analysis/plato)](https://github.com/es-analysis/plato)

 
 
### SonarQube

SonarQube™ software (previously known as “Sonar”) is an open source project. 
It is an open platform to manage code quality 
and can be used for many programming languages (including Java and JavaScript) 
and used by various team members and project stakeholders. 

[(http://www.sonarqube.org/)](http://www.sonarqube.org/)
 

