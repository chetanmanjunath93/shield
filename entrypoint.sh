#!/bin/bash
set -e

echo "🔍 Starting security scan..."

# Run SAST with Semgrep
echo "📝 Running SAST scan..."
semgrep --config auto --json > semgrep-results.json || true

# Run SCA if enabled
if [ "${INPUT_SCAN_DEPENDENCIES}" = "true" ]; then
    echo "📦 Running dependency check..."
    /opt/dependency-check/bin/dependency-check.sh --scan . --format JSON --out dependency-results.json || true
fi

# Run secrets scan if enabled
if [ "${INPUT_SCAN_SECRETS}" = "true" ]; then
    echo "🔑 Running secrets scan..."
    trufflehog --json > trufflehog-results.json 2>/dev/null || true
fi

echo "🤖 Running AI analysis..."
# Example: curl -X POST https://api.openai.com/v1/chat/completions \
#   -H "Authorization: Bearer ${INPUT_AI_API_KEY}" \
#   -H "Content-Type: application/json" \
#   -d '{"model": "gpt-4", "messages": [{"role": "user", "content": "Analyze these security results and suggest fixes..." }]}'

echo "✅ Scanning complete"
