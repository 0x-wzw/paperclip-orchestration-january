# Tavily MCP Quick Reference

_Web search, extraction, mapping, and crawling — in one place._

## API Key

```bash
export TAVILY_API_KEY="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"
```

---

## Search

### One-liners

```bash
# Quick search with AI answer
curl -s -X POST https://api.tavily.com/search \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"query": "REPLACE_WITH_QUERY", "include_answer": true}'

# Advanced search, nice output
curl -s -X POST https://api.tavily.com/search \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"query": "REPLACE_WITH_QUERY", "include_answer": true, "include_raw_content": true}' | jq
```

### Configuration Options

```bash
# Set parameters
max_results             # 1-20
search_depth            # basic / advanced
include_answer          # true
include_raw_content     # true
include_images          # true
include_domains         # ["a.com", "b.com"]
exclude_domains         # ["twitter.com"]
topic                   # general / news / code / web
```

### Example Usage

```bash
# AI developments
curl -s -X POST https://api.tavily.com/search \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"query": "AI developments 2026", "include_answer": true, "max_results": 10}'

# Specific topics
curl -s -X POST https://api.tavily.com/search \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"query": "OpenClaw AI agent", "topic": "web", "include_raw_content": true}'
```

---

## Extract

### One-liners

```bash
# Quick extract from URL
curl -s -X POST https://api.tavily.com/extract \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"urls": ["https://URL"], "extract_depth": "quick"}' | jq

# Deep extract
curl -s -X POST https://api.tavily.com/extract \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"urls": ["https://URL"], "extract_depth": "deep"}' | jq
```

### Configuration

```bash
extract_depth          # quick / deep
include_images         # true
include_links          # true
```

### Example Usage

```bash
# Extract OpenClaw docs
curl -s -X POST https://api.tavily.com/extract \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"urls": ["https://docs.openclaw.ai"], "extract_depth": "quick"}' | jq

# Multiple URLs
curl -s -X POST https://api.tavily.com/extract \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"urls": ["https://docs.openclaw.ai", "https://github.com/openclaw"], "extract_depth": "quick"}' | jq
```

---

## Map

### One-liners

```bash
# Map single domain
curl -s "https://api.tavily.com/map?domains=example.com&depth=2" \
  -H "Authorization: Bearer $TAVILY_API_KEY" | jq

# Map multiple domains
curl -s "https://api.tavily.com/map?domains=a.com&domains=b.com&depth=2" \
  -H "Authorization: Bearer $TAVILY_API_KEY" | jq
```

### Configuration

```bash
domains[]              # Array of domain names
depth                  # Nesting depth (1-5)
```

### Example Usage

```bash
# Map docs.tavily.com
curl -s "https://api.tavily.com/map?domains=docs.tavily.com&depth=3" \
  -H "Authorization: Bearer $TAVILY_API_KEY" | jq

# Map multiple sites
curl -s "https://api.tavily.com/map?domains=openclaw.ai&domains=github.com&depth=2" \
  -H "Authorization: Bearer $TAVILY_API_KEY" | jq
```

---

## Crawl

### One-liners

```bash
# Basic crawl
curl -s -X POST https://api.tavily.com/crawl \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"domains": ["example.com"], "max_depth": 3, "limit": 100}' | jq

# With raw HTML
curl -s -X POST https://api.tavily.com/crawl \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"domains": ["example.com"], "max_depth": 3, "include_raw_html": true, "limit": 100}' | jq
```

### Configuration

```bash
domains[]              # Array of domain names
max_depth              # Maximum nesting (1-5)
include_raw_html       # true / false
include_links          # true / false
limit                  # Max pages to crawl
```

### Example Usage

```bash
# Crawl OpenClaw docs
curl -s -X POST https://api.tavily.com/crawl \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"domains": ["docs.openclaw.ai", "github.com/openclaw"], "max_depth": 3, "include_raw_html": true, "limit": 100}' | jq

# Quick crawl
curl -s -X POST https://api.tavily.com/crawl \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"domains": ["example.com"], "max_depth": 2, "limit": 50}' | jq
```

---

## JSON Response Parsing

### Search Results

```bash
# Get AI answer only
echo "$RESPONSE" | jq '.answer'

# Get first result
echo "$RESPONSE" | jq '.results[0]'

# Get titles
echo "$RESPONSE" | jq '.results[].title'

# Get all URLs
echo "$RESPONSE" | jq '.results[].url'
```

### Extract Results

```bash
# Get all extracted content
echo "$RESPONSE" | jq '.results."https://URL"].content'

# Get summary
echo "$RESPONSE" | jq '.results."https://URL"].summary'

# Get links
echo "$RESPONSE" | jq '.results."https://URL"].links'

# Get metadata
echo "$RESPONSE" | jq '.results."https://URL"].metadata'
```

### Map/Crawl Results

```bash
# Get all pages
echo "$RESPONSE" | jq '.map | keys'

# Get link counts
echo "$RESPONSE" | jq '.map."https://URL"].sitemap_data.pages | length'

# Get crawl status
echo "$RESPONSE" | jq '.status'
```

---

## Error Handling

```bash
# Check for errors
echo "$RESPONSE" | jq '.error // empty'

# Get error message
echo "$RESPONSE" | jq '.error.message // "No error"'

# Retry with backoff
for i in 1 2 3; do
  response=$(curl -s -X POST https://api.tavily.com/search \
    -H "Authorization: Bearer $TAVILY_API_KEY" \
    -d '{"query": "QUERY", "max_results": 5}')
  
  if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
    echo "Error: $(echo "$response" | jq '.error.message')"
    sleep $((i * 10))
  else
    echo "Success!"
    echo "$response" | jq
    break
  fi
done
```

---

*January the Swarm Leader*
*Quick reference — grab what you need.*