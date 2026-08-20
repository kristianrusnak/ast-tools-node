---
description: "Generate a newsletter summarizing git commits."
argument-hint: number-of-days
---

This command generates a newsletter summarizing git activity over a specified number of days.

### 1. Setup and Detection

1.  **Detect Git Provider:** Run `git remote get-url origin`. From the URL, determine if the provider is GitHub, GitLab, or another service.
2.  **Extract Repository Name:** Parse the remote URL to extract the repository path (e.g., `group/project` for GitLab, `owner/repo` for GitHub).
3.  **Check for MCPs:** Review the configured MCP servers to identify if any specialized git provider tools (e.g., a GitLab or GitHub MCP) are available.
4.  **Get Remote URL:** Keep the remote URL for constructing clickable links.

### 2. Gather Information

1.  **Calculate Commit Statistics:**
    *   Run `git log --since="N days ago" --oneline | wc -l` to get the total number of commits.
    *   Run `git log --since="N days ago" --shortstat` to gather the total number of files changed and lines added/removed.
2.  **Get Detailed Commit Information:**
    *   Run `git log --since="N days ago" --patch` to get full commit messages, authors, dates, and code diffs for analysis.
3.  **Gather Related Issues/Merge Requests:**
    *   Using the detected provider (and any relevant MCPs), search for all issues or merge requests created, closed, or modified in the repository within the specified date range.
    *   For each item, retrieve its number, title, current status, and web URL.
    *   Parse commit messages to identify issue/MR references (e.g., `#123`, `fixes #456`) and link them to their full URLs.

### 3. Analyze and Draft the Newsletter

1.  **Generate a Narrative Summary:**
    *   **The primary goal is to tell a story based on the code changes.** Analyze commit messages, file paths, and code diffs to understand the key activities.
    *   Weave the changes into a compelling narrative. Group related commits into themes.
    *   Use issue/MR numbers from commit messages for supplementary context. The report structure **must not** be centered around a list of issues. The story comes from the commits.
    *   The tone should be engaging. Check previous reports for style examples if they exist.
2.  **Report on AI Contributions:**
    *   Create a standalone chapter summarizing AI contributions.
    *   **Search commit bodies for AI markers** using `git log --since="..." --grep="Generated/modified by AI" -i --oneline`. Note: AI markers appear in the commit *body*, not the subject line — use `--grep` which searches the full message including body. Do NOT rely on subject-line-only searches.
    *   Using the detected provider (and any relevant MCPs), search for AI markers in issue/MR descriptions and comments.
    *   List a representative sample of AI-marked commits with hyperlinks, and state the total count.
    *   Provide a total count for each category (commits, issues, comments).
3.  **Draft the Markdown:**
    *   **Header Section:** Include the following at the top:
        - Repository name in title format: `# Git Newsletter: <group/project> (YYYY-MM-DD to YYYY-MM-DD)`
        - First lines with metadata:
          - `**Remote**: <git-remote-url>`
          - `**Link**: <web-url-to-repository>`
    *   Create a "Trivia" section with statistics (total commits, date range, primary focus). Split people into two groups: **Contributors** (those who committed code, from `git log`) and **Reporters** (those who filed issues or gave feedback but did not commit code, from issue authors).
    *   Write the narrative summary, embedding clickable links to commits (e.g., `[<short-hash>](<remote-url>/commit/<full-hash>)`).
    *   Add a section for "Related Issues & Merge Requests," listing each item with its hyperlinked number (e.g., `[#123](<issue-url>)` for GitHub, `[#123](<issue-url>)` for GitLab), status, and title.
    *   Ensure all issue/MR references in commit messages are converted to clickable links pointing to their full URLs.
4.  **Add a "What's Next" chapter:**
    *   Based on **open issues** in the repository, identify the most actionable upcoming work.
    *   Group into three sub-sections:
        - **🔧 Bug Fixes in the Pipeline** — open bug issues with a clear fix path
        - **🚀 New Tools & Skills to Expect** — open enhancement/feature issues for new capabilities
        - **🏗️ Architectural Work** — open issues about structural or design changes
    *   For each item, include the issue hyperlink, a one-sentence description, and (if known) the expected fix approach.
    *   Keep the tone forward-looking and informative, not a dry list.

### 4. Finalize Output

1.  **Check for Default Directory:** Check if `docs/git-newsletter/` or `doc/git-newsletter/` exists.
2.  **Handle Output:**
    *   **If the directory exists:** Save the newsletter to `docs/git-newsletter/newsletter-YYYY-MM-DD-to-YYYY-MM-DD.md`.
    *   **If not:** Ask the user: "The default report directory was not found. Do you want to save the report to a file?" If yes, ask for a path. If no, display the content in a new editor window.

### 5. Issue Link Resolution

1.  **Extract Issue References:** Parse all commit messages for issue/MR references using patterns like `#123`, `fixes #456`, `closes #789`.
2.  **Resolve URLs:** For each reference, construct the full URL based on the detected provider:
    - **GitLab**: `<remote-url>/-/issues/<issue-number>`
    - **GitHub**: `<remote-url>/issues/<issue-number>`
3.  **Create Hyperlinks:** Convert all references to markdown links: `[#123](<full-url>)`
4.  **Validate Links:** Ensure all constructed URLs are valid and accessible.

