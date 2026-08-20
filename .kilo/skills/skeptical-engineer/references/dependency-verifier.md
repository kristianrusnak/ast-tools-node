# Dependency Verifier

**Description:** Verify and research external dependencies, libraries, or APIs that the codebase uses. Use when the task involves an unfamiliar library or API (e.g. "Unknown" components that require research).

For any **external library or API** you need to use or update:

- **Find Version:** Look into `package.json`, `requirements.txt`, `.csproj`, or equivalent manifest to find the version in use. If the dependency isn't present, assume the latest stable version but flag this as an assumption.
- **Check Compatibility:** Research if the new usage is compatible with the current version. (E.g., does our version of the library support the function we intend to use?)
- **Documentation Lookup:** Use official docs or credible sources:
  - Prefer official docs, API reference, or source code on GitHub.
  - If not found, search Q&A sites like Stack Overflow for hints.
- **Snippet Extraction:** If possible, find a code snippet or example of how the dependency is used for our needed scenario.
- **Record Key Info:** Note functions, classes, or endpoints from the dependency that you will rely on, and any required initialization or configuration.
- **Update Plan:** Incorporate any required setup or version updates into the implementation plan. For example, "We need to update Library X from v1 to v2 to get feature Y" or "Add configuration for API Z's base URL in config file".
- **Cite Sources:** In your Phase 2 Verification table or planning notes, cite the documentation or source of truth for future reference.

**Example:** *Unknown:* "OAuth2Client library" – You find in `package.json` it's version 3.2. In docs, version 3.x requires an async init call. You plan to add that init in the code and note that you got it from the docs.
