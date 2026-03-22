# Tavily API Reference

_Complete documentation for Tavily API endpoints used by the MCP skill._

## Authentication

All requests require an API key in the Authorization header:

```bash
Authorization: Bearer $TAVILY_API_KEY
```

API keys get from: https://tavily.com/

---

## Search API

**Endpoint:** `POST https://api.tavily.com/search`

Search the live web for current information. This endpoint provides AI-generated answers based on the search results.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `query` | string | Yes | - | Search query |
| `max_results` | integer | No | 10 | Number of results (max 20) |
| `search_depth` | enum | No | basic | Search depth: `basic` or `advanced` |
| `include_answer` | boolean | No | false | Include AI-generated answer |
| `include_raw_content` | boolean | No | false | Include raw HTML content from snippets |
| `include_images` | boolean | No | false | Include image URLs |
| `include_domains` | array | No | - | Filter search to these domains |
| `exclude_domains` | array | No | - | Exclude these domains from search |
| `topic` | enum | No | general | Filter topic: `general`, `news`, `code`, `web` |
| `time_range` | enum | No | - | Filter by time: `day`, `week`, `month`, `year` |

### Request Example

```bash
curl -X POST https://api.tavily.com/search \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{
    "query": "latest developments in artificial intelligence",
    "max_results": 10,
    "search_depth": "advanced",
    "include_answer": true,
    "include_raw_content": true,
    "include_images": true,
    "topic": "general"
  }'
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `answer` | string | AI-generated summary of the search |
| `results` | array | List of search results |
| `results[].title` | string | Page title |
| `results[].url` | string | Page URL |
| `results[].content` | string | Snippet text |
| `results[].score` | float | Relevance score |
| `results[].score_reason` | string | Explanation of relevance score |
| `results[].image_url` | string | URL of featured image (if available) |
| `images` | array | List of image URLs found |
| `topics` | array | Related topics to explore |
| `time_range` | string | How recent the results are |
| `raw_response` | object | Raw API response (if `include_raw_content: true`) |

### Example Response

```json
{
  "answer": "Artificial intelligence has seen significant developments in 2026...",
  "results": [
    {
      "title": "Breaking AI News: Latest Developments",
      "url": "https://example.com/article1",
      "content": "This is a snippet from the article...",
      "score": 0.95,
      "score_reason": "High relevance to query"
    }
  ],
  "images": [
    "https://example.com/image1.jpg"
  ],
  "topics": [
    "machine learning",
    "neural networks",
    "generative AI"
  ],
  "time_range": "Submitted 2 hours ago"
}
```

---

## Extract API

**Endpoint:** `POST https://api.tavily.com/extract`

Pull structured data from specific URLs.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `urls` | array | Yes | - | URLs to extract content from |
| `extract_depth` | enum | No | quick | Extraction depth: `quick` or `deep` |

### Request Example

```bash
curl -X POST https://api.tavily.com/extract \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{
    "urls": [
      "https://docs.openclaw.ai",
      "https://github.com/openclaw/openclaw"
    ],
    "extract_depth": "quick"
  }'
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `urls` | array | Original URLs requested |
| `results` | object | Extracted content by URL |
| `results.[url].title` | string | Page title |
| `results.[url].description` | string | Meta description |
| `results.[url].summary` | string | AI-generated summary |
| `results.[url].content` | string | Extracted text content |
| `results.[url].images` | array | Image URLs found on page |
| `results.[url].links` | array | URLs of links found on page |
| `results.[url].tables` | array | Tables found on page |
| `results.[url].images_data` | object | Base64-encoded images |
| `results.[url].metadata` | object | Page metadata |
| `results.[url].metadata.language` | string | Page language |
| `results.[url].metadata.author` | string | Page author |
| `results.[url].metadata.published` | string | Publication date |
| `results.[url].metadata.og_image` | string | Open Graph image URL |

### Example Response

```json
{
  "urls": [
    "https://docs.openclaw.ai"
  ],
  "results": {
    "https://docs.openclaw.ai": {
      "title": "OpenClaw Documentation",
      "description": "Learn how to deploy AI agents on OpenClaw",
      "summary": "OpenClaw is an AI agent runtime for connecting AI agents...",
      "content": "Full extracted text content...",
      "images": ["https://docs.openclaw.ai/img/logo.png"],
      "links": ["https://docs.openclaw.ai/quickstart"],
      "tables": [
        {
          "headers": ["Feature", "Level"],
          "rows": [["Stability", "Beta"], ["Performance", "High"]]
        }
      ],
      "metadata": {
        "language": "en",
        "author": "OpenClaw Team",
        "published": "2026-03-20"
      }
    }
  }
}
```

---

## Map API

**Endpoint:** `GET https://api.tavily.com/map`

Create a sitemap of website structure.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `domains` | array | Yes | - | Domain(s) to map |
| `depth` | integer | No | 2 | Number of nesting levels to crawl |
| `limit` | integer | No | 100 | Maximum pages to index |

### Request Example

```bash
curl -X GET "https://api.tavily.com/map?domains=openclaw.ai&depth=3" \
  -H "Authorization: Bearer $TAVILY_API_KEY"
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `domains` | array | Domain(s) mapped |
| `map` | object | Map data by URL |
| `map.[url].url` | string | Full URL |
| `map.[url].title` | string | Page title |
| `map.[url].links` | array | Links on page |
| `map.[url].depth` | integer | Nesting depth |
| `map.[url].type` | string | Link type: `internal` or `external` |
| `map.[url].sitemap_data` | object | Structured sitemap data |
| `map.[url].sitemap_data.pages` | array | List of page URLs |
| `map.[url].sitemap_data.indexed` | integer | Number of pages indexed |

### Example Response

```json
{
  "domains": ["openclaw.ai"],
  "map": {
    "https://openclaw.ai": {
      "url": "https://openclaw.ai",
      "title": "OpenClaw - AI Agent Runtime",
      "links": [
        {
          "url": "https://openclaw.ai/docs",
          "title": "Documentation",
          "depth": 1,
          "type": "internal"
        }
      ],
      "sitemap_data": {
        "pages": [
          "https://openclaw.ai/docs",
          "https://openclaw.ai/docs/quickstart",
          "https://openclaw.ai/docs/api"
        ],
        "indexed": 42
      }
    }
  }
}
```

---

## Crawl API

**Endpoint:** `POST https://api.tavily.com/crawl`

Systematic crawling of websites for content harvesting.

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `domains` | array | Yes | - | Domain(s) to crawl |
| `max_depth` | integer | No | 2 | Maximum nesting depth |
| `limit` | integer | No | 100 | Maximum pages to crawl |
| `include_raw_html` | boolean | No | false | Include raw HTML in results |
| `include_links` | boolean | No | true | Include links in results |
| `skip_titles` | boolean | No | false | Skip title extraction |
| `skip_descriptions` | boolean | No | false | Skip description extraction |
| `exclude_patterns` | array | No | - | URL patterns to exclude |
| `follow_redirects` | boolean | No | true | Follow HTTP redirects |

### Request Example

```bash
curl -X POST https://api.tavily.com/crawl \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{
    "domains": ["docs.openclaw.ai"],
    "max_depth": 3,
    "limit": 50,
    "include_raw_html": true,
    "include_links": true
  }'
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `domains` | array | Domain(s) crawled |
| `crawl_id` | string | Unique crawl identifier |
| `status` | enum | Crawl status |
| `results` | object | Crawled content by URL |
| `results.[url].title` | string | Page title |
| `results.[url].url` | string | Full URL |
| `results.[url].content` | string | Extracted content |
| `results.[url].raw_html` | string | Raw HTML (if `include_raw_html: true`) |
| `results.[url].links` | array | Links found on page |
| `results.[url].scraped_at` | string | Scraper timestamp |
| `metadata` | object | Crawl statistics |
| `metadata.total_pages` | integer | Total pages found |
| `metadata.pages_crawled` | integer | Pages successfully crawled |
| `metadata.scrape_time_ms` | integer | Total scrape time in milliseconds |
| `metadata.errors` | array | List of errors encountered |

### Example Response

```json
{
  "domains": ["docs.openclaw.ai"],
  "crawl_id": "crawl-uuid-123",
  "status": "completed",
  "results": {
    "https://docs.openclaw.ai/quickstart": {
      "title": "Quickstart",
      "url": "https://docs.openclaw.ai/quickstart",
      "content": "Content from quickstart page...",
      "raw_html": "<html>...</html>",
      "links": ["https://docs.openclaw.ai/docs/getting-started"],
      "scraped_at": "2026-03-21T07:30:00Z"
    }
  },
  "metadata": {
    "total_pages": 47,
    "pages_crawled": 47,
    "scrape_time_ms": 1234,
    "errors": []
  }
}
```

---

## Rate Limits

### Free Tier

| Endpoint | Rate Limit | Window |
|----------|------------|--------|
| Search | ~1,000 queries/day | 24 hours |
| Extract | ~1,000 queries/day | 24 hours |
| Map | ~500 requests/day | 24 hours |
| Crawl | ~500 requests/day | 24 hours |

### Pro Tier

Higher limits available. Check https://tavily.com/pricing for current limits.

### Rate Limit Response

```json
{
  "error": {
    "code": "rate_limit_exceeded",
    "message": "Rate limit exceeded. Please try again later.",
    "retry_after": 3600
  }
}
```

---

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `401` | Unauthorized | Invalid or missing API key |
| `400` | Bad Request | Invalid parameters |
| `403` | Forbidden | Insufficient permissions |
| `429` | Too Many Requests | Rate limit exceeded |
| `500` | Internal Server Error | Tavily API issue |
| `503` | Service Unavailable | Tavily service down |

---

## Best Practices

1. **Use appropriate search_depth** — `basic` for quick results, `advanced` for comprehensive research
2. **Filter with domains** — Use `include_domains` and `exclude_domains` for precision
3. **Use topic filtering** — Set `topic` to `news`, `code`, or `web` for relevance
4. **Cache results** — Store search results locally to avoid duplicate queries
5. **Monitor rate limits** — Check remaining quota before making requests
6. **Handle errors gracefully** — Implement retry logic with exponential backoff
7. **Use extract for single URLs** — More efficient than crawling one page at a time

---

*January the Swarm Leader*
*Understanding the tool beneath the surface.*