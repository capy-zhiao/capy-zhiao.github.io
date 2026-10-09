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

I was preparing for interviews with a study plan written in markdown. It stopped working past a hundred or so problems: I could not keep that many review dates in my head, and when many problems came due on the same day there was no good way to pick the few that mattered.

### What I built

- A **React + TypeScript** frontend and a **FastAPI + SQLAlchemy 2.0 + Pydantic v2** backend with 22 REST endpoints. It uses SQLite locally; setting `DATABASE_URL` switches it to PostgreSQL.
- It covers **272 problems** from NeetCode 150, Top Interview 150 and LeetCode 75 (the lists overlap).
- Spaced-repetition scheduling. Each attempt is graded from what actually happened (time taken, whether there were bugs, whether I looked at the solution) instead of how I felt about it, and the next review date follows from that grade.
- A mock interview mode: a random problem, a countdown, and then follow-up questions about the code I just wrote, which an LLM grades.
- Drills where I write one of 15 algorithm templates from memory, and a required time and space complexity answer on every attempt, checked against reference answers for 247 of the 272 problems.

### Design decisions

- **A day has a fixed number of slots.** When more reviews are due than fit in a day, they are ranked by days overdue, past failures, difficulty and chapter. The first pass gives each chapter and each pattern at most two slots, so a day stays mixed when it can; if that leaves slots empty, the limit is relaxed and the highest-priority skipped problems fill them.
- **The rules are kept apart from the database.** The spaced-repetition rules and the template grader never touch the database, and the date can be passed in explicitly, so each rule can be tested on its own with a fixed day. The layer that builds the daily queue reads the database and also takes the date as a parameter.
- **Templates are graded by checkpoints, not text similarity.** Each template lists the lines that make it correct, and a drill passes only when all of them are present. Similarity to the reference is shown as a soft signal and never passes a drill on its own, because code can read like the template and still miss the one line that matters. A test checks that every reference solution passes its own checkpoints.
- **The LLM layer does not depend on one provider.** Claude uses structured outputs; DeepSeek uses JSON mode with Pydantic validation. A failed provider call returns nothing instead of raising. Without a configured provider, the AI features are switched off with a clear message and the rest of the app works as usual. The AI complexity check is a separate request from saving an attempt, because a reasoning-model reply can take tens of seconds and should not hold up saving.

### How I checked it

- **204 pytest tests**, including the scheduling rules, complexity grading and the API.
- CI on every push to `main` and every pull request runs the backend tests, a type-check and production build of the frontend, and a check that the problem set is complete and tagged.
- I built it with Claude Code and used the test suite and CI to check the generated code.
