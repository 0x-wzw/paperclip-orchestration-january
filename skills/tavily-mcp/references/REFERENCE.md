# Tavily MCP Referenced Documentation

## Tavily Search API

### Available Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `query` | string | Search query (required) |
| `max_results` | integer | Number of results (default: 10, max: 20) |
| `search_depth` | string | "basic" or "advanced" |
| `include_domains` | array | Filter by domains |
| `exclude_domains` | array | Exclude domains |
| `include_raw_content` | boolean | Include raw HTML content |
| `include_images` | boolean | Include images in results |
| `include_answer` | boolean | Include AI-generated answer |
| `include_thumbnail` | boolean | Include thumbnail URLs |
| `topic` | string | "general", "news", "code", or "web" |

### Python Example

```python
import tavily

tavily_results = tavily.search(
    query="what is openclaw",
    max_results=15,
    search_depth="advanced",
    include_images=True,
    include_raw_content=False
)

for result in tavily_results["results"]:
    print(f"Title: {result['title']}")
    print(f"URL: {result['url']}")
    print(f"Content snippet: {result['content']}")
    print("-" * 50)
```

### Example Tool Calls

```json
{
  "tool": "tavily-search",
  "parameters": {
    "query": "latest AI developments 2026",
    "max_results": 10,
    "search_depth": "advanced",
    "include_images": true,
    "topic": "general"
  }
}
```

## Tavily Extract API

Use for extracting structured data from specific web pages:

```json
{
  "tool": "tavily-extract",
  "parameters": {
    "urls": ["https://example.com/article1", "https://example.com/article2"],
    "extract_depth": "quick" // or "deep"
  }
}
```

Returns extracted text, tables, images, and structured data.

## Tavily Map API

Analyzes a website's structure:

```json
{
  "tool": "tavily-map",
  "parameters": {
    "domains": ["example.com", "github.com"],
    "depth": 2
  }
}
```

Returns sitemap data and page relationships.

## Tavily Crawl API

Systematic website crawling:

```json
{
  "tool": "tavily-crawl",
  "parameters": {
    "domains": ["example.com"],
    "max_depth": 3,
    "include_raw_html": false,
    "include_links": true
  }
}
```

Returns crawled content with metadata.

## Error Handling

Common errors:
- `401 Unauthorized` - Invalid or missing API key
- `429 Rate Limited` - Exceeded API quota
- `400 Bad Request` - Invalid parameters

Response format:
```json
{
  "error": "error_type",
  "message": "Human-readable error message"
}
```

## Rate Limits

- Free tier: ~1000 queries/day
- Pro tiers: Higher limits with longer rates

Check tavily.com/pricing for current limits.

## Best Practices

1. **Use advanced search_depth** for comprehensive results
2. **Filter with domains** when targeting specific sources
3. **Use topic filtering** (news, code, web) for relevance
4. **Cache results** when possible to avoid duplicate queries
5. **Monitor rate limits** and implement backoff strategies
