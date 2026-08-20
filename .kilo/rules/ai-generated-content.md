# Rules for AI-Generated and Modified Content: AI Marking and Labeling

To ensure transparency, as outlined in the EU AI Act (Article 50),
you **MUST** include a **Label** (human-visible text) and a **Marking** (comment or metadata)
in every file generated or modified by an AI coding assistant.

"Generated/modified by AI Kilo Code {ai_assistant_version}, used model {model_name}"

Replace `{ai_assistant_version}` and `{model_name}` with the actual values.

```bash
 code --list-extensions --show-versions | grep -F "kilocode.kilo-code" | cut -d"@" -f2
```

This text shall be appropriately formatted based on the file type. This rule also applies to any commit messages, issues, comments, or other content sent to Git repositories (GitHub/GitLab), issue trackers, and other integrations.

---

## Rule: File Modifications

Every file created or modified by an AI coding assistant must indicate this.

-   **Marking:** This mention **must** be a comment within the file. If the file format supports metadata (e.g., PDF, DOCX, image files), the marking shall be included there as well.
-   **Label:** If the file is human-readable (e.g., Markdown, Word documents, PDFs), the mention **must** also be included as visible text in the file's content.

## Rule: Contributing to Existing Files

When modifying an existing file, study its style, format, and sentiment, then add the Label in a way that matches the established document style.

Place the Label and Marking at the most granular level possible (e.g., inside a modified function or within a specific chapter). If a marker/label already exists, update it with the current version information.

## Metadata

When generating images, use `exiftool` to insert the Marking into the file's EXIF metadata. For Markdown, use a YAML front matter block for the Marking when possible; otherwise, include it as a comment and the Label as visible text.

## Git Issues and Comments

For any content posted to issue trackers or as comments in Git, use the appropriate marking based on the AI tool you are using:
