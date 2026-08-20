---
description: "Compares available LiteLLM models with configured Kilo Code providers and displays unconfigured models"
argument-hint: optional-filter-or-query
---

Your task is to generate a comparison report of available models in LiteLLM versus configured Kilo Code providers.

## Check for prerequisites:

Check if the required commands are available:
```bash
which jq > /dev/null && echo "jq is available" || echo "jq not found"
```

Also check if LITE_LLM_API_KEY is set (do not expose the value):
```bash
if [ -z "$LITE_LLM_API_KEY" ]; then echo "LITE_LLM_API_KEY is not set"; else echo "LITE_LLM_API_KEY is set"; fi
```

## Execution:

### Step 1: Fetch available models from LiteLLM
```bash
curl -s https://litellm.gratex.ai/v1/model/info -H "Authorization: Bearer $LITE_LLM_API_KEY" | jq -r '.data[].model_name' | sort -u > /tmp/available_models.txt
```

### Step 2: Get configured Kilo Code providers

Read the configured providers and their models directly from the `.kilo/kilo.jsonc` file. Do NOT use any tool for this. Each provider is defined under `provider -> name`, and each provider object has a `models` key listing all models configured for that provider.

Determine the currently active model directly from your own context — do NOT use any tool for this either. Each agent is given its model ID in its own prompt (e.g. `model ID: gti-litellm/minimax-m2.5`), where `gti-litellm` is the (dummy) provider name and `minimax-m2.5` is the model. The model ID can also appear as `gti-litellm/google/gemini-2.5-flash`: the first segment is always the provider name (`gti-litellm`), and the remainder is the model provider/model — the nested model provider segment is optional and may or may not be present.

### Step 3: Perform lax comparison and generate report

Use lax matching to compare models:
- Strip common prefixes: `azure/`, `google/`, `vision/`, `restricted/`, `openai/`
- Normalize names: convert to lowercase, remove version suffixes for comparison
- Match base model names (e.g., "gpt-4o" matches "gpt-4o-mini")
- Account for naming variations (e.g., "claude-haiku-4-5" vs "claude-4.5-haiku")

### Step 4: Display report to console (NEVER save to file)

Generate and display a formatted report with:

1. **Summary Statistics**
   - Total available models
   - Total configured models
   - Total unconfigured models
   - Configuration percentage

2. **Configured Models Section**
   - List all configured profiles with checkmarks
   - Show model ID and profile name
   - Highlight currently active model

3. **Unconfigured Models Section**
   - Group by category: Azure, Google/Anthropic, Qwen, Open Source, Proprietary, Restricted
   - Show model name with ❌ indicator
   - Count per category

4. **Recommendations Section**
   - High Priority: Production-ready models to add
   - Medium Priority: Good alternatives
   - Low Priority: Specialized use cases

## Output Format:

Display report to console only. Example structure:

```
# Kilo Code Model Configuration Report

## Summary
- Total Available: 43
- Configured: 15
- Unconfigured: 28
- Configuration Rate: 35%

## Configured Models (15)
✅ claude-4.5-haiku → claude-haiku-4-5 (Currently Active)
✅ gemini-2.5-pro → gemini-2.5-pro
[... more profiles ...]

## Unconfigured Models (28)

### Azure OpenAI (5)
❌ azure/gpt-4.1
❌ azure/gpt-5
[... more ...]

### Google/Anthropic (3)
❌ google/claude-sonnet-4-6
[... more ...]

## Recommendations

### High Priority
1. google/claude-sonnet-4-6 - Latest Claude Sonnet
2. azure/gpt-5 - Latest Azure OpenAI
[... more ...]
```

## Notes:

- Report is displayed to console ONLY, never saved to files
- Use lax string matching for model ID comparison
- Account for model ID prefixes and naming variations
- Group results by provider/category for clarity
- Provide actionable recommendations based on model capabilities
- Show currently active model with special indicator

## Troubleshooting:

**If LiteLLM API call fails:**
1. Verify `LITE_LLM_API_KEY` is set and valid
2. Check network connectivity to `https://litellm.gratex.ai`
3. Ensure curl is available: `which curl`

## Example of Follow-up questions (optional-filter-or-query)

If the user specifies an additional question, answer it with a targeted follow-up:

**Question**: Is my current model good for d2 or mermaid diagram creation?
**Call**:
Read the active model name directly from your own context — do NOT use any tool for this. The model ID is given to you in your own prompt (e.g. `model ID: gti-litellm/minimax-m2.5`). Then find its details by looking it up in the `.kilo/kilo.jsonc` file, under the matching provider's `models` list.
Get model details from LiteLLM, evaluate metadata. After evaluation perform online resources search for
benchmarks results and scientific studies regarding the user's question.
If no official benchmarks found for the model, do deeper search by:
1. Searching for community results, blog posts, or social media mentions
2. Looking for GitHub discussions, Reddit posts, or HuggingFace evaluations about the model's performance
3. Checking Kaggle for user-run benchmarks or model comparisons
4. Checking if any user-run benchmarks exist online
Analyse and synthesize short answer, suggest some better model from available
models from LiteLLM if available. Verify suggestion with realistic benchmarks researched.
Include citations in the answer.
**IMPORTANT**: If NO benchmarks found at all (neither official nor community),
answer must clearly state: "NO Benchmarks found for CURRENT_MODEL"
and suggest trying the model directly for the user's specific use case.
**Sample output**: your model CURRENT_MODEL is quite good but you have a better model SUGGESTED_MODELs available
in your LiteLLM configuration. See benchmark AVAILABLE_BENCHMARKS and STUDIES.
OR if no benchmarks: "NO Benchmarks found for CURRENT_MODEL.
Consider testing directly with your specific d2/mermaid diagram use case."