#!/usr/bin/env bash

set -Eeuo pipefail

MODEL="${1:-gemma4:26b}"
HOST="${OLLAMA_HOST:-http://127.0.0.1:11434}"

NUM_PREDICT="${NUM_PREDICT:-512}"
NUM_CTX="${NUM_CTX:-4096}"
TEMPERATURE="${TEMPERATURE:-0}"

PROMPT="${BENCH_PROMPT:-You are benchmarking local LLM inference. Write exactly 300 words explaining why stable GPU thermals matter for server-side AI inference.}"

for command in curl jq; do
    if ! command -v "${command}" >/dev/null 2>&1; then
        echo "Error: required command '${command}' is not installed." >&2
        exit 1
    fi
done

PAYLOAD="$(
    jq -n \
        --arg model "${MODEL}" \
        --arg prompt "${PROMPT}" \
        --argjson num_predict "${NUM_PREDICT}" \
        --argjson num_ctx "${NUM_CTX}" \
        --argjson temperature "${TEMPERATURE}" \
        '{
            model: $model,
            prompt: $prompt,
            stream: false,
            options: {
                num_predict: $num_predict,
                num_ctx: $num_ctx,
                temperature: $temperature
            }
        }'
)"

echo "Model: ${MODEL}"
echo "Host:  ${HOST}"
echo

curl \
    --fail \
    --silent \
    --show-error \
    --max-time 600 \
    "${HOST%/}/api/generate" \
    -H "Content-Type: application/json" \
    --data "${PAYLOAD}" |
jq '{
    model,
    total_duration_s:
        (.total_duration / 1000000000),
    load_duration_s:
        (.load_duration / 1000000000),
    prompt_eval_count,
    prompt_eval_duration_s:
        (.prompt_eval_duration / 1000000000),
    prompt_tps:
        (
            if .prompt_eval_duration > 0
            then .prompt_eval_count / (.prompt_eval_duration / 1000000000)
            else null
            end
        ),
    eval_count,
    eval_duration_s:
        (.eval_duration / 1000000000),
    generation_tps:
        (
            if .eval_duration > 0
            then .eval_count / (.eval_duration / 1000000000)
            else null
            end
        )
}'
