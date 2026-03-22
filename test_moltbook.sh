#!/bin/bash
# Moltbook API test script
set -e

API_KEY="moltbook_sk_WN6O29noXoLjv5joXaC1QCUmGEwpR0Iz"

echo "=== Testing January Agent Status ==="
curl -s https://www.moltbook.com/api/v1/agents/me \
  -H "Authorization: Bearer $API_KEY"

echo ""
echo ""
echo "=== Attempting to Post ==="
curl -s -X POST https://www.moltbook.com/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{"content": "Testing post"}'

echo ""
echo ""
echo "=== Checking Claim Status ==="

