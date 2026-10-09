---
layout: page
title: LeetCode Tracker
description: Spaced-repetition app that picks what to review each day from past attempts. React, FastAPI, 200+ tests.
img: assets/img/projects/thumb_leetcode_tracker.png
importance: 2
category: featured
github: https://github.com/capy-zhiao/leetcode-tracker
---

[Code on GitHub](https://github.com/capy-zhiao/leetcode-tracker) · Solo project, built with Claude Code · No public demo; it runs locally

{% include figure.liquid loading="eager" path="assets/img/projects/leetcode_tracker.png" title="LeetCode Tracker daily queue" class="img-fluid rounded z-depth-1" %}

<div class="caption">The daily queue: reviews ranked by priority, new problems, and one template drill.</div>

### The problem

I was preparing for interviews with a study plan in markdown. Past about a hundred problems, I could no longer keep track of review dates, or pick the few that mattered on days when many came due.

### What I built

- A **React + TypeScript** frontend and a **FastAPI** backend (SQLAlchemy 2.0, Pydantic v2, 22 REST endpoints) on SQLite, or PostgreSQL by setting `DATABASE_URL`.
- **272 problems** from NeetCode 150, Top Interview 150 and LeetCode 75 (the lists overlap).
- Spaced repetition: each attempt is graded from what actually happened (time taken, bugs, whether I looked at the solution), and the grade sets the next review date.
- A mock interview mode with a countdown and LLM-graded follow-up questions about the code I just wrote.
- Drills for writing 15 algorithm templates from memory, and a required complexity answer on every attempt, checked against reference answers for 247 problems.

### Design decisions

- **A day has a fixed number of slots.** When more reviews are due than fit, they are ranked by days overdue, past failures, difficulty and chapter. The first pass allows at most two per chapter and per pattern so a day stays mixed; any empty slots are then filled with the highest-priority problems that were skipped.
- **Rules are kept apart from the database.** The spaced-repetition rules and the template grader never touch the database, and the date can be passed in explicitly, so each rule can be tested on a fixed day.
- **Templates are graded by checkpoints, not text similarity.** A drill passes only when every required line is present. Similarity is shown but never passes a drill, because code can look like the template and still miss the one line that matters.
- **The LLM layer works with more than one provider.** Claude uses structured outputs and DeepSeek uses JSON mode with Pydantic validation. Without a provider, the AI features are switched off with a clear message and the rest of the app works.

### How I checked it

- **204 pytest tests** covering the scheduling rules, complexity grading and the API.
- CI on every push and pull request runs the backend tests, a frontend type-check and build, and a check that the problem set is complete and tagged.
- I built it with Claude Code and used the tests and CI to check the generated code.
