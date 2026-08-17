#!/bin/bash

# https://github.com/simonw/llm
uv tool install llm
llm install llm-ollama
llm models default deepseek-r1:1.5b

# https://github.com/google-gemini/gemini-cli
npx https://github.com/google-gemini/gemini-cli
