DOT=$(relpath $SH_DOC_MASTER_FOLDER "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )")

# TODO: review all commands used and update please 

echo "

# Code Review

## Code Review Process

Code Review is one of the important QA technique we use on the projects.

### Overview

Code reviews are performed directly over code base in development branch of source control (git). 
The process consists of these steps:

1.	Developer can request for code review
	- Mark codes that need review with $C//REVIEW:$C comment in source code
	- Optionally emails to reviewers with explicit request
2.	Reviewer/QA finds files for code review, based on
	- explicit marks $C//REVIEW:$C in source code
	- or latest “interesting code” from last day
	- source code failing in code quality tools (PMD, JSHint, CopyPasteDetector)
		- detections from UI coding rules
	- source code failing in unit tests
	- or other criteria 
3.	Reviewer makes code reviews
	- He marks bad or suspicious code with $C//CODEREVIEW:$C comment
	- Or directly fixes the code
	- Commit with $C[CODEREVIEW]$C commit message
4.	QA personnel monitors source control for reviewed code
	- Find all files with $C//CODEREVIEW$C
	- Notify developers (owners) of the relevant source files
5.	Developer fixes the code, based on code review:
	- find reviews targeting my code, notification mail from QA
	- consult with reviewer if needed
	- fix/refactor the code (add comments, fix documentation etc..)
	- re-run test case if applicable
	- commit with $C[FIX][CODEREVIEW]$C and description of changes 
6.	QA personnel notifies reviewers of implemented fixes
7.	QA personnel creates and collects statistics and metrics of code review process

Next chapters describe each step in more detail



### Developer can request for code review

- Place $C //REVIEW:  message for reviewer $C into your source code, if you need review of your code. Make message clear and short
- Commit your source code to development branch
- Reviewers will be notified
- You will receive answer with $C//CODEREVIEW:$C comments in your code and receive email

### Reviewer/QA finds files for code review

There are several sources that may indicate files that need deeper code review.

### Code review based top files from JSHint, PMD or other metrics

- Files with maximum JSHint or PMD errors 
	- use QA JSHint report, received by mail
	- use PMD report
	- use other
- Review top files, identify other errors then JSHint

### Code review based on git-qa

Detection rules in git-qa detect violations as well as code review clues for suspicious code. 

Run git-qa tool 

	_tools/git-qa/scripts/runme.sh

View generated reports
	
	/_tools/git-qa/reports

### Code review based on last modified code/ code by author etc.

- Use git log to find lately modified files by author or other attributes.
- Find and review committed files with $C[FIX]$C to review reasons for bugs and review fix code quality
- Other…

### Reviewer makes code review

- Place $C //CODEREVIEW: message for developer $C comments in the source code
- Use $C //COREREVIEW: CRV XXXX $C format if developer violates concrete rule from coding-rules
	- Amend the coding-rules document if you find new anti-pattern or improvement possibility
	- Find similar cases in code base, and add git-qa or other detector if possible
	- Notify developers about new rules
- Monitor notifications from QA and review $C [FIX][CODEREVIEW] $C commits to see how developers fixed reported issues

### QA personnel monitors source control for reviewed code

- Pull latest version of dev. branch from repo
- To generate notifications for developers run 
	- _tools/git-qa/scripts/runme-coderw.sh
	- Note: It also internally runs generator of git-qa reports, the git-qa/scripts/runme.sh script

### Developer fixes the code, based on code review

- Understand the reported CODEREVIEW
	- Study coding-rules samples and links
	- Communicate with reviewer if needed (find reviewer using git blame)
- Fix the issue (may vary by CODEREVIEW nature)
	- Modify code
	- Add comments/documentation
- Commit with $C[FIX][CODEREVIEW]$C commit message and shortly explain principle of fixes
- If your fix is not satisfactory, you may receive another CODEREVIEW notifications later

### QA personnel notifies reviewers of implemented fixes

To generate report and send notifications run script
	
	_tools/git-qa/scripts/runme-fix-coderw.sh

### QA personnel creates and collects statistics and metrics of code review process

- Trend chart from codereview and todo reports

### Examples

Example of CODEREVIEW comment

Example of coding rule violation (CRV):

![]($DOT/res/crv-codereview-comment.png)

Request to add documentation to specific library method: 

![]($DOT/res/crv-codereview-comment2.png)

Code review questioning/challenging design decisions:

![]($DOT/res/crv-codereview-comment3.png) 

Example of code-review fix

Fix implemented as changed source code (original code is in previous example):

![]($DOT/res/crv-codereview-fix.png) 

Example of commit message for code-review fix
 
![]($DOT/res/crv-commit-message.png)

Example of notification email (codereview)

![]($DOT/res/crv-codereview-email.png)
 
Example of notification email (codereview fixes)

![]($DOT/res/crv-email-notification.png) 

Example of source control history and relevant CODEREVIEW and FIX messages

![]($DOT/res/crv-codereview-history.png)
 
Example of compare, after code review fix

![]($DOT/res/crv-after-codereview-fix.png)
 
Example of JSHint report from dev branch

This sample shows the number of errors in individual folders

![]($DOT/res/crv-number-of-errors.png)
 
Details of errors in Eclipse on the selected folder using customized JSHint view:

![]($DOT/res/crv-jshint-view.png)
 
Reviewer the can review identified files for more details.

Examples of git-qa reports

File stats report, number of suspicious constructions in individual files:

![]($DOT/res/crv-git-qa-reports.png)
 

 
