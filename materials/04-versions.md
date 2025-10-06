---
title: Dated Versions
---

## Course snapshots

Often you may wish to create a "snapshot" of the course materials at a specific point in time. 
A typical case is when a live workshop runs. 

To do this, you can add a **tag** to the repository:

```bash
git tag -a 2025.01.01 -m "Workshop January 2025"
git push origin 2025.01.01
```

The key thing to note is that the tag name should be a date in `YYYY.MM.DD` format.
Conventionally we use the date of the first day of the workshop.

When you push this to the GitHub repository, an automated GitHub Action will:

- Render the tagged version of the course materials. 
- Add a dropdown menu on the top-right of the page showing the latest version and the 3 most recent versions.
- Add an appendix with links to all the previous versions.


### Adding a tag to past versions

Git tags are associated with a specific commit.
So, if you want to add a tag to a past version, you need to find the commit hash for that version.
You can do this by looking at the commit history on GitHub or using `git log`.

For example, if you want to tag a commit with hash `abc1234`, you would do:

```bash
git tag -a 2024.06.01 abc1234 -m "Workshop June 2024"
git push origin 2024.06.01
```

## Removing an accidental tag

To remove a tag from the local and remote repository, you can do:

```bash
git tag -d 2024.06.01
git push origin --delete 2024.06.01
```

However, **this does not remove the archived version from GitHub**. 
This needs to be done manually by deleting the respective archive directory in the `gh-pages` branch.

You can contact the maintainers if you need help with this.
