# CHANGELOG

## v1.1.0

This release simplifies testing the lightweight Agda formalization of ScmQE
and generating a PDF with a listing of the code.

It also supports generating a website with hyperlinked listings of the code,
including the imported modules from the standard Agda library. The website is
deployed to GitHub Pages at https://pdmosses.github.io/olivierfest-agda/.

The generated PDF of the listings is included in the deployed website at 
https://pdmosses.github.io/olivierfest-agda/pdf/ScmQE.All.pdf.
To avoid duplication, `ScmQE.pdf` has been removed from the GitHub repository.

See the `README` file for further details.

- Add `Makefile`
- Generate website
- Update `README.md`
- Add `CHANGELOG.md`

## v1.0.2

Initial public release.

Published as a supplemental artifact in ACM DL:

    @Misc{Mosses2025CSE-artifact,
      author       = {Mosses, Peter D.},
      title        = {Lightweight Agda formalization of denotational semantics in article `A compositional semantics for {\texttt{eval}} in {Scheme}'},
      howpublished = {ACM},
      year         = {2025},
      doi          = {10.1145/3747409},
    }