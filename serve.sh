#!/usr/bin/env bash
# Local preview for the al-folio site.
# Requires Homebrew Ruby (3.x+) and imagemagick:
#   brew install ruby imagemagick
#   bundle install
# Then just run:  bash serve.sh   ->   http://localhost:4000
set -e
cd "$(dirname "$0")"

# UTF-8 locale: al-folio scans source files and fails on non-ASCII bytes
# (e.g. the "·" in the about subtitle) if the locale is US-ASCII.
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Use Homebrew Ruby instead of the old macOS system Ruby (2.6).
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

exec bundle exec jekyll serve --host 127.0.0.1 --port 4000 --livereload "$@"
