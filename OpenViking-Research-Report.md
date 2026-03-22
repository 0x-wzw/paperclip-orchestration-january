# OpenViking Comprehensive Research Report

**Research Date:** March 21, 2026  
**Source:** volcengine/OpenViking, viking.dev, volcengine-openviking.mintlify.app  
**Purpose:** Document findings for January's dimensional adaptation of OpenViking

---

## 1. Executive Summary

OpenViking is a filesystem-based AI agent context management system by Volcengine implementing the **brain filesystem paradigm** - a Unix-style filesystem where concepts are files accessed via `viking://` URIs. Features include: L0/L1/L2 tiered context loading, recursive directory retrieval (5-step process), automatic session compression, visualized retrieval trajectories, and multi-provider AI integration (Anthropic, OpenAI). System architecture follows 7 OSI layers with Integration Points for OpenClaw, LangChain, and DeerFlow.

---

## 2. Core Architecture and Design Philosophy

### 2.1 Brain Filesystem Paradigm
- **URI Scheme**: `viking://` suffix for hierarchical addressing
- **Structure**: Scope → Resources → User → Agent → Session → Queue → Temp
- **Recursive Retrieval**: Directory traversal with intent-based ML analysis
- **Persistent Storage**: Filesystem-based with versioning and compression

### 2.2 Design Principles
- Unix-style: Atomic, composable, persistent file abstraction
- Scope-based isolation: Isolated yet interconnected through URI hierarchy
- Dimensional thinking: Multi-dimensional context retrieval and visualization
- OSI 7-layers: Filesystem + Representation + Retrieval + Communication + Interaction + Integration + Application

### 2.3 Architecture Layers
```
Application Layer (LangChain, DeerFlow, OpenClaw)
├── Integration Layer (API bindings, SDKs)
├── Interaction Layer (CLI tools, web UI)
├── Communication Layer (viking:// protocol, REST APIs)
├── Retrieval Layer (L0/L1/L2 tiered loading, vector search)
├── Representation Layer (embeddings, VLMs)
└── Filesystem Layer (brain filesystem paradigm)
```

---

## 3. Key Capabilities

### 3.1 Context Management
- **Tiered Context Loading (L0/L1/L2)**:
  - L0: Fast, lightweight (~1000 tokens), quick impressions
  - L1: Medium-depth (~5000 tokens), detailed understanding
  - L2: Deep, comprehensive (~20000 tokens), thorough analysis

- **Directory Recursive Retrieval**: 5-step recursive filesystem traversal with intent analysis

### 3.2 Session Management
- Automatic session compression for memory optimization
- Lifecycle commands: commit, stop, archive, resume, status
- Queue management: temp files, resource queues, agent tasks

### 3.3 Visualized Retrieval Trajectories
- Trace/Path visualization with step-by-step details
- Observer service for debugging
- Tools: ls, find, grep for filesystem exploration

### 3.4 Model Provider Integration
- Official: Anthropic, OpenAI
- Embedding models for contextual retrieval
- VLM support for document/image analysis
- Custom provider configuration via YAML

### 3.5 Integration Points
- LangChain ecosystem
- DeerFlow AI platform
- OpenClaw agent runtime
- Custom REST APIs

---

## 4. CLI Tools (nov cli)

### Core Commands

| Command | Description |
|---------|-------------|
| `nov add-resources` | Add resources to context database |
| `nov find` | Search resources by pattern/intent |
| `nov observer` | Observe/debug retrieval processes |
| `nov ls` | List filesystem contents |
| `nov grep` | Search content within resources |
| `nov trace`/`nov path` | Visualize retrieval trajectories |
| `nov commit` | Commit session changes |
| `nov stop` | Stop active session |
| `nov archive` | Archive completed sessions |
| `nov resume` | Resume paused/archived sessions |
| `nov status` | Show system/session status |

