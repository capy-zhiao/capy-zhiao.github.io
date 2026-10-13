---
layout: page
title: Code Review Hotspots
description: Predicting which files in a pull request reviewers will comment on, over 33,596 PRs written by AI coding agents. I built the data collection and the evaluation.
img: assets/img/projects/thumb_review_hotspots.png
importance: 3
category: course
github: https://github.com/capy-zhiao/Code_Review_Hotspot_Prediction
---

[Code on GitHub](https://github.com/capy-zhiao/Code_Review_Hotspot_Prediction) · [Report (PDF)](https://plg.uwaterloo.ca/~migod/846/current/projects/02-TongweiZhaoyiZhiao-report.pdf) · Course project for CS 846 at the University of Waterloo · Team of three; I built the data collection and the evaluation

{% include figure.liquid loading="eager" path="assets/img/projects/thumb_review_hotspots.png" title="Pipeline overview" class="img-fluid rounded z-depth-1" %}

<div class="caption">The pipeline. The highlighted steps are mine; my teammates built the topic modelling.</div>

### The problem

AI coding agents now open pull requests in many projects, and reviewers have to decide which changed files to read closely. We asked whether the kind of change a PR makes, found by topic modelling its text, predicts which files reviewers will comment on.

### My part

- **Data collection** in **Python** and **pandas**: loads the AIDev dataset of agent-written pull requests from Hugging Face (PR, commit, commit detail and comment tables) and joins them into one text document per PR: title, description, commit messages, conversation comments and the patch of every changed file. That gives **33,596 PRs from 2,807 repositories**.
- **Evaluation**: a fixed 80/20 split (26,876 PRs to learn from, 6,720 held out) and two kinds of scores for the predictions on the held-out PRs:
  - how close the predicted share of reviewer attention per file is to the actual share (cosine similarity and Jensen–Shannon divergence)
  - how well the predicted hotspot files are ranked (Hit@K, Precision@K, Recall@K and NDCG@K for K = 1, 3, 5 and 10)

### The rest of the pipeline (team)

- **BERTopic** with `all-MiniLM-L6-v2` sentence embeddings groups the PR documents into 483 topics, plus an outlier group.
- A predictor picks the likely hotspot files in a new PR from its topic and each file's type (source, tests, docs, config, build or other).
