#!/bin/env bash

set -eo pipefail

# Make a backup directory for existing files
mkdir -p update-backup

# Workflows

echo "Setting up GitHub Actions workflows..."

mv .github/ update-backup/ || true
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

echo "GitHub Actions workflows have been updated."


# Update extensions

echo "Updating Quarto extensions..."

echo "Backing up existing _extensions directory to 'update-backup' directory..."
mv _extensions update-backup/ || true

echo "Updating extensions..."
mkdir -p _extensions
quarto update --no-prompt mcanouil/quarto-iconify
quarto update --no-prompt quarto-ext/fontawesome
quarto update --no-prompt cambiotraining/crit-quarto-ext/callout-exercise
quarto update --no-prompt cambiotraining/crit-quarto-ext/crit-format
quarto update --no-prompt cambiotraining/crit-quarto-ext/citation-cff-parser

echo "Finished updating extensions. Check the backup folder if there are extensions you want to keep."


# Update _quarto.yml

echo "Update course format..."
echo "Backing up existing _quarto.yml to 'update-backup' directory..."
cp _quarto.yml update-backup/

sed 's|courseformat-html|crit-format-html|g' _quarto.yml |\
  sed 's|- courseformat|- callout-exercise|g' |\
  sed 's|_extensions/cambiotraining/courseformat|_extensions/cambiotraining/crit-format|g' |\
  sed 's|_extensions/courseformat|_extensions/cambiotraining/crit-format|g' |\
  sed 's|Bioinformatics Training Facility|Cambridge Research Informatics Training|g' > _quarto.tmp.yml
mv _quarto.tmp.yml _quarto.yml

cat << 'EOF' >> _quarto.yml
  appendices: 
    - href: versions.md
EOF

echo "Finished updating _quarto.yml."

# Adding versions.md to the repo

# if versions.md exists move to backup and print message
if [ -f versions.md ]; then
    echo "Backing up existing versions.md to 'update-backup' directory..."
    mv versions.md update-backup/
fi

cat << 'EOF' > versions.md
# Archived Versions {.unnumbered}

<!--
Course Maintainers Note:
- You may edit the title above and introductory text below to your taste.
- Do NOT change the {.list-group} element.
- Do NOT rename this file; it must remain versions.md.
-->

Select a version to view the course materials as they were at that time.

Each version represents a snapshot of the course materials at a specific point in time. This allows participants to access the exact version of the materials they used during their course, even as the content continues to evolve.

The latest version always contains the most up-to-date content and improvements.

::: {.list-group}
<!-- AUTOMATIC_VERSIONS_START - DO NOT EDIT: managed by update-dropdown.py -->
<!-- AUTOMATIC_VERSIONS_END -->
:::
EOF

echo "Added versions.md to the repository."

# Finished
cat << EOF
All updates completed successfully. 

Please review the changes and run 'quarto render' locally to verify the pages build as expected.
Pay particular attention to callout boxes and styling (e.g. colours and logos). 

We have included backups of existing files in the 'update-backup' directory in case you need to revert any changes.
There is no need to push the 'update-backup' directory to your repository.

When you push to GitHub, make sure the Deploy action runs successfully and that you have a versions dropdown on the top-right of your course pages.
EOF
