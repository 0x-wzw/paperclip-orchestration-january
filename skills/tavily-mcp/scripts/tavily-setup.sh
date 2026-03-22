#!/bin/bash
# Tavily MCP Quick Setup Script
# Install and configure Tavily MCP for OpenClaw

set -e

echo "🚀 Tavily MCP Setup Script"
echo "=========================="
echo ""

# Check for Tavily API key
API_KEY="${TAVILY_API_KEY:-}"

if [ -z "$API_KEY" ]; then
    echo "❌ Tavily API key not found."
    echo ""
    echo "Please set your API key:"
    echo '  export TAVILY_API_KEY="your-api-key"'
    echo '  OR'
    echo '  ./tavily-setup.sh "your-api-key"'
    echo ""
    echo "Get a free API key at: https://tavily.com/"
    exit 1
fi

echo "✅ API key found"
echo ""

# Step 1: Install MCP client if not found
if ! command -v mcp-server &> /dev/null; then
    echo "📦 Installing MCP server..."
    npm install -g @openai/mcp-server
else
    echo "✅ MCP server already installed"
fi

echo ""

# Step 2: Add Tavily MCP to OpenClaw
echo "🔗 Adding Tavily MCP to OpenClaw..."
claude mcp add --transport http tavily https://mcp.tavily.com/mcp/?tavilyApiKey="$API_KEY"

echo ""
echo "✅ Tavily MCP configured successfully!"
echo ""
echo "You can now use Tavily search and extraction tools in OpenClaw."
echo ""
echo "Test with:"
echo '  tavily-search --query "latest news today"'
echo ""
echo "Or in interactive mode, just ask about current events."
