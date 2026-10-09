---
layout: page
title: Job Monitor
description: Tracks new-grad jobs from 106 career feeds every 15 minutes. Live dashboard, Discord alerts, on-demand LinkedIn search.
img: assets/img/projects/thumb_job_monitor.png
importance: 1
category: featured
github: https://github.com/capy-zhiao/Job_Monitor
---

[Live dashboard](https://capy-zhiao.github.io/Job_Monitor/) · [Code on GitHub](https://github.com/capy-zhiao/Job_Monitor) · Solo project, running since July 2026

{% include figure.liquid loading="eager" path="assets/img/projects/job_monitor.png" title="Job Monitor dashboard" class="img-fluid rounded z-depth-1" %}

<div class="caption">The live dashboard: filters on the left, open roles in Canada over time, newest postings first.</div>

### The problem

New-grad postings are spread across many career sites, and those sites run on different applicant tracking systems (Greenhouse, Workday, Ashby, Lever and more), each with its own API. Checking them by hand means missing postings or finding them days late.

### What I built

- A Python pipeline with **21 platform adapters** covering **106 career feeds**, using only the standard library. Several adapters call undocumented endpoints I reverse-engineered, such as Google's `batchexecute` RPC.
- A **GitHub Actions** job every 15 minutes that fetches every feed, keeps postings that match the title keywords and locations, sends new ones to Discord and commits its state back to the repository.
- A [live dashboard](https://capy-zhiao.github.io/Job_Monitor/) in plain JavaScript with search, filters and shareable filtered links.
- A `/linkedin` command in Discord that searches LinkedIn on demand and posts what the scheduled job has not already reported.

{% include figure.liquid path="assets/img/projects/job_monitor_linkedin.png" title="/linkedin results in Discord" class="img-fluid rounded z-depth-1" %}

<div class="caption">A /linkedin reply: new results, results already tracked, and results filtered out as senior or agency postings.</div>

### Design decisions

- **No server.** State is a JSON file that each run commits back, which costs nothing and keeps a full history. The trade-off is that GitHub can delay scheduled runs; a concurrency group stops runs from overlapping.
- **One broken source never stops a run.** Every source has a timeout and its own error handling, and a run fails only if nothing comes back. A source that quietly stops returning results could go unnoticed, so an alert for that is the next step.
- **Duplicates.** The same posting can show up through several feeds, or twice in one. Postings are deduplicated on a stable ID, and the set of seen IDs only grows.
- **LinkedIn runs on demand, from my machine.** LinkedIn blocks datacenter IPs like GitHub's and does not allow automated scraping, so the bot searches only when asked and keeps no state. Only the scheduled job writes state: when I once ran the monitor on both my laptop and GitHub Actions, a merge conflict broke the state file and alerts stopped for almost two weeks.

### How I checked it

- An offline `unittest` suite with mocked HTTP for the adapters and the LinkedIn parser, plus config checks, run in CI on Python 3.8, 3.12 and 3.13.
- As of October 2026: **1,280+ successful runs** and **880+ unique postings** tracked.
- On its first run in October 2026, `/linkedin` found **7 postings** that were not on the dashboard.
