---
layout: page
title: Code Review Hotspots
description: Does a pull request's topic predict which files reviewers comment on? A team study of 33,596 PRs written by AI coding agents; I built the data collection and evaluation.
img: assets/img/projects/thumb_review_hotspots.png
importance: 3
home_order: 4 # position on the homepage grid (lower comes first)
category: course
github: https://github.com/capy-zhiao/Code_Review_Hotspot_Prediction
---

[Code on GitHub](https://github.com/capy-zhiao/Code_Review_Hotspot_Prediction) · [Report (PDF)](https://plg.uwaterloo.ca/~migod/846/current/projects/02-TongweiZhaoyiZhiao-report.pdf) · Course project for CS 846 at the University of Waterloo · Team of three; I built the data collection and the evaluation

{% include figure.liquid loading="eager" path="assets/img/projects/thumb_review_hotspots.png" title="Pipeline overview" class="img-fluid rounded z-depth-1" %}

<div class="caption">The pipeline. The highlighted steps are mine; my teammates built the topic model.</div>

### The problem

AI coding agents now open pull requests in many projects, and reviewers have to decide which changed files to read closely. We asked whether the kind of change a PR makes, found by topic modelling its text, predicts which files reviewers will comment on.

### My part

- **Data collection** in **Python** and **pandas**: loads the AIDev dataset of agent-written pull requests from Hugging Face (PR, commit, commit detail and comment tables) and joins them into one text document per PR: title, description, commit messages, conversation comments and the patches of the changed files. That gives **33,596 PRs from 2,807 repositories**.
- **Evaluation**: a fixed 80/20 split (26,876 PRs to learn from, 6,720 held out) and two kinds of scores for the predictions on the held-out PRs:
  - how close the predicted share of attention per file is to the actual share, where each file with an inline review comment gets an equal share and a PR with no review comments spreads it evenly over its files (cosine similarity and Jensen–Shannon divergence)
  - how well the predicted hotspot files match the actual ones (Hit@K, Precision@K, Recall@K and NDCG@K for K = 1, 3, 5 and 10)

### How the pipeline works

- **BERTopic** with `all-MiniLM-L6-v2` sentence embeddings groups the PR documents into 483 topics, plus an outlier group (built by my teammates).
- A predictor flags a file in a new PR as a hotspot when files of the same type (source, tests, docs, config, build or other) received attention in training PRs with the same topic.
