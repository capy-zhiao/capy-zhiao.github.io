---
layout: page
title: CodeMind
description: "Our team built CodeMind, a local-first tool that turns AI coding sessions into a searchable timeline. A custom Model Context Protocol (MCP) server collects sessions from Cursor and Claude, and an OpenAI model extracts the key details and indexes them."
home_line: a Hack the North 2025 prototype where I built the backend for a team of three
img: assets/img/projects/thumb_codemind.png
importance: 2
category: hackathon
---

[Devpost](https://devpost.com/software/gitaihack) · Hack the North 2025 · Team of three; I built the backend · Hackathon prototype

{% include figure.liquid loading="eager" path="assets/img/projects/codemind.png" title="CodeMind dashboard" class="img-fluid rounded z-depth-1" %}

<div class="caption">The team's dashboard at Hack the North (September 2025): saved conversations tagged by type of change, with a generated summary.</div>

### The problem

Decisions and code changes made in AI coding chats are hard to find again once the chat is closed.

### My part: the backend

- A Python **Model Context Protocol (MCP)** server that Claude Desktop calls to save the current conversation as a **Pydantic**-typed record in local JSON storage.
- An analysis step that has **GPT-4** fill in a fixed JSON format: the type of change, a title, a summary, and the code before and after. If the call fails, a default record is saved, so the conversation is never lost.
- A **Flask** API that the team's dashboard reads, tagging each record by the kind of code change (functions, classes, API or database code).
