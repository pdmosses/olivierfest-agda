# olivierfest-agda

The Agda code provides a lightweight formalization of the denotational semantics
of the language ScmQE defined in the paper:

> Peter D. Mosses. 2025. A Compositional Semantics for `eval` in Scheme.
> In *Proceedings of the Workshop Dedicated to Olivier Danvy*
> *on the Occasion of His 64th Birthday (OLIVIERFEST ’25),*
> *October 12–18, 2025, Singapore, Singapore.*
> ACM, New York, NY, USA, 10 pages. [DOI](https://doi.org/10.1145/3759427.3760369)

The relationship of the formalization to the definitions in the paper is explained
in §6 of the paper.

The file [SemQ.pdf](https://github.com/pdmosses/olivierfest-agda/blob/main/ScmQE.pdf)
is a highlighted listing of the Agda code.

## Prerequisites

The workflow below has been tested using the following software:

* Agda (2.7.0.1)
* Agda standard library (2.2)
* pdflatex, bibtex (TeX Live 2025)
* acmart (2025/05/30 v2.14)

Other recent versions should produce similar results.

## Testing

### Type-checking

```sh
olivierfest-agda: agda ScmQE/All.lagda 
Checking ScmQE.All (.../olivierfest-agda/ScmQE/All.lagda).
 Checking Notation (.../olivierfest-agda/Notation.lagda).
 Checking ScmQE.Abstract-Syntax (.../olivierfest-agda/ScmQE/Abstract-Syntax.lagda).
 Checking ScmQE.Domain-Equations (.../olivierfest-agda/ScmQE/Domain-Equations.lagda).
 Checking ScmQE.Semantic-Functions (.../olivierfest-agda/ScmQE/Semantic-Functions.lagda).
  Checking ScmQE.Auxiliary-Functions (.../olivierfest-agda/ScmQE/Auxiliary-Functions.lagda).
```

### Soundness Tests

```sh
olivierfest-agda: agda ScmQE/Soundness-Tests.lagda 
Checking ScmQE.Soundness-Tests (.../olivierfest-agda/ScmQE/Soundness-Tests.lagda).
```

## Listing

### Generating LaTeX

```sh
olivierfest-agda: agda --latex Notation.lagda
olivierfest-agda: agda --latex ScmQE/All.lagda 
olivierfest-agda: agda --latex ScmQE/Abstract-Syntax.lagda 
olivierfest-agda: agda --latex ScmQE/Auxiliary-Functions.lagda 
olivierfest-agda: agda --latex ScmQE/Domain-Equations.lagda   
olivierfest-agda: agda --latex ScmQE/Semantic-Functions.lagda 
olivierfest-agda: agda --latex ScmQE/Soundness-Tests.lagda
```

### Generating PDF

```sh
olivierfest-agda: cd latex
latex: pdflatex ScmQE
...
latex: bibtex ScmQE
...
latex: pdflatex ScmQE
...
latex: pdflatex ScmQE
...
latex: pdflatex ScmQE
...
Output written on ScmQE.pdf (16 pages, 553694 bytes).
...
latex: mv ScmQE.pdf ..
```