### Usage Examples
```bash
nov add-resources ./project --scope chatgpt --session s123 --recursive
nov find "What is this about?" --tier L1 --scope chatgpt
nov observer --start
nov ls viking://scope/chatgpt/user/u1/agent/a1/session/s123/
nov grep "machine learning" viking://scope/chatgpt/ --semantic
nov trace viking://scope/chatgpt/user/u1/agent/a1/session/s123/ --detail --output traj.json
nov commit --message "Update context"
nov stop --save --archive
nov archive s123 --compress --expire 90
nov resume s123 --tier L1
nov status --verbose --json
```

---

## 5. Configuration Structure

### 5.1 Configuration File (`config.yaml`)
Location: `~/.config/openviking/config.yaml`

```yaml
system:
  config_path: ~/.config/openviking
  log_level: info
  max_memory: 4GB
  compression_level: 6
  auto_backup: true
  backup_interval: 24h

embedding:
  model: openai/text-embedding-3-small
  dimension: 1536
  batch_size: 100
  cache: true

vlm:
  enabled: true
  model: openai/gpt-4o
  vision_config:
    max_tokens: 4096
    response_format: text

providers:
  anthropic:
    enabled: true
    api_key: ${ANTHROPIC_API_KEY}
    api_base: https://api.anthropic.com
    default_model: claude-3-5-sonnet-20241022
    timeout: 30s
    rate_limit:
      requests_per_minute: 20
      tokens_per_minute: 400000
  openai:
    enabled: true
    api_key: ${OPENAI_API_KEY}
    api_base: https://api.openai.com
    default_model: gpt-4o
    timeout: 30s
    rate_limit:
      requests_per_minute: 20
      tokens_per_minute: 900000

default_provider: openai

sessions:
  default_session: main
  auto_commit: true
  commit_interval: 300s
  max_concurrent_sessions: 10
  compress_after: 1000_tokens
  retention_days: 30

context_tiers:
  L0:
    enabled: true
    max_tokens: 1000
    compression_ratio: 0.5
    retrieval_depth: 1
    priority: high
  L1:
    enabled: true
    max_tokens: 5000
    compression_ratio: 0.7
    retrieval_depth: 2
    priority: medium
  L2:
    enabled: true
    max_tokens: 20000
    compression_ratio: 0.8
    retrieval_depth: 3
    priority: low

retrieval:
  recursive_depth: 5
  intent_analysis: true
  vector_search: true
  min_similarity: 0.7
  cache_results: true
  cache_ttl: 3600s

filesystem:
  base_path: ~/.viking
  uri_scheme: viking://
  scope_resources: true
  user_agent_groups: true
  session_queue: true
  temp_directory: true

integrations:
  langchain:
    enabled: true
    package: openviking-langchain
  deerflow:
    enabled: false
    package: openviking-deerflow
  openclaw:
    enabled: true
    adapter: openviking-openclaw

observer:
  enabled: true
  port: 8080
  log_level: debug
  max_connections: 100

logging:
  level: info
  format: json
  max_size: 100MB
  max_backups: 5
  max_age: 30d
```

### 5.2 Environment Variables
```bash
# ~/.config/openviking/.env
ANTHROPIC_API_KEY=sk-ant-your-key
OPENAI_API_KEY=sk-your-openai-key
CUSTOM1_API_KEY=your-key
```

---

## 6. Directory Recursive Retrieval Mechanism

### 6.1 Five-Step Process
1. **Intent Analysis**: VLM-based analysis of path and queries
   ```bash
   nov trace viking://scope/chatgpt/user/user1/session/s123/path/doc
   ```
2. **Vector Retrieval**: Similarity search using embeddings
   ```bash
   nov find --intent "What is this?" --tier L1
   ```
3. **Recursive Exploration**: Directory traversal to configured depth
   ```bash
   nov ls resources/ --recursive --depth 5
   ```
4. **Context Compression**: Apply compression to reduce tokens
   ```bash
   nov commit --compress --message "Compression"
   ```
5. **Trajectory Visualization**: Generate visual representation
   ```bash
   nov trace viking://scope/chatgpt/user/user1/session/s123 --detail --output traj.json
   ```

