---
title: Content Guidelines
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

This document includes information for writing materials for the Bioinformatics Training Facility, which is then built into a website using Quarto.
We encourage you to use markdown-based documents (`.md`, `.Rmd` or `.qmd`), although Python Notebooks (`.ipynb`) are also supported[^1]. 

[^1]: Python Notebooks are great, and we have nothing against them in principle. But they are not very git-friendly: because they are complex JSON files with results embeded in the file, it makes it harder to see what content changed when a new commit is made.  
    
    However, if you prefer to develop your materials as Jupyter Notebooks, you can install the [`jupytertext` extension](https://jupytext.readthedocs.io/en/latest/).
    This will allow you to have synchronised `.qmd` and `.ipynb` files - so you can seamlessly work on your materials using the familiar notebook interface.

::: {.callout-tip}
One way to learn about the syntax used to develop materials is to look at the [source file for this page](https://github.com/cambiotraining/quarto-course-template/blob/main/materials/02-content_guidelines.md). 
:::

To start, here is a brief list of syntax conventions we use:

- Headings start at level 2 (`##`).
- Exercises should be entitled using a level 3 (`###`) heading - see [Exercises](#sec-exercises) section for details.
- Code blocks should be [annotated with the language used](https://quarto.org/docs/authoring/markdown-basics.html#source-code), to enable syntax highlighting.
- There are several other markdown tricks that you can use (e.g. equations and _mermaid_ diagrams). See the [Quarto Markdown Basics](https://quarto.org/docs/authoring/markdown-basics.html) documentation for a reminder of these features.

We give further details about other features below, but the essential workflow when working on the materials is:

- Edit your markdown/notebook files in `materials/`.
- Run `quarto render` to build the site (open `_site/index.html` to preview your website locally).
- Add, commit and push the changes to the repository.

If you need a reminder of the technical setup for course development, go back to the [Course Rendering](01-render_guidelines.md) page.


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
### Learning Objectives

- List skills and concepts that learners should grasp after this lesson.
- See the box at the beggining of this document as an example.
:::
```

By convention we tend to use an active tense. 
[Bloom's taxonomy](https://cft.vanderbilt.edu/guides-sub-pages/blooms-taxonomy/) may give you ideas of active verbs to use. 


## Key Points

Equally, we advise that every lesson ends with a level 2 section named "Summary" with a set of "Key Points", which summarise the main concepts covered in the lesson:

```md
::: {.callout-tip}
### Key Points

- List key concepts covered in the lesson.
- See the bottom of this document as an example.
```

This can be thought of as a "cheatsheet" for that lesson, if the user just wanted to quickly remind themselves about the lesson content, they should be able to do so from this section.


## Exercises {#sec-exercises}

By convention, we include exercises at the end of each chapter under a level 2 header named "Exercises". 
This makes it easier to navigate to from the table of contents on the right, which is useful during a workshop. 
Within this section we then include one or more exercises using the bespoke `:::{.callout-exercise}` and make use of a collapsible callout box to make the answers hidden by default. 

Here is an example of how the exercise should look at the end (the answers show the syntax skeleton for an exercise).

:::{.callout-exercise}
### Write an exercise

What do we use to write an answer to the exercise?

::: {.callout-answer}

We use the bespoke `.callout-answer`, which is collapsed by default.
Here is a code snippet for a full exercise:

  ```md
  ::: {.callout-exercise}
  ### Short Description

  Question here.

  ::: {.callout-answer}
  Answer here.
  :::
  :::
  ```

:::
:::

:::{.callout-exercise}
### Exercise levels
{{< level 2 >}}

We optionally use a star system to define the difficulty level of an exercise (for example this exercise was marked as level 2).  
The answer shows you how to add these stars. 

The [home page page](../index.md) of the course gives a description of the 3 levels.

::: {.callout-answer collapse=true}

We provide a shortcode in the form `{{{< level X >}}}` where X is the number of filled stars (1, 2 or 3). 
You can add this after the exercise title, like so: 

  ```md
  ::: {.callout-exercise}
  ### Short Description
  {{{< level 2 >}}}

  Question here.

  ::: {.callout-answer}
  Answer here.
  :::
  :::
  ```

:::
:::


:::{.callout-exercise}
### Hints

Sometimes it may be useful to add _hints_ to the exercises. 
How is this done?

:::{.callout-hint collapse=true}
If for exercises we had `.callout-exercise` and for answers we had `.callout-answer`, for hints we have...
:::

:::{.callout-answer collapse=true}

You guessed it, you can use `.callout-hint` (the box is also collapsed by default):

  ```md
  :::{.callout-hint}
  Hint(s) here.
  :::
  ```
:::
:::


### Configuring exercises

There are a few ways to customise how exercises are rendered. 

#### Exercise numbering

By default, exercises are numbered within each section. 
You can set this option from the `_quarto.yml` file, for example to turn it off:
 
```yml
exercises: 
  number: false
```

#### Hide all answers

By default answers are rendered on the site. 
If you want avoid them from being rendered at all (e.g. during a course) you can edit the _quarto.yml file and turn this on:

```yml
exercises: 
  hide-answers: true
```

#### Hide individual answers

You can stop individual answers from being rendered using an attribute to the answer callout:

- `{.callout-answer hide = true}` will hide (i.e. not render) the answer 
- `{.callout-answer hide = false}` will show (i.e. render) the answer

Note that these options overide the global option set in the `_quarto.yml` detailed above. 


#### Cross-reference exercises

In the exercise callout, you can set an id with prefix `#ex-` and then cross-reference it in the text using the handle `@ex-`. 
For example, this syntax::

```md
:::{.callout-exercise #ex-demo}
An exercise demo.
:::

Somewhere in the text, I want to reference @ex-demo.
```

Will render as: 

> :::{.callout-exercise #ex-demo}
> An exercise demo.
> :::
> 
> Somewhere in the text, I want to reference @ex-demo.


## Figures

Figures should be included in the document as: 

```md
![Figure Legend](link_to_figure_file_or_url){#fig-X fig-alt="Alternative text"}
```

- The **figure legend** should be used to explain the figure content. 
- The `#fig-X` is an identifier for the image, which will automatically add a figure number and can be cross-referenced in the text. For example if you used `#fig-unix-terminal` you could reference it as `@fig-unix-terminal` (see example below).
- The **alternative text** is for accessibility purposes and should include a short description of what the image portrais (e.g. for individuals using a screen reader).  

There are more advanced figure layouts possible, see the [Quarto Figures documentation](https://quarto.org/docs/authoring/figures.html) to learn more. 

Here is the code generating @fig-unix-terminal:

```md
![The Unix logo.](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/UNIX_logo.svg/250px-UNIX_logo.svg.png){#fig-unix-terminal fig-alt="The word 'Unix' appears on the logo in green, with text under it saying 'An Open Group Standard'"}
```

![The Unix logo.](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/UNIX_logo.svg/250px-UNIX_logo.svg.png){#fig-unix-terminal fig-alt="The word 'Unix' appears on the logo in green, with text under it saying 'An Open Group Standard'"}

For **image files**, we encourage you to do things in this order:

- If the image is available online (e.g. HTML of a paper) link to the URL of the image rather thank keep a copy in the repository. Make sure to link to the image source in the figure legend.
- If it's a diagram, use a program such as [Inkscape](https://inkscape.org/) to produce a SVG file (these are easier to edit in the future).
- Otherwise save the figure as a PNG (e.g. software screenshots). 

For **saving** and **naming** images: 

- Save images in `materials/<section_folder>/images` (if your materials don't have higher-level sections save it in `materials/images`).  
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
  Please **run `quarto render` and push the `_freeze` directory** when you make changes to your code.  
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
- Exercises are written under a level 3 heading, and the answers written as a collapsible box `{.callout-tip collapse=true}`.
- Figures should always include a _figure legend_ and _alternative text_. 
  - Images can directly link to a URL, otherwise saved as SVG or PNG files.
  - Files should be saved in `materials/<section_folder>/images/`. 
  - Use a common prefix for image file names that relate to the same topic. 
- References to publications/software can be done with a direct link to the source.
- When working with executable documents (`.qmd`, `.Rmd` and `.ipynb`):
  - `#fig-alt` should be added to chunks producing plots.
  - A random seed should be set if there are stochastic algorithms in the code.
  - The `_freeze` directory should be pushed when changes are made.
:::