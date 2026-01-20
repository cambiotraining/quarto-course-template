---
title: Adapting our template
---

:::{.callout-tip}
#### Citing us

If you use this template for your course, please cite us as indicated on the [home page](../index.md).
:::

If you want to use our template for your own course, you will likely want to adapt it to your own branding and requirements..

This page explains how to copy the template and customise it for your course.

In the examples below we use:

- `my-course` as the new repository name
- `yourusername` as your GitHub username

Make sure to adapt the commands to your own username and chosen repository name.

## Copying the template

We recommend **copying the template without keeping its history** rather than forking. This gives you a clean slate without maintaining a link to the original repository.

1. Clone the template repository into a new local directory:

  ```bash
  git clone https://github.com/cambiotraining/quarto-course-template.git my-course
  cd my-course
  ```

2. Remove the `.git` directory to start without the repository's history:

  ```bash
  rm -rf .git
  ```

## Customising the theme

Before creating your own repository, update the template locally to match your branding.

### Add your own theme

- In the `_quarto.yml` file, replace `format: crit-format-html` with:

  ```yaml
  format:
    html:
    theme: [default, my-theme/theme.scss]
    toc: true
    number-sections: true
    number-depth: 3
    code-link: true
    code-copy: true
    lightbox: true
  ```

- Create the `my-theme/` directory and copy the template theme files:

  ```bash
  mkdir my-theme
  cp _extensions/cambiotraining/crit-format/theme.scss my-theme/theme.scss
  ```

- Edit `my-theme/theme.scss` to adjust colours, fonts, and logos to match your branding.
- Update the rest of `_quarto.yml` with your title, logo, social media links, and other details.

### Remove CRIT branding

- Remove the CRIT extension from your project:

  ```bash
  quarto remove cambiotraining/crit-format
  ```

- Remove the GitHub Actions workflow that updates CRIT extensions:

  ```bash
  rm .github/workflows/update_extensions.yml
  ```

### Test locally

Test the site build locally before proceeding:

```bash
quarto render
```

Check that the site renders correctly with your own branding.

## Initialise a new Git repository

Once customisation is complete, initialise a fresh Git repository:

```bash
git init
git add .
git commit -m "Initial commit: customised course template"
```

## Create a GitHub repository and push

1. **Create a new repository on GitHub** called `my-course` (do not initialise it with a README, `.gitignore`, or licence).

2. Go to **Settings > Actions** and:
   - Select "Allow all actions and reusable workflows"
   - Select "Read and write permissions" (required for the deployment workflow)
   - Tick "Allow GitHub Actions to create and approve pull requests"

3. **Push your code** to GitHub:

  ```bash
  git branch -M main
  git remote add origin https://github.com/yourusername/my-course.git
  git push -u origin main
  ```

## Publish the site

- Go to GitHub and open the **Actions** tab.
  - An action called **Deploy** should run after your push.
  - Confirm the action completes successfully.
  - A new **gh-pages** branch is created once complete.

- Go to **Settings > Pages** and under **Build and deploy**:
  - Source: "Deploy from a branch"
  - Branch: "gh-pages" > Save

- Your site publishes to `yourusername.github.io/my-course/` (may take a few minutes to appear).

Remember to check other sections of this documentation to customise the course content to your needs.