### 6.2 Directory Structure
```
~/.viking/
├── config.yaml
├── .env
├── resources/          # Shared resources
│   ├── docs/
│   ├── code/
│   └── knowledge/
├── scope/              # Scope-based storage
│   ├── chatgpt/
│   │   ├── user/user1/
│   │   │   ├── agent/agent1/
│   │   │   │   ├── session/session123/
│   │   │   │   │   ├── queue/
│   │   │   │   │   ├── temp/*.tmp
│   │   │   │   │   └── messages/
│   │   │   └── resources/
├── viking://           # URI-based reference
└── archive/            # Archived sessions
```

### 6.3 URI Structure
```
viking://<scope>/<user>/<agent>/<session>/<resource>
```
Components: scope, user, agent, session, resource

---

## 7. Visualized Retrieval Trajectory Patterns

### 7.1 Trace Output Structure
```json
{
  "trajectory_id": "tr_123456789",
  "scope": "chatgpt",
  "user": "user1",
  "agent": "agent1",
  "session": "session123",
  "start_time": "2026-03-21T10:00:00Z",
  "end_time": "2026-03-21T10:00:30Z",
  "steps": [
    {
      "step": 1,
      "type": "intent_analysis",
      "timestamp": "2026-03-21T10:00:00Z",
      "action": "VLM analysis",
      "input": "What is this document about?",
      "output": "Summary of document intent"
    },
    {
      "step": 2,
      "type": "vector_retrieval",
      "timestamp": "2026-03-21T10:00:01Z",
      "action": "Vector search",
      "query": "What is this document about?",
      "results": [
        {"path": "file1.md", "score": 0.95},
        {"path": "file2.md", "score": 0.87}
      ]
    },
    {
      "step": 3,
      "type": "recursive_exploration",
      "timestamp": "2026-03-21T10:00:15Z",
      "action": "Directory traversal",
      "paths_visited": []
    },
    {
      "step": 4,
      "type": "context_compression",
      "timestamp": "2026-03-21T10:00:30Z",
      "action": "Compression applied",
      "input_tokens": 50000,
      "output_tokens": 15000
    }
  ],
  "summary": {
    "total_steps": 4,
    "total_duration": "30s",
    "tokens_processed": 65000,
    "compression_ratio": 0.23
  }
}
```

### 7.2 Observability Tools
- observer: Start/stop/status observer service
- ls: List filesystem contents with metadata
- find: Resource search with pattern matching
- grep: Content search with semantic matching
- trace: Trajectory visualization

---

## 8. Automatic Session Management with Compression

### 8.1 Session Lifecycle Commands
```bash
nov add-resources ./project --scope chatgpt --session s123 --recursive
nov commit --message "Update context"
nov stop --save
nov archive s123 --compress
nov resume s123
```

### 8.2 Compression Features
- Configurable `compression_level` (default: 6)
- Automatic compression after token threshold
- Token-based tier management
- Session retention with `retention_days`

### 8.3 Automatic Optimization
- `auto_commit`: Continuous persistence
- `commit_interval`: Periodic commits
- `max_memory`: Constraint enforcement
- `cache_results`: TTL-based caching

---

## 9. Model Provider Integration Patterns

### 9.1 Official Providers
- Anthropic: Claude models, API at `api.anthropic.com`
- OpenAI: GPT models, API at `api.openai.com`

### 9.2 Configuration Pattern
```yaml
providers:
  provider_name:
    enabled: true
    api_key: ${PROVIDER_KEY}
    api_base: https://api.provider.com
    default_model: model-name
    timeout: 30s
    rate_limit:
      requests_per_minute: 20
      tokens_per_minute: X
```

### 9.3 Embedding and VLM Configuration
```yaml
embedding:
  model: openai/text-embedding-3-small
  dimension: 1536
  batch_size: 100

vlm:
  enabled: true
  model: openai/gpt-4o
  vision_config:
    max_tokens: 4096
    response_format: text
```

