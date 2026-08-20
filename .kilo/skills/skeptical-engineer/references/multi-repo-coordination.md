# Multi-Repo Coordination

**Description:** Coordinate tasks spanning multiple repositories. Use when a user request involves changes in more than one project or package.

When a task involves **multiple repositories** or modules:

- **Identify Repos:** Clearly enumerate which repositories (or sub-projects) are involved. Use their names in your plan steps for clarity.
- **Isolate Changes:** Plan changes repo by repo. For each repo, handle its changes in a separate section or sequence of steps, so as not to intermingle file modifications unintentionally.
- **Cross-Repo Dependencies:** Determine if one repo's changes depend on another (e.g., update library in Repo A before updating Repo B that consumes it). Plan the order of implementation and testing accordingly.
- **Testing Across Repos:** After implementing changes, run tests in each repo. If possible, also test the integrated scenario (for instance, if Repo B depends on a package built from Repo A, ensure Repo B is tested against the new version from Repo A).
- **Version Management:** If introducing changes in one repo that affect another (like an API change or a library version bump), update version numbers or API clients in lock-step. Document these in the plan.
- **Communication:** In outputs, prefix file paths with an identifier if needed, e.g. `[RepoA] path/to/file.js` to avoid confusion.
- **Proof & Logging:** Log proof-of-work for each repo if applicable (you might have multiple entries, or a combined entry that references both).

**Example Scenario:**
- *User request:* "Update the authentication service in backend repo and adjust the frontend repo to use the new auth token format."
- You should plan:
  1. Changes in `backend/` repo (files X, Y) to output new token.
  2. Bump backend service version (if it's a dependency).
  3. Changes in `frontend/` repo (files A, B) to consume new token.
  4. Test backend (unit + integration), test frontend (unit + integration with maybe a stubbed backend or using a test instance of backend).
  5. Ensure the backend is deployed or available for the frontend tests if needed.
- Always ensure neither repo is left in an untested state.
