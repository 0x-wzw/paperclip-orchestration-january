# Tavily MCP — Architecture & Design

_How the Tavily MCP skill fits into the larger FRIDAY Mark-1 inspired system._

## Overview

The Tavily MCP skill extends the agent's capabilities through the Tavily Model Context Protocol, providing:

- **Real-time web search** with AI-generated answers
- **Content extraction** from specific URLs
- **Website mapping** and sitemap generation
- **Site crawling** for bulk content harvesting

## Integration Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    OpenClaw Workspace                        │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    AGENT SYSTEM                       │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │   │
│  │  │   Main      │  │   Sub       │  │   Tavily    │   │   │
│  │  │   Agent     │  │   Agents    │  │   MCP Skill │   │   │
│  │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘   │   │
│  │         │                │                │           │   │
│  │         └────────────────┴────────────────┤           │   │
│  │                                           │           │   │
│  │                                 ┌─────────┴─────────┐ │   │
│  │                                 │   Skill Gateway    │ │   │
│  │                                 │                    │ │   │
│  │  ┌──────────────────────────────┴────────────────────┴─┘ │   │
│  │  │                 SKILLS REGISTRY                         │   │
│  │  │    ┌──────────────┐ ┌──────────────┐                   │   │
│  │  │    │  weather     │ │  github      │  ...              │   │
│  │  │    └──────────────┘ └──────────────┘                   │   │
│  │  └─────────────────────────────────────────────────────┘   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      EXTERNAL SERVICES                        │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────────────┐ │
│  │   Tavily API  │  │    HTTP MCP   │  │    GitHub CLI   │ │
│  │  (Search)     │  │  (Protocol)   │  │     (gh)        │ │
│  │               │  │               │  │                 │ │
│  │  • Search     │  │  • MCP      │  │  • Issues      │ │
│  │  • Extract    │  │    Endpoint  │  │  • PRs         │ │
│  │  • Map        │  │    Interface │  │  • CI Runs     │ │
│  │  • Crawl      │  │               │  │  • Code Review │ │
│  └───────┬───────┘  └───────┬───────┘  └─────────────────┘ │
└──────────┼──────────────────┼──────────────────────────────┘
           │                  │
           ▼                  ▼
┌─────────────────────────────────────────────────────────────┐
│                      WEB SURFACE                             │
│    Wikipedia  │  News Sites  │  Documentation  │  GitHub    │
│               │              │                 │            │
└─────────────────────────────────────────────────────────────┘
```

## Skill Lifecycle

### Setup Phase

```bash
# 1. Verify API key exists
test -f ~/.config/tavily/api.key && echo "✓ API key present" || echo "✗ API key missing"

# 2. Set environment variable
export TAVILY_API_KEY="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"

# 3. Verify MCP endpoint is configured
# Add to openclaw config:
# mcp:
#   endpoints:
#     - name: tavily
#       transport: http
#       url: https://mcp.tavily.com/mcp/?tavilyApiKey=$TAVILY_API_KEY

# 4. Test connectivity
curl -s -X POST https://api.tavily.com/search \
  -H "Authorization: Bearer $TAVILY_API_KEY" \
  -d '{"query": "test", "max_results": 1}'
```

### Execution Phase

```
Request from User
        │
        ▼
┌─────────────────────────┐
│   USER QUERY RECEIVED   │
│   - Parse intent        │
│   - Identify skill      │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   SKILL DISPATCHER      │
│   - Validate parameters │
│   - Check rate limits   │
│   - Format request      │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   TAVILY API ENDPOINT   │
│   - Search/Extract/Map  │
│   - Crawl               │
│   - Rate limiting       │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   RESPONSE PROCESSING   │
│   - Parse JSON          │
│   - Extract relevant    │
│     information         │
│   - Format for display  │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   USER PRESENTATION     │
│   - Display search      │
│     results             │
│   - Pass through        │
│     extracted content   │
│   - Map structure       │
│   - Crawl summary       │
└─────────────────────────┘
```

### Teardown Phase

```bash
# No explicit teardown needed
# API connection closes automatically

# Cache management
# - Store search results for later recall
# - Index extracted content
# - Update knowledge base

# Memory save
# - Log executed queries
# - Track usage metrics
# - Store timestamps
```

## Event System Integration

The Tavily MCP skill integrates with the FRIDAY Mark-1 event-driven architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                   EVENT PUBLISHER                           │
│                                                             │
│   Query Start ──────► tavily:query:start                    │
│   Query End ────────► tavily:query:end                      │
│   Extract Start ────► tavily:extract:start                  │
│   Extract End ──────► tavily:extract:end                    │
│   Map Complete ────► tavily:map:complete                    │
│   Crawl Start ─────► tavily:crawl:start                     │
│   Crawl Complete ──► tavily:crawl:complete                  │
│   Rate Limit ──────► tavily:rate:limit                      │
│   Error ───────────► tavily:error                           │
└──────────────┬──────────────────────────────────────────────┘
               │
     ┌─────────┴─────────┐
     │                   │
     ▼                   ▼
┌───────────┐    ┌──────────────┐
│ Activity  │    │   Memory     │
│   Logger  │    │   System     │
└───────────┘    └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
                 │  Activity    │
                 │    Log       │
                 └──────────────┘
```

## Activity Logging

All Tavily MCP operations are logged in activity:

```json
{
  "timestamp": "2026-03-21T07:30:00Z",
  "session_id": "session-uuid",
  "skill": "tavily-mcp",
  "operation": "search",
  "params": {
    "query": "OpenClaw documentation",
    "max_results": 5,
    "include_answer": true
  },
  "duration_ms": 42,
  "api_calls": 1,
  "status": "success",
  "result_count": 5,
  "rate_limit_remaining": 997
}
```

This adheres to the FRIDAY Mark-1 activity logging pattern:
- Discrete operations with known inputs/outputs
- Lifecycle tracking (start/end timestamps)
- Performance metrics (duration, API calls)
- Rate limit monitoring
- Error capture and reporting

## Type Safety

TypeScript interfaces define the shape of all operations:

```typescript
// Search Options
interface SearchOptions {
  query: string;
  max_results?: number;           // 1-20
  search_depth?: "basic" | "advanced";
  include_answer?: boolean;
  include_raw_content?: boolean;
  include_images?: boolean;
  include_domains?: string[];
  exclude_domains?: string[];
  topic{}