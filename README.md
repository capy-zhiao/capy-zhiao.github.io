# capy-zhiao.github.io

Personal homepage of **Zhiao Wei** — MMath student in Computer Science at the University of Waterloo.

Built with [Jekyll](https://jekyllrb.com/) and the [al-folio](https://github.com/alshedivat/al-folio) theme (gem-based, `theme: al_folio_core`).

## Editing

- **Bio** — `_pages/about.md` (no profile photo; to show one, add a `profile:` block with `image: prof_pic.jpg`)
- **Accent color** — `$purple-color` in `assets/css/main.scss` (light mode; dark mode keeps the theme's blue)
- **Experience / education** — `_data/experience.yml` and `_data/education.yml`
  (newest first). For a logo, put the image in `assets/img/logos/` and set
  `logo: <file name>` on the entry; without one, the `short` name is shown in a badge.
- **Publications** — `_bibliography/papers.bib` (rendered on `_pages/publications.md`)
- **Social links** — `_data/socials.yml`
- **Site settings** — `_config.yml`

### Updating the USENIX 2026 entry later

In `_bibliography/papers.bib`, inside the `@inproceedings{wei2026raising, ...}` entry:

- **Add the paper link** when public — add one line, e.g.
  `html = {https://www.usenix.org/conference/usenixsecurity26/presentation/wei},`
  (or `pdf = {...}` for a hosted PDF, or `arxiv = {NNNN.NNNNN},`).
- **Add the poster** — replace `assets/img/publication_preview/permscope_poster.png`
  with the real thumbnail, and/or add `poster = {permscope_poster.pdf},`
  (file placed in `assets/pdf/`) to show a "Poster" button.
- Then remove the `additional_info = {Paper PDF and poster coming soon.}` line.

## Deploy

Pushing to `main` triggers `.github/workflows/deploy.yml`, which builds the site
and publishes it to the `gh-pages` branch. GitHub Pages serves from `gh-pages`.

## Local preview (optional)

Requires Ruby 3.x:

```bash
bundle install
bundle exec jekyll serve
```

Then open <http://localhost:4000>.
