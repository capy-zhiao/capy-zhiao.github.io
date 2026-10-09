---
layout: page
title: Scopes in Super Apps
description: Analyzed 3,151 mini-program APIs in WeChat, Douyin and Alipay. Over 90% fall outside Android's permission model. First-author paper at ACM SaTS '26.
img: assets/img/projects/thumb_super_app_scopes.png
importance: 1
category: research
github: https://github.com/capy-zhiao/miniapp-scope-characterization
---

[Code on GitHub](https://github.com/capy-zhiao/miniapp-scope-characterization) · Paper: *Beyond the Android Oracle: Characterizing Scopes in Super Apps* ([ACM SaTS ’26]({{ '/publications/' | relative_url }}), November 2026) · Two authors; I am first author, with my supervisor Prof. Yousra Aafer

{% include figure.liquid loading="eager" path="assets/img/projects/super_app_scopes_table2.png" title="API counts by category" class="img-fluid rounded z-depth-1" %}

<div class="caption">Table 2 in the paper: every recovered API, split by whether it reaches an Android resource (A or B) and whether it is protected by a scope.</div>

### The problem

Super-apps let mini-programs call their APIs only after the user grants a scope, the super-app's own kind of permission. Earlier work, including PermScope, checked those scopes against Android permissions. That only works for APIs that reach an Android resource such as the camera or location. For every other API, Android offers nothing to compare the scope with.

### My part

- A static analysis tool in **Java** on **dexlib2** that reads each super-app's DEX files and recovers its mini-program APIs: JsApi handler classes in WeChat, the API registry in Douyin, and `@ActionFilter` methods in Alipay.
- **Python** scripts that combine the scanner output with the official API typings and each super-app's scope configuration, and build a table recording, for every API, whether it reaches Android and whether it is scoped.
- Scripts that recompute the paper's tables from the classification data.

### Results

- Recovered **3,151** mini-program APIs: 1,470 in WeChat, 475 in Douyin and 1,206 in Alipay. Only **288** (9.1%) reach an Android resource, so an Android-based check can judge at most 236 of them.
- Only 190 APIs (6.0%) require a scope. Test mini-programs on a physical Android device showed the expected authorization prompt for 159 of them; the other 31 need platform-granted developer qualifications or only work in mini-games.
- **46** of the 190 scoped APIs protect **eight classes** of resources that carry no Android permission: profile and identity, delivery address, invoices, WeChat's social graph and cloud storage, step and health data, screen recording, clipboard, and carrier name. Step and health data are derived from data that Android does protect.

{% include figure.liquid loading="lazy" path="assets/img/projects/super_app_scopes_table4.png" title="Scoped resources with no Android permission" class="img-fluid rounded z-depth-1" zoomable=true %}

<div class="caption">Table 4 in the paper: the eight resource classes, with the number of scoped APIs in each. † Derived from Android-protected information.</div>
