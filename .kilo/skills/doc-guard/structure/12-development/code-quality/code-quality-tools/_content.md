# TODO change to read data from csv or even excel (xlsx2csv)

c="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"	

echo "

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

$(
	for f in $c/common/*.en.md; 
	do 
		echo " ";
		cat $f; 
		echo " "; 
	done \
	| md-shift-heading 2
)
