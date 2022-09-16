# Course Template Repository

This repository contains a template for our courses, which are built using [Quarto](https://quarto.org/docs/get-started/).

**Training developers**: please only edit the files indicated in the instructions below. 
If you need help with the site configuration, please get in touch with us so we can revise our template. 

:warning: Please make sure to use Quarto version 1.2+. At the time of writing (2022-09-15) this is only available as a [pre-release version](https://quarto.org/docs/download/prerelease.html).


## Build the Site

To render the website locally, you can run `quarto render`.
Your local copy of the site will be saved in the `_site` folder - you can open the `index.html` file to open the local copy of your site.  

Note that the `_site` folder is local and not pushed to GitHub (it's been added to `.gitignore`). 
The public site is built automatically by GitHub Actions every time a new push is made.

Our [course template site](https://cambiotraining.github.io/quarto-course-template/) gives an example of how the course website will look like.


## Writing Materials

The materials can be written as plain markdown `.md`, Rmarkdown `.Rmd`, Quarto markdown `.qmd` or Jupyter notebooks `.ipynb` (see directory structure below).  
Read our [development guidelines](https://cambiotraining.github.io/quarto-course-template/materials/01-developer_guidelines.html) for further details and conventions when developing your content.


### Directory Structure

**Only edit the files in the `materials/` directory** of the repository.  
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
- If you want to organise the materials into sections, create a sub-directory in `materials/` for each section, and:
  - Create a file named `index.md` with a short description of the section's topic and the following YAML header at the top of the file:
      ```yml
      ---
      title: Section Title  # keep this concise
      order: 1  # the order in which this section should appear on the navbar
      ---
      ```
  - Your lesson markdown files can then be saved within the folder, as indicated above. 
- If you want to create slides using Quarto ([documentation](https://quarto.org/docs/presentations/)), please include them in a directory `materials/<section_folder>/slides/`. Follow the same conventions as for other files, with the YAML header including `title` and `order` properties. 


## Notes for Bioinformatics Training Team

### Starting a New Course Repository

- Use GitHub Importer to import the [template repository](https://github.com/cambiotraining/quarto-course-template) to a new one.
- Go to the settings of the repository and under "Actions > General" tick "Allow all actions and reusable workflows" and hit "Save".
- Make a local clone of the new repository.
- Clean the files for the new course:
  ```bash
  git rm materials/01-developer_guidelines.md
  git mv course-template.code-workspace $(basename $(pwd)).code-workspace
  git mv course-template.Rproj $(basename $(pwd)).Rproj
  quarto update extension --no-prompt .
  git add *
  git commit -m "tidy course repo skeleton"
  git push
  ```
- If you discussed the outline of the course with the training developers, then create the directory structure in `materials/` with the `index.md` files already present.

### Maintaining the Repository

**Clean-up frozen HTML files**

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

:warning: **Important:** :warning:  

- This is a history-destructive action, however no files should be deleted. Still, it's probably best to make a **backup of the repository** until you check the website renders correctly after the cleanup.  
- Do this when there is **no active development** of materials, because this will cause merge conflicts when other people pull from the repo. 
  Anyone working on the materials should probably **make a fresh clone** of the repository next time they want to do work on it. 


**Update course template**

If there are changes to our course template format (e.g. the CSS themes are updated), you can propagate these changes by running `quarto update extension .`.  
If you do this, you will need to re-render the whole website: 

```bash
git rm -r _freeze
quarto render
git add _freeze
git commit -m "fresh website render"
```

Note: you may want to purge the history of the `_freeze` directory after doing a full website re-render (see above).