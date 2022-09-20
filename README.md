# Course Template Repository

This repository contains a template for our courses, which are built using [Quarto](https://quarto.org/docs/get-started/).

:warning: Please make sure to use Quarto version 1.2+. At the time of writing (2022-09-15) this is only available as a [pre-release version](https://quarto.org/docs/download/prerelease.html).


## Training Developers

In the sections below, we detail how files/directories are organised and how you can build the course website locally.  
**Please only edit the files indicated in the instructions below.** 
If you need help with the site configuration, please get in touch with us so we can revise our template. 

If you just need a reminder, here is a TLDR-summary:

- Clone the repository `git clone <repo>` (or run `git pull` to update your local clone).
- Write materials in the markdown/notebook files in the `materials/` directory.
  - Create sub-directories for higher-level sections.
- Build the site locally with `quarto render`. Open the file `_site/index.html` to view your changes.
- Add, commit and push changes to the repository.
  - If using executable documents (`.Rmd`/`.qmd`), make sure to also push the `_freeze` directory.

Make sure to also read our [**content development guidelines**](https://cambiotraining.github.io/quarto-course-template/materials/01-developer_guidelines.html).


### Setup

- Download and install [Quarto](https://quarto.org/docs/get-started/). :warning: Please make sure to use Quarto version 1.2+. At the time of writing (2022-09-15) this is only available as a [pre-release version](https://quarto.org/docs/download/prerelease.html).
  - If you are developing materials using executable `.qmd` documents, it is recommendded that you also install the extensions for your favourite IDE.
- If you are developing materials using **JupyterLab** or **Jupyter Notebooks**, please install [Jupytext](https://jupytext.readthedocs.io/en/latest/install.html).
  - Use the [paired notebook](https://jupytext.readthedocs.io/en/latest/paired-notebooks.html) feature to have synchronised `.ipynb`/`.qmd` files. Only `.qmd` files should be pushed to the repository (`.ipynb` files have been added to `.gitignore`).
- Clone the course repository with `git clone`.

You're now ready to start editing the course content.  
If you use either _VS Code_ or _RStudio_, we've included `*.code-workspace` and `*.Rproj` files that you can use to open your project in those programs, respectively. 


### Build the Site

After a fresh clone, you may want to render the website locally first, to check that Quarto is setup correctly. 
You can also follow this workflow thereafter, every time you edit the materials. 

- Run `quarto render` to built the site. 
- The local copy of the site will be saved in the `_site` folder - open the `index.html` file to open the local copy of your site.  
  - Note that the `_site` folder is local and not pushed to GitHub (it's been added to `.gitignore`). 
    The public site is built automatically by GitHub Actions every time a new push is made.

Our [course template site](https://cambiotraining.github.io/quarto-course-template/) gives an example of how the course website will look like.


### Writing Materials

The materials can be written as plain markdown `.md`, Rmarkdown `.Rmd`, Quarto markdown `.qmd` or Jupyter notebooks `.ipynb`. 
As mentioned in [Setup](#setup), if you are using Jupyter Notebooks, make sure to use Jupytext to have paired `.ipynb`/`.qmd` files.

Below we detail how files/directories are organised.  
Additionally, make sure to read our [**development guidelines**](https://cambiotraining.github.io/quarto-course-template/materials/01-developer_guidelines.html) for further details and conventions when developing your content.

With the exception of `index.md`, **only edit the files in the `materials/` directory** of the repository.  
The "Materials" section of the website will have a navigation bar on the left, which is automatically created from the files in this directory.  
The following conventions should be used: 

- Please name your files with a two-digit numeric prefix. For example `01-first_lesson.md`. 
- At the top of each file, always include the following YAML header:
  ```yml
  ---
  title: Lesson Title # keep this concise
  order: 1 # the order in which this should appear on the navbar
  ---
  ```
- If you want to organise the materials into higher-level sections, create a sub-directory in `materials/` for each section, and:
  - Create a file named `index.md` with a short description of the section's topic and the following YAML header at the top of the file:
      ```yml
      ---
      title: Section Title  # keep this concise
      order: 1  # the order in which this higher-level section should appear on the navbar
      ---
      ```
  - Your lesson markdown files can then be saved within the folder, as indicated above. 
- If you want to create slides using Quarto ([documentation](https://quarto.org/docs/presentations/)), please include them in a directory `materials/<section_folder>/slides/`. Follow the same conventions as for other files, with the YAML header including `title` and `order` properties. 

----

## Maintainers (Bioinformatics Training Team)

### Starting a New Course Repository

- Create a new _empty_ directory for the course. 
- Cd into that directory and run: `quarto use template --no-prompt cambiotraining/quarto-course-template`.
- Clean the files for the new course:
  ```bash
  # clean materials directory
  rm materials/01-developer_guidelines.md
  # rename VS Code and Rproj files
  mv course-template.code-workspace $(basename $(pwd)).code-workspace
  mv course-template.Rproj $(basename $(pwd)).Rproj
  # fix path to logos
  sed 's/_extensions/_extensions\/cambiotraining/g' _quarto.yml > _temp.yml
  rm _quarto.yml; mv _temp.yml _quarto.yml
  ```
- If you discussed the outline of the course with the training developers, then create the directory structure in `materials/` with the `index.md` files already present.
- Create a new repository on GitHub and then push your files as you would normally do. 


### Converting an existing repository

If you already have course materials using a different template and want to use this template instead, you will need to copy some files to your existing repository.  
This will vary depending on the specific template you were using, but here are some general guidelines:

- Install the theme template using: `quarto install extension cambiotraining/quarto-course-template`.
- Update the following files in your repository, based on the files from this repository:
  - `_quarto.yml` - copy this file to your repository and adjust the path to `favicon` and `logo` to be `_extensions/cambiotraining/...etc...`. 
  - `index.md` - if you already had such a file, make sure to copy its content to the template provided here. 
  - `materials.md` - you should copy this file as is. 
  - `setup.md` - if you already had instructions for software installation, make sure to copy them to this file. 
  - Create a directory named `materials/` for all your materials:
    - If you were using sections, create a sub-directory for each section (see [Writing Materials](#writing_materials) section above).
    - Move your markdown files to the relevant materials directory.
- Copy the github actions directory `.github/workflows/`. If you had previous actions make sure to remove them. 
- Test building the website with: `quarto render`. Your website homepage should be in `_site/index.html`. 
- Push all the changes to GitHub. Make sure that GitHub pages are being built from the `gh-pages` branch. 


### Maintaining the Repository

#### Clean-up frozen HTML files

We use the `_freeze` feature of Quarto to ensure that the site builds successfully (without the need to manage complicated software dependencies).
With time, this directory may become large and it might be a good idea to purge its history (as it's not really needed for versioning).
We can use the [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) to retain only the latest commit of those files.  
You can easily install BFG with `conda install -c conda-forge bfg` or `brew install bfg`.

To purge the `_freeze` history, make a **fresh clone** of the repository and run:

```bash
bfg --delete-folders _freeze
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push --force
```

After this, the `_freeze` directory will have no history (only the latest commit). 
This should shrink the repository size, especially for courses with lots of plotting output.

:warning: **Important:**

- This is a history-destructive action, however no files should be deleted. Still, it's probably best to make a **backup of the repository** until you check the website renders correctly after the cleanup.  
- Do this when there is **no active development** of materials, because this will cause merge conflicts when other people pull from the repo. 
  Anyone working on the materials should probably **make a fresh clone** of the repository next time they want to do work on it. 


#### Update course template

If there are changes to our course template format (e.g. the CSS themes are updated), you can propagate these changes by running `quarto update extension .`.  

:interrobang: Note: not sure that a fresh re-render is actually needed - the `_freeze` folder doesn't hold the `html` files themselves, only the output from code chunks (such as `.png` files, etc.). This needs to be double-checked, but leaving the instructions below for reference.

If you do this, you will need to re-render the whole website: 

```bash
git rm -r _freeze
quarto render
git add _freeze
git commit -m "fresh website render"
```

Note: you may want to purge the history of the `_freeze` directory after doing a full website re-render (see above).