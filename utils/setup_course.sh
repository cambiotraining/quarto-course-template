#!/bin/bash

set -euo pipefail

# Prompt for course title and repository name
read -rp "Enter the course title: " COURSE_TITLE
read -rp "Enter the repository name (e.g. my-course): " REPO_NAME

# Create and enter new directory
if [ -d "$REPO_NAME" ]; then
  echo "Error: A directory named '$REPO_NAME' already exists. Please choose a different repository name or delete the existing directory."
  exit 1
fi

mkdir "$REPO_NAME"
cd "$REPO_NAME"

# Check for required tools
if ! command -v quarto &> /dev/null; then
  echo "Error: Quarto is not installed. Please install it from https://quarto.org/docs/get-started/"
  exit 1
fi

if command -v wget &> /dev/null; then
  DL="wget -O"
elif command -v curl &> /dev/null; then
  DL="curl -sSL -o"
else
  echo "Error: Neither wget nor curl is installed. Please install one to proceed."
  exit 1
fi

# Initialise Quarto project
quarto use template --no-prompt cambiotraining/quarto-course-template

# Clean files
rm -f utils/setup_course.sh
rm -f materials/0[1-9]*.md   # keeps 00-template.md

mv course-template.code-workspace "${REPO_NAME}.code-workspace"
mv course-template.Rproj "${REPO_NAME}.Rproj"

# Update _quarto.yml
cat _quarto.yml |\
  sed "s|href: https://github.com/cambiotraining/.*|href: https://github.com/cambiotraining/${REPO_NAME}|" |
  sed "s|title: \"Course Development Guidelines\"|title: \"${COURSE_TITLE}\"|" > temp_quarto.yml
mv temp_quarto.yml _quarto.yml

# Update index.md
sed "s|Course Development Guidelines {\.unnumbered}|${COURSE_TITLE} {\.unnumbered}|" index.md > temp_index.md
mv temp_index.md index.md

# add .gitignore
cat << 'EOF' > .gitignore
# Quarto files
/.quarto/
_site

# python notebooks
*.ipynb

# R files
.Rhistory
.Rapp.history
.RData
.RDataTmp
.Ruserdata
.Rproj.user/
*_cache/
/cache/
*.utf8.md
*.knit.md
.Renviron

# Jupyter cache
.jupyter_cache
/.luarc.json

**/*.quarto_ipynb
EOF

# add default README.md
cat > README.md <<EOF
# ${COURSE_TITLE}

This repository contains the materials for the course.

**Course Developers**: see our [guidelines page](https://cambiotraining.github.io/quarto-course-template/materials.html) if contributing materials.

These materials are released under a [CC BY 4.0](LICENSE.md) license.
EOF

cat > CITATION.cff <<EOF
# Note: we use the author alias to record author contributions
# This is a known limitation of CFF files: https://github.com/citation-file-format/citation-file-format/issues/112
# Suggested author roles are given here: https://cambiotraining.github.io/quarto-course-template/materials/03-authorship.html#author-roles

cff-version: 1.2.0
title: "${COURSE_TITLE}"
message: >-
  You may cite these materials using the metadata in this
  file. Please cite our materials if you publish materials
  derived from these, run a workshop using them, or use
  the information in your own work.
type: dataset
authors:
  - given-names: "Name"
    family-names: "Surname"
    affiliation: "Institution or Affiliation"
    website: "https://your.website.here"
    orcid: "https://orcid.org/0000-0000-0000-0000"
    alias: "edit author contribution roles"
repository-code: "https://github.com/cambiotraining/${REPO_NAME}"
url: "https://cambiotraining.github.io/${REPO_NAME}/"
license: CC-BY-4.0
commit: "FIX: commit hash"
date-released: "$(date +%Y-%m-%d)"
EOF

# replace _chapters.yml with placeholder file
cat > materials/_chapters.yml <<EOF
book:
  chapters:
    - part: "Section title"
      chapters:
        - materials/00-template.md
EOF

# GitHub workflows
mkdir -p .github/workflows

cat << 'EOF' > .github/workflows/deploy_latest.yml
name: Deploy Latest

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Deploy
        uses: cambiotraining/crit-gh-actions/course-deploy@main
        with:
          pre_render: "echo 'Optional pre-render commands'"
          post_render: "echo 'Optional post-render commands'"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
EOF

cat << 'EOF' > .github/workflows/tag_release.yml
name: Tag Release

on:
  push:
    tags:
      - '20[2-9][0-9].[0-1][0-9].[0-3][0-9]'

jobs:
  archive:
    runs-on: ubuntu-latest
    steps: 
      - name: Archive
        uses: cambiotraining/crit-gh-actions/course-archive@main
        with:
          pre_render: "echo 'Optional pre-render commands'"
          post_render: "echo 'Optional post-render commands'"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  deploy:
    runs-on: ubuntu-latest
    needs: archive
    steps:
      - name: Deploy
        uses: cambiotraining/crit-gh-actions/course-deploy@main
        with:
          pre_render: "echo 'Optional pre-render commands'"
          post_render: "echo 'Optional post-render commands'"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
EOF

cat << 'EOF' > .github/workflows/update_extensions.yml
name: Scheduled Quarto Extensions Update

on:
  schedule:
    - cron: '0 6 1 * *'   # 06:00 UTC on the 1st of each month
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  update-extensions:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Update extensions
        uses: cambiotraining/crit-gh-actions/course-extensions-update@main

      - name: Create or update PR
        uses: peter-evans/create-pull-request@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: "chore: automated update to Quarto extensions"
          branch: "auto/quarto-ext-update"
          title: "chore: automated update to Quarto extensions"
          body: |
            Automated update of Quarto extensions to their latest versions.
          labels: "chore,extensions-update"
EOF

echo "Course template created successfully in $REPO_NAME directory."
