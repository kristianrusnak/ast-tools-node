---
description: Makes statistics from current AI conversation/task
---

Analyse the current LLM conversation and produce statistics STRICTLY as specified below.
Count every item precisely. Output zeros explicitly — never omit a category.
Do not interpret or editorialize — numbers only, then evals at the end.

## Sliding Window Truncation Detection

Before producing statistics, scan the visible conversation for `[Sliding window truncation: N messages hidden]` markers. Count them and report:

- **Truncation events:** count of all truncation markers found
- **Maximum messages hidden in single event:** highest N value from any marker
- **⚠️ Warning:** If truncation events are found, tool call counts (especially MCP calls) may be underreported due to truncation. Early-session tool usage is not visible to the agent.

If truncation events are found, add a **Truncation Warning** subsection to each affected statistics section:
> *Reliability: ⚠️ partial (truncated)*

# Statistics

- **Original prompt** — exact text of the first human message
- **Mode and Model** — mode slug + model name; list ALL if changed during execution
- **Mode switches** — count and list each switch (from → to, with timestamp if available)
- **Number of interactions** — total count of ALL LLM turns: human messages + agent/model responses combined (complete LLM call count). Exclude the `/prompt-summary` invocation turn itself — count only turns that belong to the actual task.
- **Number of Tool calls** — count by tool name (include tools with 0 calls)
- **Number of MCP calls** — count by MCP tool name (include tools with 0 calls)
  - If truncation events are found, mark each MCP tool with: *Reliability: ⚠️ partial (truncated)*
- **Number of subtasks launched** — `new_task` calls
- **Task list (todo) statistics**
  - **Prompt word count** — word count of the original prompt (proxy for initial ambiguity: fewer words = higher unknownness)
  - **Scope expansion ratio** — `final steps / max(initial steps, 1)`; 1.0 = perfectly scoped from start; >5 = task largely unknown at start
  - **Discovery rate** — `steps added mid-task / total interactions`; high = AI was exploring; low = AI knew the path upfront
  - **Clarity index** — `1 - (attempt_completion_count - 1) / total_interactions`; 1.0 = completed on first attempt; lower = more restarts needed
  - Initial number of steps planned
  - Final number of steps (at end of conversation)
  - Peak number of steps (maximum at any point)
  - Number of steps added mid-task
  - Number of steps completed
  - Number of steps still pending/in-progress at end
- **Number of Human Interventions** — total negative deny actions; breakdown by reason
  - `prompt-*` slash commands (e.g. `/prompt-summary`) are never counted as denials — they are repo meta-tooling.
  - Also report: **denial ratio** = denied / total tool calls (as percentage)
- **Number of swear words used by human** — exact count
- **Divergent topics** — list each topic introduced that is NOT related to the original task.
  `prompt-*` slash commands (e.g. `/prompt-summary`) are never divergent — they are repo meta-tooling.
- **Time** — start timestamp, end timestamp, total duration
  - **Start** = timestamp of the first human message
  - **End** = timestamp of the last human message BEFORE the `/prompt-summary` request (i.e. when the task actually ended, not when the summary was requested — the summary may be run hours later)
  - **Duration** = end − start
- **AI eval** — based on denial RATIO (not raw count), to fairly score long sessions
  - 🟢 GREEN: task completed, denial ratio ≤5%, no swear words, ≤1 divergent topic
  - 🟡 YELLOW: task completed with guidance; denial ratio 6–25% OR 2–4 divergent topics
  - 🔴 RED: denial ratio >25%, OR task not completed, OR swear words + ratio >10%
- **User eval**
  - 🟢 GREEN: 0–1 divergent topics, task list grew ≤20% from initial plan
  - 🟡 YELLOW: 2 divergent topics OR task list grew 20–100% from initial plan
  - 🔴 RED: 3+ divergent topics OR task list more than doubled from initial plan

- **Technical Statistics**
  - **Input tokens** — total input token count (from LLM API response)
  - **Output tokens** — total output token count (from LLM API response)
  - **Total tokens** — sum of input + output tokens
  - **Estimated cost** — calculated based on model pricing (input + output)
  - **Model name** — exact model identifier used
  - **Truncation events detected** — count of `[Sliding window truncation: N messages hidden]` markers found

# Output Format

Produce a single Markdown document suitable for display or saving.
All statistics must be in tables or bullet lists with explicit numbers.

At the end of the report, after the evals, add an **Interpretation** section with:
- A 3–5 sentence plain-language summary of what the numbers mean together
- Highlight the most interesting or surprising metric
- Note what the scope expansion ratio + clarity index say about task complexity vs execution quality

Evals with emoji + one-line reason, then Interpretation, then AI marking.

If truncation events were detected, add a **Sliding Window Truncation** section after the Statistics section:

```markdown
## Sliding Window Truncation
- **Truncation events:** N
- **Maximum messages hidden in single event:** max_N
- **⚠️ Warning:** Tool call counts (especially MCP calls) may be underreported due to truncation.
  Early-session tool usage is not visible to the agent.
```

Add AI marking at the bottom:
> *Generated/modified by AI RooCode {version}, used model {model}*
