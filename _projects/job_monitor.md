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

<div class="caption">The live dashboard: search and filters on the left, open roles in Canada over time, newest postings first.</div>

### The problem

New-grad postings are spread across many company career sites, and those sites run on many different applicant tracking systems (Greenhouse, Workday, Ashby, Lever, Oracle, SuccessFactors and more), each with its own API. Checking them by hand means missing postings or finding them days late.

### What I built

- A Python pipeline with **21 platform adapters** behind one fetcher interface, covering **106 sources**. Several adapters call undocumented endpoints that I reverse-engineered from the career sites themselves, such as Google's `batchexecute` RPC. It uses only the Python standard library.
- A scheduled job on **GitHub Actions** that runs every 15 minutes: fetch every source, keep postings that match the title keywords and locations, drop duplicates, send new ones to Discord, and commit the updated state back to the repository.
- A static [dashboard](https://capy-zhiao.github.io/Job_Monitor/) in plain JavaScript: search plus filters for role, country, city, company, work type and posting age. The filters are stored in the URL, so a filtered view can be shared as a link.
- A `/linkedin` command in Discord for searching LinkedIn on demand. A small bot on my own machine runs the search when the command is used, drops senior titles and staffing agencies, skips postings the scheduled job already reports, and posts the rest in the channel.

{% include figure.liquid path="assets/img/projects/job_monitor_linkedin.png" title="/linkedin results in Discord" class="img-fluid rounded z-depth-1" %}

<div class="caption">A /linkedin reply. The first line counts new results, results the scheduled job already reports, and results dropped as senior or agency postings.</div>

### Design decisions

- **No server.** State lives in a JSON file that each run commits back to the repository. That costs nothing and keeps a full history of every change. The trade-off is timing: GitHub can delay scheduled runs. A concurrency group makes runs queue instead of overlapping, so two runs never write the state file at once.
- **One broken source never stops a run.** Each request has a timeout and each source runs in its own error handler, with every failure logged. A run only fails when nothing at all comes back. The weakness of this rule is that a source that slowly stops returning results can go unnoticed; the next step is to alert when a source keeps failing or comes back empty across several runs.
- **Duplicates.** The same posting can appear through several sources, or twice when a Workday listing pages through its results. Postings are deduplicated on a stable ID, and the set of seen IDs only grows, so a posting that disappears and comes back does not trigger a second alert.
- **LinkedIn on demand, not on a schedule.** LinkedIn blocks requests from datacenter IPs such as GitHub's runners and does not allow automated scraping, so it cannot be one of the scheduled sources. The bot searches only when asked, at low volume, from a home connection. It keeps no state and never writes to the repository; to skip postings that are already reported, it reads the data the dashboard publishes. I kept the two apart on purpose. I first ran the monitor on both my laptop and GitHub Actions, each with its own state file, and keeping those in sync led to a merge conflict that left the local state file unreadable. Alerts stopped for almost two weeks before I found it. Since then the scheduled job is the only thing that writes state.

### How I checked it

- An offline `unittest` suite with mocked HTTP responses for the adapters and the LinkedIn parser, plus checks that the source configuration is valid. CI runs it on Python 3.8, 3.12 and 3.13.
- As of October 2026 the scheduled job has completed **1,280+ successful runs** and tracked **880+ unique postings**.
- The first `/linkedin` run, in October 2026, returned 29 results: 17 were dropped as senior or agency postings, 5 were already on the dashboard, and **7 were not on the dashboard**.
