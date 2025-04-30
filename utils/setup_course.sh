#!/bin/bash

set -euxo pipefail

# Prompt for course title and repository name
read -rp "Enter the course title: " COURSE_TITLE
read -rp "Enter the repository name (e.g. my-course): " REPO_NAME

# Create and enter new directory
mkdir -p "$REPO_NAME"
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
quarto update template --no-prompt cambiotraining/quarto-course-template

# Clean files
rm -f utils/setup_course.sh
rm -f materials/0[1-9]*.md   # keeps 00-template.md

mv course-template.code-workspace "${REPO_NAME}.code-workspace"
mv course-template.Rproj "${REPO_NAME}.Rproj"

# Update _quarto.yml
sed 's|_extensions|_extensions/cambiotraining|g' _quarto.yml |
  sed "s|href: https://github.com/cambiotraining/.*|href: https://github.com/cambiotraining/${REPO_NAME}|" |
  sed "s|title: \"Course Development Guidelines\"|title: \"${COURSE_TITLE}\"|" > temp_quarto.yml
mv temp_quarto.yml _quarto.yml

# Update index.md
sed "s|title: \"Course Development Guidelines\"|title: \"${COURSE_TITLE}\"|" index.md > temp_index.md
mv temp_index.md index.md

# GitHub workflow and .gitignore
mkdir -p .github/workflows
$DL .github/workflows/publish_site.yml https://raw.githubusercontent.com/cambiotraining/quarto-course-template/main/.github/workflows/publish_site.yml
$DL .gitignore https://raw.githubusercontent.com/cambiotraining/quarto-course-template/main/.gitignore

# README.md
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
  - given-names: "FIX: Name"
    family-names: "FIX: Surname"
    affiliation: "FIX: Your Institution or Affiliation"
    website: "FIX: https://your.website.here"
    orcid: "FIX: https://orcid.org/0000-0000-0000-0000"
    alias: "FIX: edit author contribution roles"
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
    - part: "FIX: Section title"
      chapters:
        - materials/00-template.md
EOF

echo "Course template created successfully in $REPO_NAME directory."
