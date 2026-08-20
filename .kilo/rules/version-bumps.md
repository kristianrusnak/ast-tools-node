# Rules for version bumping
This rule applies to modifying any files that have already some form of "version marker" (using strings for semantic versioning, various forms of dates etc). 
Search for version markers in the context of modified file, detect version markers and adjust them approprietally. Use semantic versioning when applicable.
If modifying files under node.js project, consider bumping version to package.json or another project file.