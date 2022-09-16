---
title: Development Guidelines
order: 1
---

::: {.callout-tip}
## Learning Objectives

- Summarise the steps involved in contributing new materials and building a course website.
- Remember the required parts to be included in each section of the materials.
- Distinguish when to use callout boxes and the syntax used to create them.
- Understand the convention used for writing exercises, referencing figures and citing works.
- Remember the recommendations when using executable documents.
:::


## Introduction

This document includes information for writing materials for the Bioinformatics Training Facility, which is then built into a suitable website using Quarto.
We encourage you to use markdown-based documents (`.md`, `.Rmd` or `.qmd`), although Python Notebooks (`.ipynb`) are also supported[^1]. 

[^1]: Python Notebooks are great, and we have nothing against them in principle. But they are not very git-friendly: because they are complex JSON files with results embeded in the file, it makes it harder to see what content changed when a new commit is made.  
    
    However, if you prefer to develop your materials as Jupyter Notebooks, you can install the [`jupytertext` extension](https://jupytext.readthedocs.io/en/latest/).
    This will allow you to have synchronised `.qmd` and `.ipynb` files - so you can seamlessly work on your materials using the familiar notebook interface.

::: {.callout-tip}
One way to learn about the syntax used to develop materials is to look at the [source file for this page](https://github.com/cambiotraining/quarto-course-template/blob/main/materials/01-developer_guidelines.md). 
:::

To start, here is a brief list of syntax conventions we use:

- Headings start at level 2 (`##`).
- Exercises should be entitled using a level 3 (`###`) heading - see @sec-exercises section below.
- Code blocks should be [annotated with the language used](https://quarto.org/docs/authoring/markdown-basics.html#source-code), to enable syntax highlighting.
- There are several other markdown tricks that you can use (e.g. equations and _mermaid_ diagrams). See the [Quarto Markdown Basics](https://quarto.org/docs/authoring/markdown-basics.html) documentation for a reminder of these features.

We give further details about other features below, but the essential workflow when working on the materials is:

- Edit your markdown/notebook files in `materials/`.
- Run `quarto render` to build the site (open `_site/index.html` to preview your website locally).
- Add, commit and push the changes to the repository.


## Callout Boxes

Quarto has several [built-in callout boxes available](https://quarto.org/docs/authoring/callouts.html). 
You can use these to highlight particular content. 
Note that the colour scheme for our callout boxes is simplified relative to the original Quarto template. 

Here is an example of each box, with a short description of what you may want to use it for:

::: {.callout-tip}
This is a `.callout-tip`, which is used for _learning objectives_, _key points_ and _exercise answers_ (each of these is detailed below).
:::

::: {.callout-note}
This is a `.callout-note`, which you can use to highlight "bonus" tips-and-tricks that complement your materials.

These can be thought of as non-essential parts of the materials, which may not be covered in a live workshop. 
The more muted colour of this box conveys that idea.
:::

::: {.callout-important}
This is a `.callout-important`, which can be used to highlight important notes that complement the materials. 

This can be thought of as a more essential idea/concept that is mentioned specifically during a live workshop.
:::

::: {.callout-warning}
This is a `.callout-warning`, which can be used to highlight common "gotchas" such as unexpected behaviours of the software being used or common mistakes users can make. 
:::

::: {.callout-caution}
This is a `.callout-caution`, which at the moment is only used to highlight readers when materials are under development. 
You should rarely have to use these. 
:::


## Learning Objectives

We advise that every lesson starts with a set of "Learning Objectives" included in a  `.callout-tip` box:

```md
::: {.callout-tip}
## Learning Objectives

- List skills and concepts that learners should grasp after this lesson.
- See the box at the beggining of this document as an example.
```

By convention we tend to use an active tense. 
[Bloom's taxonomy](https://cft.vanderbilt.edu/guides-sub-pages/blooms-taxonomy/) may give you ideas of active verbs to use. 


## Key Points

Equally, we advise that every lesson ends with a level 2 section named "Summary" with a set of "Key Points", which summarise the main concepts covered in the lesson:

```md
::: {.callout-tip}
## Key Points

- List key concepts covered in the lesson.
- See the bottom of this document as an example.
```

This can be thought of as a "cheatsheet" for that lesson, if the user just wanted to quickly remind themselves about the lesson content, they should be able to do so from this section.


## Exercises {#sec-exercises}

By convention, we make the exercises a level 3 header named "Exercise: short description". 
This makes it easier to navigate to from the table of contents on the right, which is useful  during a workshop. 
We make use of a collapsible callout box to make the answers hidden by default. 

Here is an example of how the exercise should look at the end (the answer shows the syntax skeleton for an exercise).

### Exercise: How to Write an Exercise

What do we use to write an answer to the exercise?

::: {.callout-tip collapse=true}

## Answer

We use a collapsible `.callout-tip` named "Answer".  
Here is a code snippet for a full exercise:

  ```md
  ### Exercise: Short Description

  Question here.

  ::: {.callout-tip collapse=true}
  ## Answer

  Answer here.
  :::
  ```

:::


## Figures

Figures should be included in the document as: 

```md
![Figure Legend](link_to_figure_file_or_url){fig-alt="Alternative text"}
```

The **figure legend** should be used to explain the figure content and link to the source of the image, where relevant. 
The **alternative text** is for accessibility purposes and should provide with a short description of what the image portrais (e.g. for individuals using a screen reader).  
There are more advanced figure layouts possible, see the [Quarto Figures documentation](https://quarto.org/docs/authoring/figures.html) to learn more. 

For **image files**, we encourage you to do things in this order:

- If the image is available online (e.g. HTML of a paper) link to the URL of the image rather thank keep a copy in the repository. Make sure to link to the image source in the figure legend.
- If it's a diagram, use a program such as [Inkscape](https://inkscape.org/) to produce a SVG file (these are text-based files, more friendly for version control).
- Otherwise save the figure as a PNG. 

For **saving** and **naming** images: 

- Save images in `materials/<section_folder>/images` (if your materials don't have sections save it in `materials/images`).  
- Use short, but descriptive, names for your images. 
- Consider adding a common prefix to all images from a particular lesson file. For example `rstudio_interface.png` and `rstudio_new_project.png` could be used to name images in a lesson explaining how to use the RStudio IDE.


## References

Although [Quarto supports citations from BibTeX files](https://quarto.org/docs/authoring/footnotes-and-citations.html#citations), we advise that you keep things simple and simply cite work as _First Author et al. (Year)_, with a link to the relevant publication.  
For example: 

> The `DESeq2` package is commonly used for differential gene expression analysis ([Love et al. 2014](https://doi.org/10.1186/s13059-014-0550-8)).


## Executable Documents (`.Rmd` and `.qmd`)

If you are developing materials using _RMarkdown_ or _Quarto Markdown_, see the options you can use for your code chunks in the Quarto documentation for the [Jupyter](https://quarto.org/docs/reference/cells/cells-jupyter.html) and the [Knitr](https://quarto.org/docs/reference/cells/cells-knitr.html) engines.  
If you use Jupyter Notebooks, please use [`jupytext`](https://jupytext.readthedocs.io/en/latest/) to keep synchronised `.qmd` and `.ipynb` files (`.ipynb` are not pushed to the repo).

Here are some recommendations:

- Add alternative text to code chunks producing plots, for accessibility purposes. 
  You can do this by adding the `#| fig-alt` cell option to your chunk (see documentation pages linked above). 
- To avoid unecessary computations (and save time!), by default only files that were modified are re-rendered when running `quarto render`. 
  A copy of the computed files (e.g. PNG of plots) are saved in the directory `_freeze`.
  Please **run `quarto render` and push the `_freze` directory** when you make changes to your code.  
- If you're using stochastic algorithms in your code (e.g. sampling functions) please **set a seed** at the start of the document. 
  This will avoid unnecessary changes in the rendered output files.



## Summary

::: {.callout-tip}
## Key Points

- Callout boxes can be used to highlight different types of content the materials. The main ones are:
  - `{.callout-tip}` for learning objectives, key points and exercise answers.
  - `{.callout-note}` for non-essential "bonus" tips-and-tricks.
  - `{.callout-important}` for essential concepts that complement the main narrative.
  - `{.callout-warning}` for common mis-conceptions, unexpected behaviour or common errors. 
- Every materials page should start with a set of _Learning Objectives_ and end with a set of _Key Points_. 
- Exercises are written under a level 3 heading, and the answers written as a collapsible box (`{.callout-tip collapse=true}`).
- Figures should always include a _figure legend_ and _alternative text_. 
  - Images can directly link to a URL, otherwise saved as SVG or PNG files.
  - Files should be saved in `materials/<section_folder>/images/`. 
  - Optionally file names can share a prefix if they relate to the same topic. 
- Other things to consider are:
  - Code chunk options available in executable documents (`.Qmd`, `.Rmd` and `.ipynb`).
  - References to publications/software can be done with a direct link to the source.
:::