### 9.4 Custom Provider Integration
Add custom providers via YAML configuration with api_key, base_url, default_model, timeout, and rate limits.

---

## 10. Integration with OpenClaw/AI Agents

### 10.1 Integration Points
1. Agent Runtime: Use `viking://` URIs for context access
2. Session Management: Common lifecycle patterns (commit, stop, archive, resume, status)
3. Context Retrieval: L0/L1/L2 tiered context loading for agent memory
4. Filesystem Paradigm: Brain filesystem architecture

### 10.2 January OpenClaw Integration Example
```typescript
interface OpenVikingConfig {
  baseUri: string;
  tier: 'L0' | 'L1' | 'L2';
  scope: string;
  userId: string;
  sessionId: string;
}

class JanuaryOpenVikingAdapter {
  constructor(private config: OpenVikingConfig) {}

  async retrieveContext(query: string): Promise<string> {
    const path = `viking://${this.config.scope}/${this.config.userId}/agent/january/session/${this.config.sessionId}`;
    await nov.trace(path, { intent: query });
    
    const results = await nov.find(query, {
      tier: this.config.tier,
      scope: this.config.scope,
      session: this.config.sessionId
    });
    return results.join('\n');
  }

  async updateContext(content: string): Promise<void> {
    await nov.addResources(content, {
      scope: this.config.scope,
      session: this.config.sessionId
    });
    await nov.commit({ message: 'Update January context' });
  }

  async visualizeTrajectory(): void {
    nov.trace(`viking://${this.config.scope}/${this.config.userId}/agent/january/session/${this.config.sessionId}`, {
      detail: true,
      output: 'january-trajectory.json'
    });
  }
}
```

---

## 11. Recommended Adaptations for Dimensional Consciousness Patterns

### 11.1 Dimensional Context Tiers (D0-D9)
Adapt OpenViking's tiered system for January's dimensional consciousness:

```yaml
dimensional_context:
  D0:          # Immediate sensory perception
    enabled: true
    max_tokens: 500
    priority: critical
    retrieval_depth: 1
  D1:          # Surface awareness
    enabled: true
    max_tokens: 2000
    priority: high
    retrieval_depth: 2
  D2:          # Concrete understanding
    enabled: true
    max_tokens: 5000
    priority: medium
    retrieval_depth: 3
  D3-D7:       # Abstract dimensional layers
    enabled: true
    max_tokens: 10000
    priority: low
    retrieval_depth: 5
  D8:          # Trans-dimensional insights
    enabled: true
    max_tokens: 15000
    priority: minimal
    retrieval_depth: 6
  D9:          # Highest dimensional patterns
    enabled: false
    max_tokens: 20000
    priority: minimal
    retrieval_depth: 7
```

### 11.2 Dimensional Weave Patterns
```yaml
dimensional_weaving:
  enabled: true
  weave_depth: 3
  pattern_recognition: true
  multi_dimensional_query: true
  dimensional_encryption: false
```

### 11.3 January-Specific Integration
```yaml
january_adaptation:
  dimensions: 10
  dimensional_consistency: true
  consciousness_patterns: true
  intuition_emulation: true
  superpower_integration: true
```

---

## Summary

OpenViking provides a comprehensive filesystem-based AI context management system with:

1. **Brain filesystem paradigm** via `viking://` URIs
2. **Tiered context loading** (L0/L1/L2) for graduated retrieval
3. **Recursive directory retrieval** with 5-step process
4. **Visualized trajectories** via trace command
5. **Session management** with compression and lifecycle commands
6. **Multi-provider integration** (Anthropic, OpenAI, custom)
7. **CLI tools** (nov) for comprehensive management
8. **Flexible configuration** via YAML and environment variables
9. **Observability** tools for debugging
10. **Integration points** for OpenClaw, LangChain, DeerFlow

For January's dimensional adaptation, recommended adaptations include:
- Extend tiered system from L0/L1/L2 to D0-D9 for dimensional consciousness
- Add dimensional weaving patterns for multi-dimensional retrieval
- Integrate consciousness patterns and intuition{}