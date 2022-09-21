---
title: Course Rendering
---

::: {.callout-tip}
## Learning Objectives

- Setup the required software to work on the materials.
- Render and preview the course website locally.
- Understand file/directory organisation for course materials.
- Remember how the navigation bar for materials is configured.
:::

## Introduction

In the sections below, we detail how files/directories are organised and how you can build the course website locally.  
**Please only edit the files indicated in the instructions below.** 
If you need help with the site configuration, please get in touch with us so we can revise our template. 

If you just need a reminder, here is a TLDR-summary:

- Clone the repository `git clone <repo>` (or run `git pull` to update your local clone).
- Write materials in the markdown/notebook files in the `materials/` directory.
  You can organise files in sub-directories (e.g. if they are part of a top-level section).
- Edit the `materials/_sidebar.yml` file to adjust the sidebar layout.
- Build the site locally with `quarto render`. Open the file `_site/index.html` to view your changes.
- Add, commit and push changes to the repository.  
  If using executable documents (`.Rmd`/`.qmd`), make sure to also push the `_freeze` directory.

Make sure to also read our [**content development guidelines**](02-content_guidelines.md).


## Setup

- Download and install [Quarto](https://quarto.org/docs/get-started/). 
  - If you are developing materials using executable `.qmd` documents, it is recommendded that you also install the extensions for your favourite IDE.
- If you are developing materials using **JupyterLab** or **Jupyter Notebooks**, please install [Jupytext](https://jupytext.readthedocs.io/en/latest/install.html).
  - Use the [paired notebook](https://jupytext.readthedocs.io/en/latest/paired-notebooks.html) feature to have synchronised `.ipynb`/`.qmd` files. Only `.qmd` files should be pushed to the repository (`.ipynb` files have been added to `.gitignore`).
- Clone the course repository with `git clone`.

You're now ready to start editing the course content.  
If you use either _VS Code_ or _RStudio_, we've included `*.code-workspace` and `*.Rproj` files that you can use to open your project in those programs, respectively. 


## Build the Site

After a fresh clone, you may want to render the website locally first, to check that Quarto is setup correctly. 
You can also follow this workflow thereafter, every time you edit the materials. 

- Run `quarto render` to built the site. 
- The local copy of the site will be saved in the `_site` folder - open the `index.html` file to open the local copy of your site.  
  - Note that the `_site` folder is local and not pushed to GitHub (it's been added to `.gitignore`). 
    The public site is built automatically by GitHub Actions every time a new push is made.

The website you are reading right now gives an example of how the course website will look like.


## File Organisation

The materials can be written as plain markdown `.md`, Rmarkdown `.Rmd`, Quarto markdown `.qmd` or Jupyter notebooks `.ipynb`. 
As mentioned in [Setup]{@setup}, if you are using Jupyter Notebooks, make sure to use Jupytext to have paired `.ipynb`/`.qmd` files.

With the exception of `index.md`, **only edit the files in the `materials/` directory** of the repository.  
The following conventions should be used: 

- Please name your files with a two-digit numeric prefix. For example `01-first_lesson.md`. 
  Use relatively descriptive names for the files (unlike this example!).
- _Always_ include the following YAML header, at the top of each file:
  ```yml
  ---
  title: Lesson Title # keep this concise
  ---
  ```
  This title will appear both on the navigation bar on the left and as the title of the page. 
  For example, the page you are viewing now has `title: Course Rendering`.
- Organise your files into sub-directories, if they are all part of a logical section of materials. For example:
  ```
  course_folder
    |_ materials
          |_ section1
          |    |_ 01-first_lesson_in_section1.md
          |    |_ 02-second_lesson_in_section1.md
          |_ section2
               |_ 01-first_lesson_in_section2.md
               |_ 02-second_lesson_in_section2.md
  ```
- If you want to create slides using Quarto ([documentation](https://quarto.org/docs/presentations/)), please include them in a directory `materials/<section_folder>/slides/`.


## Sidebar

The navigation bar (or sidebar) on the left is configured from the `materials/_sidebar.yml` file.  
Here is how the YAML file would look like for the example directory structure shown earlier:

```yml
website:
  sidebar:
    - title: "Materials"
      # Training Developers - only edit the sections below
      - section: "One Section"
        contents:
          - materials/section1/01-first_lesson_in_section1.md
          - materials/section1/02-second_lesson_in_section1.md
      - section: "Another Section"
        contents:
          - materials/section2/01-first_lesson_in_section2.md
          - materials/section2/02-second_lesson_in_section2.md
```

You can see more details about how to configure sidebar on the [Quarto documentation](https://quarto.org/docs/websites/website-navigation.html#side-navigation).  
However, please make sure to leave the first 3 lines of the YAML unchanged. 

## Summary

::: {.callout-tip}
## Key Points

- Course websites are built using [Quarto](https://quarto.org/docs/get-started/). 
- The website can be built using the command `quarto render`. 
  The website can be previewed from the file `_site/index.html`.
- Materials can be written in markdown-based documents (`.md`, `.Rmd`, `.qmd`) or Python notebooks (`.ipynb`). 
  For the latter the Jupytext package should be used to keep synchronised `.qmd` and `.ipynb` files. 
- Course materials' files should be saved in the `materials/` directory and named using a numeric prefix `00-` for friendly ordering in the filesystem. 
  Files can be further organised in sub-directories if they are logically grouped by sections. 
- The navigation sidebar can be configured from the `materials/_sidebar.yml` file. 
:::
