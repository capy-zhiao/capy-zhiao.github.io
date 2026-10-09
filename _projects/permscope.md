---
layout: page
title: PermScope
description: Found 183 mini-program APIs in WeChat, QQ, Alipay and Baidu that skip permission checks. Published at USENIX Security '26.
img: assets/img/projects/thumb_permscope.png
importance: 3
category: featured
github: https://github.com/capy-zhiao/PERMSCOPE_
---

[Paper (USENIX Security ’26)](https://www.usenix.org/conference/usenixsecurity26/presentation/wei-zhiao) · [PDF](https://www.usenix.org/system/files/usenixsecurity26-wei-zhiao.pdf) · [Poster]({{ '/assets/pdf/PermScope_poster_USENIX26.pdf' | relative_url }}) · [Code on GitHub](https://github.com/capy-zhiao/PERMSCOPE_) · Research project with six authors; I am co-first author with Chao Wang

{% include figure.liquid loading="eager" path="assets/img/projects/permscope_pipeline.png" title="PermScope analysis pipeline" class="img-fluid rounded z-depth-1" zoomable=true %}

<div class="caption">The PermScope analysis pipeline (Figure 3 in the paper).</div>

### The problem

Super-apps such as WeChat, QQ, Alipay and Baidu let third-party mini-programs call APIs that reach location, the camera, biometric sensors and other Android resources. Each API should check the super-app's own permissions first. If it skips that check, any mini-program can read the data without the user's consent.

### My part

- PermScope's dynamic analysis in **Java** on the **Xposed** framework. It hooks the super-app's JavaScript bridge and Android system calls to record which Android resources each mini-program API reaches.
- The test generation pipeline: **Python** and **Playwright** crawlers collect the API documentation, an **LLM** writes a test case for each API, and failing tests are repaired from their runtime errors.

### Results (team)

- Tested **2,067** mini-program APIs. With Claude Opus 4.7, **98.16%** of the generated tests ran on the first attempt.
- Of the 258 APIs that reach permission-protected Android resources, only 75 enforce a matching permission. The other **183** (8.85% of all APIs tested) do not: 96 in WeChat, 43 in Alipay, 33 in Baidu and 11 in QQ. 81 of them reach dangerous-level Android permissions.
- Reported to Tencent, Alipay and Baidu, who acknowledged the findings and fixed key issues. Alipay paid a **$400 bug bounty**.

A follow-up study, [Beyond the Android Oracle](https://github.com/capy-zhiao/miniapp-scope-characterization) (ACM SaTS ’26), uses static analysis to characterize 3,151 mini-program APIs across WeChat, Douyin and Alipay.
