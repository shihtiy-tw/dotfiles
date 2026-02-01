# OpenCode Configuration

## Highlights
- **Agentic AI Configuration**: Configures settings for OpenCode, an AI-powered coding assistant.
- **Multi-Provider Support**: integrations for **Gemini** (Google) and **Ollama** (Local LLMs).
- **Skill Management**: Granular permission controls for AI capabilities (File access, Shell execution, etc.).

## Prerequisites
- `npm` (for plugin management)
- `ollama` (running locally on port 11434 if using local models)

## Structure
- `opencode.jsonc`: The main configuration file.
    - **Models**: Qwen 2.5 Coder (via Ollama) and Gemini 1.5/2.0 (via Google).
    - **MCP**: Model Context Protocol servers (e.g., `readwise`, `sequential-thinking`).
    - **Permissions**: explicitly allowed skills (e.g., `obsidian-skills`, `planning-advisor`).

## AI Providers
| Provider | Models Configured | Usage |
| :--- | :--- | :--- |
| **Ollama** | `qwen2.5-coder:7b`, `qwen2.5-coder:32b` | Local, private code generation |
| **Google** | `gemini-3.0-pro`, `gemini-3.0-flash` | High-reasoning cloud tasks |

## MCP Integration
This configuration enables specific **Model Context Protocol** servers:
- **Readwise**: Connects your reading highlights to the AI context.
- **Sequential Thinking**: enhancements for complex reasoning tasks.
