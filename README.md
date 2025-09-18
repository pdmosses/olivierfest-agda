# OlivierFest-Agda

The Agda code provides a lightweight formalization of the denotational semantics
of the language ScmQE defined in the paper:

> Peter D. Mosses. 2025. A Compositional Semantics for `eval` in Scheme.
> In *Proceedings of the Workshop Dedicated to Olivier Danvy*
> *on the Occasion of His 64th Birthday (OLIVIERFEST ’25),*
> *October 12–18, 2025, Singapore, Singapore.*
> ACM, New York, NY, USA, 10 pages. [DOI](https://doi.org/10.1145/3759427.3760369)

The relationship of the formalization to the definitions in the paper is explained
in §6 of the paper.

The file [SemQ.pdf](pdf/ScmQE.All.pdf) is a highlighted listing of the Agda code.

## Software

The following software has been used to check the Agda code and generate
highlighted listings from it:[^1]

* Agda (2.7.0.1)
* Agda standard library (2.2)
* pdflatex, bibtex (TeX Live 2025)
* acmart (2025/05/30 v2.14)
* GNU Make (3.81)

[^1]:
    Other recent versions of the software should produce similar results.

## Testing

### Type-checking

```sh
olivierfest-agda: make check
Loading  ScmQE.All (.../olivierfest-agda/ScmQE/All.agdai).
 Loading  ScmQE.Domain-Equations (.../olivierfest-agda/ScmQE/Domain-Equations.agdai).
  Loading  ScmQE.Abstract-Syntax (.../olivierfest-agda/ScmQE/Abstract-Syntax.agdai).
 Loading  ScmQE.Semantic-Functions (.../olivierfest-agda/ScmQE/Semantic-Functions.agdai).
  Loading  ScmQE.Auxiliary-Functions (.../olivierfest-agda/ScmQE/Auxiliary-Functions.agdai).
```

### Soundness Tests

The development of tests for expected equality of denotations is work in progress,
and the module is not currently imported by `ScmQE.All`, so it has to be checked
separately:

```sh
olivierfest-agda: make check ROOT=ScmQE/Soundness-Tests.lagda 
Loading  ScmQE.Soundness-Tests (.../olivierfest-agda/ScmQE/Soundness-Tests.agdai).
 Loading  ScmQE.Domain-Equations (.../olivierfest-agda/ScmQE/Domain-Equations.agdai).
  Loading  ScmQE.Abstract-Syntax (.../olivierfest-agda/ScmQE/Abstract-Syntax.agdai).
 Loading  ScmQE.Semantic-Functions (.../olivierfest-agda/ScmQE/Semantic-Functions.agdai).
  Loading  ScmQE.Auxiliary-Functions (.../olivierfest-agda/ScmQE/Auxiliary-Functions.agdai).
```

## Listing

### Generating LaTeX

```sh
olivierfest-agda: make latex
olivierfest-agda: make latex ROOT=ScmQE/Soundness-Tests.lagda
olivierfest-agda: cp ScmQE.tex latex/ScmQE.All.doc.tex
olivierfest-agda: cp ScmQE.bib latex/
```

As with checking, the LaTeX for the soundness tests is generated separately.

The command `make doc` would produce a LaTeX document based on the standard
`article` class. After copying the two `ScmQE` files to the `latex` directory,
`make pdf` produces a document using the same ACM style as the cited paper.

### Generating PDF

```sh
olivierfest-agda: make pdf
olivierfest-agda: cp docs/pdf/ScmQE.All.pdf ScmQE.pdf
```

## Website

### Generating HTML

```sh
olivierfest-agda: make html
```

### Generating Markdown

```sh
olivierfest-agda: make md
olivierfest-agda: make md ROOT=Library.lagda
```

### Serving locally

```sh
olivierfest-agda: make serve
```

### Deploying to GitHub Pages

```sh
olivierfest-agda: make deploy
```