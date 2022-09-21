# Course Template Repository

This repository contains a template for our courses, which are built using [Quarto](https://quarto.org/docs/get-started/).


## Training Developers

See our [course template page](https://cambiotraining.github.io/quarto-course-template/materials.html) for guidelines on setup, how to render the course site, how files/directories are organised, and what the conventions used for lesson content. 

----

## Maintainers (Bioinformatics Training Team)

### Starting a New Course Repository

- Create a new _empty_ directory for the course. 
- Cd into that directory and run: `quarto use template --no-prompt cambiotraining/quarto-course-template`.
- Tidy the files for the new course (you can copy/paste this whole code block):
  ```bash
  # clean materials directory
  rm materials/01-developer_guidelines.md
  # rename VS Code and Rproj files
  mv course-template.code-workspace $(basename $(pwd)).code-workspace
  mv course-template.Rproj $(basename $(pwd)).Rproj
  # fix path to logos
  sed 's/_extensions/_extensions\/cambiotraining/g' _quarto.yml > _temp.yml
  rm _quarto.yml; mv _temp.yml _quarto.yml
  # copy github action
  mkdir -p .github/workflows/
  wget -O .github/workflows/publish_site.yml https://raw.githubusercontent.com/cambiotraining/quarto-course-template/main/.github/workflows/publish_site.yml
  # copy gitignore
  wget -O .gitignore https://raw.githubusercontent.com/cambiotraining/quarto-course-template/main/.gitignore
  ```
- Create a README, adjusting the heading to match the course name and add any other information you think is suitable:
  ```bash
  echo "# Course Name
  
  See our [template page](https://cambiotraining.github.io/quarto-course-template/materials.html) for guidelines about editing the materials." > README.md
  ```
- If you discussed the outline of the course with the training developers, then create the directory structure in `materials/` with the `index.md` files already present.
- Initialise the repository: 
  ```bash
  git init
  git add .github/ .gitignore *
  git commit -m "first commit"
  git branch -M main
  ```
- Create a new repository on GitHub, and then add/push your files as you would normally do for a new repository. 
- After the first push, the site will be rendered to the `gh-pages` branch automatically. 
  This may take a while (you can check the "Actions" tab of the repository to monitor its progress). 
  Once the `gh-pages` branch has been created, go to the repository's "Settings > Pages" and select the `gh-pages` branch to render your pages. 


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

If there are changes to our course template format (e.g. the CSS themes are updated), you can propagate these changes by running `quarto update extension cambiotraining/quarto-course-template`.  

:interrobang: Note: not sure that a fresh re-render is actually needed - the `_freeze` folder doesn't hold the `html` files themselves, only the output from code chunks (such as `.png` files, etc.). This needs to be double-checked, but leaving the instructions below for reference.

If you do this, you will need to re-render the whole website: 

```bash
git rm -r _freeze
quarto render
git add _freeze
git commit -m "fresh website render"
```

Note: you may want to purge the history of the `_freeze` directory after doing a full website re-render (see above).