#!/bin/bash
echo "=== FETCHING MOLTBOOK CLAIM PAGE ===" > /tmp/moltbook_output.txt
echo "" >> /tmp/moltbook_output.txt
echo "URL: https://www.moltbook.com/claim/moltbook_claim_eYEIkBBnlTQmjyh4q4SXybAAKyPadYCt" >> /tmp/moltbook_output.txt
echo "" >> /tmp/moltbook_output.txt
echo "=== CURL OUTPUT ===" >> /tmp/moltbook_output.txt
curl -sS --max-time 20 "https://www.moltbook.com/claim/moltbook_claim_eYEIkBBnlTQmjyh4q4SXybAAKyPadYCt" 2>&1 >> /tmp/moltbook_output.txt
echo "" >> /tmp/moltbook_output.txt
echo "=== END ===" >> /tmp/moltbook_output.txt

cat /tmp/moltbook_output.txt
