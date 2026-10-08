---
layout: page
title: CodeMind
description: Hack the North 2025 prototype, team of three. I built the backend that saves AI coding conversations as structured records.
home_line: a Hack the North 2025 prototype where I built the backend for a team of three
img: assets/img/projects/thumb_codemind.png
importance: 1
category: hackathon
---

[Devpost](https://devpost.com/software/gitaihack) · Hack the North 2025 · Team of three; I built the backend · Hackathon prototype

{% include figure.liquid loading="eager" path="assets/img/projects/codemind.png" title="CodeMind dashboard" class="img-fluid rounded z-depth-1" %}

<div class="caption">The team's dashboard during Hack the North (September 2025): saved conversations tagged by type of change, and the summary generated for the selected one.</div>

### The problem

Conversations with AI coding assistants contain decisions and code changes that are hard to find again once the chat is closed.

### My part: the backend

- A Python **Model Context Protocol (MCP)** server that Claude Desktop can call to save the current conversation as a **Pydantic**-typed record in local JSON storage.
- An analysis step that sends the conversation to **GPT-4** with a fixed JSON format to fill in: the type of change (one of six), a title, a summary, and the code before and after the change. If that call fails, a default record is saved instead, so the conversation itself is never lost.
- A **Flask** JSON API that the team's dashboard reads from. It tags each record with the kind of code change (functions, classes, API or database code) using pattern matching.

### Current status

The analysis call was written against the pre-1.0 interface of the OpenAI Python SDK (`openai.ChatCompletion`), but the project now pins SDK 1.x, where that interface no longer exists. With the pinned dependencies the call fails, so every conversation is saved with the default record. Moving the call to the 1.x client is a small change that has not been made yet.
