---
title: Course Rendering
---

::: {.callout-tip}
## Learning Objectives

- Setup the required software to work on the materials.
- Render and preview the course website locally.
- Understand file/directory organisation for course materials and course files.
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
- Edit the `materials/_chapters.yml` file to adjust the chapter layout.
- Data files and/or scripts for the participants can be saved in `course_files/{data,scripts}`, respectively.
  - **Note:** only store data files in the repository if they are small and text-based. 
    Otherwise, we will keep a copy of the data files on _Dropbox_.
- Build the site locally with `quarto render`. Open the file `_site/index.html` to view your changes.
- Add, commit and push changes to the repository.  
  If using executable documents (`.Rmd`/`.qmd`), make sure to also push the `_freeze` directory.

Make sure to also read our [**content development guidelines**](02-content_guidelines.md).


## Setup

- Download and install [Quarto](https://quarto.org/docs/get-started/). 
  - If you are developing materials using executable `.qmd` documents, it is recommended that you also install the extensions for your favourite IDE.
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

There are three things that you may edit: 

- Files in `materials/` - this contains all the markdown/notebook files with the written materials (rendered on the site).
- Files in `course_files/` - this contains the files that participants will have on their training machines.
- The `index.md` file - this is the homepage for the course. 

### Course Materials

The materials can be written as plain markdown `.md`, Rmarkdown `.Rmd`, Quarto markdown `.qmd` or Jupyter notebooks `.ipynb`. 
As mentioned in [Setup], if you are using Jupyter Notebooks, make sure to use Jupytext to have paired `.ipynb`/`.qmd` files.

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
- Optionally, you can organise your files into sub-directories, if they are all part of a logical section of materials. This is up to personal preference. For example:
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

### Course Files & Data

When we run a workshop, participants will have all the necessary files for the course on the training computers.  
Generally, there are two types of files we may want to distribute to the participants:

- `scripts` - any scripts for exercises or examples we want to run interactively during the course.
- `data` - any data files (CSV, FASTQ, etc.) that are used.

These course files should be in a directory called `course_files` and specify all the paths in the materials relative to that. 
So, this will be the directory structure you end up with: 

```
top_level_course_directory
  |_ course_files
  |     |_ data
  |     |_ scripts
  |_ materials
        |_ ... Markdowns as detailed earlier
```

As you develop the materials and identify suitable data for the workshop, you can place it in the directory `course_files/data/` (within that you can set any directory structure you want) and scripts for the participants in `course_files/scripts` (again you can organise this in any way you think is useful). 

However, as a rule, **only scripts should be pushed to the repository**.  
Generally, we do not keep data in the repository, unless the files are text-based and/or small. 
We keep the data files on our _Dropbox_, so anyone can download them from a stable link (including with `wget`/`curl`).

::: {.callout-tip}
## Flexible course file structure

What's given here is our recommended convention but, if you think your course files would benefit from a different file structure, please let us know. 

Equally, if you don't need to distribute scripts or data with your course (e.g. if your course is live-coded and data is downloaded from a public URL), then leave these directories empty as they are.
:::

### Homepage

The `index.md` file (at the root of the directory) will become the homepage for the course.  
This file can be edited towards the end of the material development, following the instructions given there. 
You can see an example on the [homepage](../index.md) of this website.


## Sidebar

The navigation bar on the left is configured from the `materials/_chapters.yml` file.  
Here is how the YAML file would look like for the example directory structure shown earlier:

```yml
book:
  chapters:
    - part: "One Section"
      chapters:
        - materials/01-first_chapter_in_section1.md
        - materials/02-second_chapter_in_section1.md
    - part: "Another Section"
      chapters:
        - materials/03-first_chapter_in_section2.md
        - materials/04-second_chapter_in_section2.md
```

## Summary

::: {.callout-tip}
## Key Points

- Course websites are built using [Quarto](https://quarto.org/docs/get-started/). 
- The website can be built using the command `quarto render`. 
  The website can be previewed from the file `_site/index.html`.
- Materials can be written in markdown-based documents (`.md`, `.Rmd`, `.qmd`) or Python notebooks (`.ipynb`). 
  For the latter the Jupytext package should be used to keep synchronised `.qmd` and `.ipynb` files. 
- Files for course materials files should be saved in the `materials/` directory and named using a numeric prefix `00-` for friendly ordering in the filesystem. 
  - Files can be optionally be organised in sub-directories if they are logically grouped by sections. 
- Files to be shared with the participants (scripts and/or data) should be saved in `course_files`.  
  Generally, only `course_files/scripts` are pushed to the repository, and we will keep a copy of the data files on _Dropbox_.
- The navigation sidebar can be configured from the `materials/_chapters.yml` file. 
:::
