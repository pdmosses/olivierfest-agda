# OlivierFest-Agda

This is the README page for the [OlivierFest-Agda repository].

The Agda code in this repository provides a lightweight formalization of the
denotational semantics of the language ScmQE defined in the paper:

> Peter D. Mosses. 2025. A Compositional Semantics for `eval` in Scheme.
> In *Proceedings of the Workshop Dedicated to Olivier Danvy*
> *on the Occasion of His 64th Birthday (OLIVIERFEST ’25),*
> *October 12–18, 2025, Singapore, Singapore.*
> ACM, New York, NY, USA, 10 pages. [DOI](https://doi.org/10.1145/3759427.3760369)

The relationship of the formalization to the definitions in the paper is explained
in §6 of the paper.

The `Makefile` in this repository automates:

- testing the Agda code;
- generating a website for browsing the code;
- previewing the website locally; and
- deploying the website to GitHub Pages.

The deployed website is at https://pdmosses.github.io/olivierfest-agda/.

## Repository contents

The repository contains the following files and directories:

- `ScmQE`: directory for Agda source code of the ScmQE language
- `index.lagda`, `Library.lagda`, `Notation.lagda`: auxiliary Agda source code
- `docs`: directory for generating a website
    - `docs/javascripts`: directory for added Javascript files
    - `docs/stylesheets`: directory for added CSS files
    - `docs/.nav.yml`: configuration file for navigation panels
    - `docs/index.md`: Markdown source for the website home page
- `agda-custom.sty`: package for overriding commands defined in `agda.sty`
- `unicode.sty`: package mapping Unicode characters to LaTeX
- `Makefile`: automation of website and PDF generation
- `mkdocs.yml`: configuration file for generated websites
- `LICENSE.txt`: release into the public domain

The repository does not contain any generated files.

## Software dependencies

- [Agda] (2.7.0)
- [GNU Make] (3.8.1)
- [sd] (1.0.0)

### For website generation

- [Python 3] (3.11.3)
- [Pip] (25.2)
- [MkDocs] (1.6.1)
- [Material for MkDocs] (9.6.19)
- [Awesome-nav] (3.2.0)
- [GitHub Pages]

### For PDF generation

- [TeXLive] (2025)

## Platform dependencies

Agda-Material has been developed and tested on MacBook laptops
with Apple M1 and M3 chips running macOS Sequoia (15.5) with CLI Tools.

Please report any [issues] with using Agda-Material on other platforms,
including all relevant details.

[Pull requests] for addressing such issues are welcome. They should include the
results of tests that demonstrate the benefit of the PR.

## Getting started

All `make` commands are to be run in the `olivierfest-agda` directory.

### Test the Agda code

```sh
make check
```

### Generate a website listing the Agda code

```sh
make website
```

### Browse the website locally

```sh
make serve
```

### Deploy the website on GitHub Pages

Update the following fields in `mkdocs.yml`:

- `site_name`
- `site_url`
- `repo_name`
- `repo_url`

```sh
make deploy
```

## Contributing

Please report any [issues] that arise.

Comments and suggestions for improvement are welcome, and can be added as [Discussions].

## Contact

Peter Mosses

[p.d.mosses@tudelft.nl](mailto:p.d.mosses@tudelft.nl)

[pdmosses.github.io](https://pdmosses.github.io)


[OlivierFest-Agda repository]: https://github.com/pdmosses/olivierfest-agda/
[Issues]: https://github.com/pdmosses/olivierfest-agda/issues
[Pull requests]: https://github.com/pdmosses/olivierfest-agda/pulls
[Home page]: index.md
[Agda]: https://agda.readthedocs.io/en/stable/getting-started/index.html
[GNU Make]: https://www.gnu.org/software/make/manual/make.html
[sd]: https://github.com/chmln/sd/
[Python 3]: https://www.python.org/downloads/
[Pip]: https://pypi.org/project/pip/
[MkDocs]: https://www.mkdocs.org/getting-started/
[Material for MkDocs]: https://squidfunk.github.io/mkdocs-material/getting-started/
[Awesome-nav]: https://lukasgeiter.github.io/mkdocs-awesome-nav/
[GitHub Pages]: https://pages.github.com
[TeXLive]: https://www.tug.org/texlive/