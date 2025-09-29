---
title: Adapting our template
---

If you want to use our template for your own course, you will likely want to adapt it to your branding and needs.

This page describes how you can copy this template and adapt it to your needs.

:::{.callout-tip}
#### Citing us

If you use this template for your course, please cite us as indicated on the [home page](../index.md).
:::

## Copying the template

One possibility is to fork our repository, but this will create a link to our repository and keep all its history, which may not be desirable.
Instead, we suggest that you copy the template without keeping any history, so you can start fresh.

1. Make a clone of our repository:

    ```bash
    git clone https://github.com/cambiotraining/quarto-course-template.git genetics-course-template
    cd genetics-course-template
    ```

2. Remove the `.git` directory to remove the history:

    ```bash
    rm -rf .git
    ```

3. Initialise a new repository:

    ```bash
    git init
    git add .
    git commit -m "Initial commit, copy of CRIT template"
    ```

## Create a new GitHub repository

We will use the following as an example:

- Username: `gencam`
- Our new template repository is called `genetics-course-template`.

But please adapt the commands to your own username and chosen repository name.

1. **Create a new repository on GitHub** called `genetics-course-template` (do not initialise it with a `README`, `.gitignore` or license).
2. Go to **Settings > Actions** and:
   - Select “Allow all actions and reusable workflows”
   - Select “Read and write permissions”
   - Tick “Allow GitHub Actions to create and approve pull requests”
3. **Push the code** to the remote repository.

    ```bash
    git branch -M main
    git remote add origin https://github.com/gencam/genetics-course-template.git
    git push -u origin main
    ```

## Publish the site

- Go to GitHub and open the "**Actions**" tab
  - An action called "**Deploy**" should be running or have finished running after you push.
  - Confirm that the action finished successfully.
  - Once it finishes a new **gh-pages** branch is created.
- Go to "**Settings > Pages**", and under "**Build and deploy**":
  - Source: "**Deploy from a branch**"
  - Branch: "**gh-pages**" > Save
- The page should publish to `gencam.github.io/genetics-course-template/` (it may take a few minutes to appear).

## Customising the theme

The template used by us uses a custom theme with our colours, logo, and fonts.
If you want to adapt it to your own branding, you will need to adapt a CSS file and a few other files.

### Add your own theme

- In the `_quarto.yml` file, replace `format: crit-format-html` with (feel free to change some of the options as preferred, but note that the `theme.scss` needs to match the file set in the next step): 

    ```yaml
    format:
      html:
        theme: [default, genetics-theme/theme.scss]
        toc: true
        number-sections: true
        number-depth: 3
        code-link: true
        code-copy: true
        lightbox: true
    ```

- Create the `genetics-theme/` directory and copy our theme into it:

  ```bash
  mkdir genetics-theme
  cp _extensions/cambiotraining/crit-format/theme.scss genetics-theme/theme.scss
  ```

- Edit the newly copied `theme.scss` file to adapt it to your branding (colours, fonts, logo, etc).
- Edit the rest of `_quarto.yml` to use your own title, logo, link to social media, and other details.
- Test building the site with `quarto render` and check that everything looks as expected.

### Remove CRIT branding

Our branding is included as an extension, which you can now remove from your copy.

- Uninstall the extension:

    ```bash
    quarto remove cambiotraining/crit-format
    ```

- Remove the github action that updates our extensions automatically:

    ```bash
    rm .github/workflows/update_extensions.yml
    ```

- Test the local rendering again: `quarto render`

If everything looks good, push the changes to GitHub and check that the site builds correctly 🚀

Remember to see other sections of this documentation to adapt the content of the course to your needs.
