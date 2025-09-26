# Course Template Repository

This repository contains a template for our courses, which are built using [Quarto](https://quarto.org/docs/get-started/).


## Training Developers

See our [course template page](https://cambiotraining.github.io/quarto-course-template/materials.html) for guidelines on setup, how to render the course site, how files/directories are organised, and some of the conventions used for lesson content. 

----

## Maintainers (Bioinformatics Training Team)

### Starting a New Course Repository

- On your computer go to the directory where you want the new course directory to be created.
- Copy/paste the following code on your terminal, which will download and run a setup script for the new course ([code here](utils/setup_course.sh), if you want to examine it). The script will interactively ask you for the title of the course and the name for its repository. Based on this information, it will then create all the basic files needed to get you started. 
  
    ```bash
    # download script with either `wget` or `curl`
    if command -v wget &> /dev/null; then
      bash <(wget -qO- https://raw.githubusercontent.com/cambiotraining/quarto-course-template/refs/heads/main/utils/setup_course.sh)
    elif command -v curl &> /dev/null; then
      bash <(curl -sSL https://raw.githubusercontent.com/cambiotraining/quarto-course-template/refs/heads/main/utils/setup_course.sh)
    else
      echo "Error: Neither wget nor curl is available."
    fi
    ```

- Edit the `CITATION.cff` file, adding the details for each author (see [our docs for suggested author roles](https://cambiotraining.github.io/quarto-course-template/materials/03-authorship.html)).
- If you discussed the outline of the course with the training developers, then create the directory structure in `materials/` and even create some minimal files for them (these can be added to `materials/_chapters.yml`). Otherwise, the `materials/_chapters.yml` file includes a link to the `materials/00-template.md` as an example.
- Initialise the repository: 
  ```bash
  git init
  git add .github .gitignore *
  git commit -m "first commit"
  git branch -M main
  ```
- Create a new repository on GitHub, then before pushing, go to "Settings > Actions > General" and make sure the following two options are ticked:
  - Under "Actions permissions" select "Allow all actions and reusable workflows".
  - Under "Workflow permissions" (scroll down):
    - Select "Read and write permissions".
    - Tick "Allow GitHub Actions to create and approve pull requests".
- Add/push your files as you would normally do for a new repository. 
- After the first push, the site will be rendered to the `gh-pages` branch automatically. 
  This may take a while (you can check the "Actions" tab of the repository to monitor its progress). 
- Once the `gh-pages` branch has been created, go to the repository's "Settings > Pages" and select the `gh-pages` branch to render your pages. 


### Converting an existing repository

If you already have course materials using a different template and want to use this template instead, you will need to copy some files to your existing repository.  
This will vary depending on the specific template you were using, but the easiest might be to basically start from scratch. 
Here is a potential workflow:

- Follow the instructions above for starting a new repository, but **do not initialise it as a Git repository**.
- Copy your existing markdown/ipynb files to the `materials/` directory (and organise them into sub-directories if suitable).
- Edit the following files:
  - `materials/_chapters.yml` - adjust the layout of your sections.
  - `index.md` - adjust the content for the front page (you may have this content already, and just need to copy/paste it here).
  - `setup.md` - if you had instructions for installing software, copy them here.
- Test building the website with: `quarto render`. Your website homepage should be in `_site/index.html`. 
- Update the syntax used for exercises, callout boxes, tabsets, etc.
- Once everything is working on this directory, you can remove all the files from your existing repository and copy these files into it.  
  Make sure to **include hidden files** (`.github/` directory and `.gitignore` file).
- Push all the changes to GitHub and make sure that GitHub pages are being built from the `gh-pages` branch (you can adjust this in Settings if not). 


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

The styling of the course is controled by an extension (`cambiotraining/crit-format`), which gets updated automatically using a GitHub Action that runs monthly.
This way, if changes are made to the template, they propagate to all courses using it.

However, if you want to manually update the template extension (and the other extensions used), you can run the following commands:

```bash
quarto update --no-prompt mcanouil/quarto-iconify
quarto update --no-prompt quarto-ext/fontawesome
quarto update --no-prompt cambiotraining/crit-quarto-ext/callout-exercise
quarto update --no-prompt cambiotraining/crit-quarto-ext/crit-format
quarto update --no-prompt cambiotraining/crit-quarto-ext/citation-cff-parser
```
