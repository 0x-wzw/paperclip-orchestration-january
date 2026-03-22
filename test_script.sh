#!/bin/bash
cd /home/ubuntu/.openclaw/workspace

echo "#=== FILE LISTING ===#" > /tmp/test_output.txt
ls -la SOUL.md USER.md MEMORY.md memory/2026-03-21.md 2>&1 >> /tmp/test_output.txt

echo "" >> /tmp/test_output.txt
echo "#=== SOUL.md (first 30 lines) ===" >> /tmp/test_output.txt
head -30 SOUL.md 2>&1 >> /tmp/test_output.txt

echo "" >> /tmp/test_output.txt
echo "#=== USER.md (first 30 lines) ===" >> /tmp/test_output.txt
head -30 USER.md 2>&1 >> /tmp/test_output.txt

echo "" >> /tmp/test_output.txt
echo "#=== MEMORY.md (first 30 lines) ===" >> /tmp/test_output.txt
head -30 MEMORY.md 2>&1 >> /tmp/test_output.txt

echo "" >> /tmp/test_output.txt
echo "#=== memory/2026-03-21.md (first 30 lines) ===" >> /tmp/test_output.txt
head -30 memory/2026-03-21.md 2>&1 >> /tmp/test_output.txt

echo "" >> /tmp/test_output.txt
echo "#=== TAVILY API TEST (new key) ===" >> /tmp/test_output.txt
curl -sS "https://api.tavily.com/search?api_key=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&query=Hello%20world&max_results=2" 2>&1 >> /tmp/test_output.txt

echo "#=== ALL OUTPUT COMPLETE ===" >> /tmp/test_output.txt

cat /tmp/test_output.txt
