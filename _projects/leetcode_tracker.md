---
layout: page
title: Coding Tracker
description: Spaced-repetition app for interview prep, running on AWS. React, FastAPI, Postgres, 260+ tests.
img: assets/img/projects/thumb_coding_tracker.png
importance: 2
home_order: 6 # position on the homepage grid (lower comes first)
category: featured
github: https://github.com/capy-zhiao/coding-tracker
links:
  - label: Live demo
    url: https://tracker.zhiaowei.dev
---

[Live demo](https://tracker.zhiaowei.dev) ("Try the demo" needs no account) · [Code on GitHub](https://github.com/capy-zhiao/coding-tracker) · Solo project, built with Claude Code

{% include figure.liquid loading="eager" path="assets/img/projects/coding_tracker_today.png" title="Coding Tracker daily queue" class="img-fluid rounded z-depth-1" %}

<div class="caption">The daily queue: reviews ranked by priority, new problems, and one template drill.</div>

### The problem

I was preparing for interviews with a study plan in markdown. Past about a hundred problems, I could no longer keep track of review dates, or pick the few that mattered on days when many came due. I built a tracker for myself, then turned it into a multi-user web app anyone can use.

### What I built

- A **React + TypeScript** frontend and a **FastAPI** backend (SQLAlchemy 2.0, Pydantic v2, 29 REST endpoints), on SQLite locally and **PostgreSQL** in production.
- **272 problems** from NeetCode 150, Top Interview 150 and LeetCode 75 (the lists overlap).
- Spaced repetition: each attempt is graded from what actually happened (time taken, bugs, whether I looked at the solution), and the grade sets the next review date.
- A mock interview mode with a countdown and LLM-graded follow-up questions about the code I just wrote, drills for writing 15 algorithm templates from memory, and a required complexity answer on every attempt.
- **Accounts**: GitHub sign-in, each user's data kept separate, and a shared demo account rebuilt every day.
- **Deployment** on an AWS EC2 instance with Docker Compose: Caddy for automatic HTTPS, the API, Postgres, and nightly database backups. Every push to main that passes CI is built and deployed automatically.

{% include figure.liquid path="assets/img/projects/coding_tracker_stats.png" title="Coding Tracker stats" class="img-fluid rounded z-depth-1" %}

<div class="caption">Stats: progress, a year of daily activity, and progress by chapter.</div>

### Design decisions

- **A day has a fixed number of slots.** When more reviews are due than fit, they are ranked by days overdue, past failures, difficulty and chapter. The first pass allows at most two per chapter and per pattern so a day stays mixed; any empty slots are then filled with the highest-priority problems that were skipped.
- **One place decides whose data it is.** Every request goes through a single dependency that resolves the signed-in user, and every query is scoped to that user. Asking for someone else's attempt returns the same 404 as one that doesn't exist, so IDs can't be probed.
- **Going multi-user without losing my own history.** Database migrations (Alembic) moved a single-user schema to per-user tables, including a primary-key change that SQLite can't do in place, so the migration rebuilds the table and copies the rows across. My local history was then exported and imported into my account on the server, and checked to be identical.
- **Users bring their own AI key.** It stays in their browser and is sent only with AI requests; the server passes it to the provider and never stores or logs it, which a test checks. Custom provider URLs must be HTTPS and resolve to public addresses, so the server can't be pointed at itself or the cloud metadata endpoint.
- **Deploys without SSH or stored cloud keys.** GitHub Actions builds the images for the server's ARM CPU, tags them with the commit, and deploys through AWS Systems Manager. It signs in to AWS with a short-lived OIDC token, and the role it gets can only send commands to that one instance and only accepts this repository's main branch, matched by GitHub's numeric repository ID.
- **Rules are kept apart from the database.** The spaced-repetition rules and the template grader never touch the database, and the date can be passed in, so each rule can be tested on a fixed day.

### How I checked it

- **264 pytest tests** covering the scheduling rules, complexity grading, the API, sign-in, data isolation between users and the migrations. CI runs them on SQLite and on PostgreSQL, along with a frontend type-check and build.
- Each deploy ends with a health check of the live site, and a scheduled job checks it every 30 minutes.
- I built it with Claude Code and used the tests and CI to check the generated code.
