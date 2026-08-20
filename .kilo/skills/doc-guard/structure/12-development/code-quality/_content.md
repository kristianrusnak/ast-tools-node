c="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "

# Code Quality 

This document describes the process and tools 
we use in development to ensure code quality.

## Coding Rules

Developers are guided by ....
 
TODO: add here your project specific set of coding rules



$( . "$c/code-quality-tools/code-quality-tools.sh.md" | md-shift-heading 1)

$( . "$c/code-review/code-review.sh.md" | md-shift-heading 1)
