---
description: "Provides information about models available in our LiteLLM with OnPremise vs Cloud classification"
argument-hint: user-query
---

Your task is to provide answers for user-query, based on available model metadata received from standard openapi endpoint, enhanced with OnPremise/Cloud classification.

## Check for prerequisites:
Check if LITE_LLM_API_KEY is exported in env, for example by running `if [ -z "$LITE_LLM_API_KEY" ]; then echo "LITE_LLM_API_KEY is not set"; else echo "LITE_LLM_API_KEY is set"; fi`. Also check if the user has the `jq` command available. When checking for prerequisites, do not expose (print) the value of sensitive information (LITE_LLM_API_KEY).

## How to classify OnPremise (local) vs Cloud (remote) models:

**ONPREMISE MODEL INDICATORS:**
- `"db_model": true` - Model is in the local database
- `"direct_access": true` - Can be accessed directly without proxy
- Local network API bases: `http://172.x.x.x:*`, `http://192.168.x.x:*`, `http://localhost:*`, or `null`
- Local providers: `llamafile`, `hosted_vllm` (when self-hosted), `ollama` (when local), `openai` with local API base

**CLOUD MODEL INDICATORS:**
- `"db_model": false` - Not in local database (must proxy through LiteLLM)
- Cloud providers: `azure`, `vertex_ai-language-models`, `vertex_ai-anthropic_models`, `gemini`
- Cloud API bases: `https://*.azure.com/`, `https://*.googleapis.com/`, etc.

## Enhanced Query with Provider Type Classification:

To get model information with OnPremise/Cloud classification, execute:

```bash
curl -s https://litellm.gratex.ai/v1/model/info -H "Authorization: Bearer $LITE_LLM_API_KEY" | jq -r '.data[] | {model_name: .model_name, db_model: .model_info.db_model, direct_access: .model_info.direct_access, litellm_provider: .model_info.litellm_provider, api_base: .litellm_params.api_base, supports_vision: .model_info.supports_vision, supports_pdf_input: .model_info.supports_pdf_input, _gti_provider_type: (if .model_info.db_model == true and (.model_info.direct_access == true or (.litellm_params.api_base | type == "string" and ((. | startswith("http://172.")) or (. | startswith("http://192.168.")) or (. | contains("localhost")))) or .litellm_params.api_base == null) then "OnPremise" else "Cloud" end)}'
```

## Sample Output Table Format:

When processed, the output shows models classified as:

| Model Name | _gti_provider_type | Vision Support | PDF Support | Notes |
|------------|--------------------|----------------|-------------|-------|
| azure/gpt-4.1 | Cloud | true | null | Azure OpenAI Service |
| qwen3.6-27b | OnPremise | true | null | Local Llamafile server |
| azure/gpt-4o-mini | OnPremise* | true | null | Azure model with local endpoint* |
| nemotron-3-super-120b-a12b | OnPremise | false | null | Local vLLM server |
| @agent/Llama-3.1-8B-Instruct | OnPremise | null | null | Local GGUF model |
| vision/Qwen3-32b-VL | OnPremise | true | null | Local vision model |
| google/gemini-2.5-pro | OnPremise* | true | true | Vertex AI model* |
| azure/gpt-5.1 | OnPremise* | true | true | Azure model with local endpoint* |

*Note: Some models show as "OnPremise" due to having `db_model: true` and `direct_access: true` even when using cloud provider APIs, indicating they're accessible via local endpoints in this specific deployment.

