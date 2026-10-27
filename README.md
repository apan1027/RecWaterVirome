# RecWaterVirome

R analyses and figures for the wastewater and reclaimed-water virome study.

Jinlong Ru; Cunli Pan. Maintainer: Cunli Pan.

## Project files

```text
RecWaterVirome/
├── R/                    # shared R functions
├── analyses/             # paired QMD/Markdown analyses and figure images
│   ├── R/                # analysis parameters, colours and table definitions
│   ├── data/             # input instructions and small checksum lists
│   ├── 110-fig1-design-composition.qmd
│   ├── 110-fig1-design-composition.md
│   └── 110-fig1-design-composition_files/figure-commonmark/Figure1.png
├── dev/                  # optional model scripts and R launchers
├── man/                  # package documentation
├── DESCRIPTION
├── NAMESPACE
├── README.md
└── RecWaterVirome.Rproj
```

Start with the [analyses and figures](analyses/README.md). Each QMD has a Markdown reading companion. Nine accepted figure images are embedded next to the code. The Markdown companions show source and accepted images; they are not newly executed scientific reports.

Supplementary figure mapping: **210 → S1 and S2; 220 → S3; 230 → S4; 240 → Supplementary Note 4**. The five main figures and four supplementary figures follow the author-selected final manuscript. Table export functions also reproduce the three supplementary workbooks and structure archive.

## Data and use

Open `RecWaterVirome.Rproj` in RStudio. R dependencies are listed in `DESCRIPTION`; qproj uses its recorded source revision. Install Quarto before rendering.

Scientific inputs are supplied separately: see [data instructions](analyses/data/README.md). The code does not download or install anything. Opening the project does not fit models. Analyses begin with processed data rather than raw sequencing reads.

From the project root:

```r
source("dev/check-environment.R")
# After supplying the input files:
source("dev/render.R")
```

A single analysis and its dependent steps can be rendered from a terminal:

```sh
Rscript dev/render.R 140-fig4-vf-context --downstream
```

Generated data and large exports stay local under `analyses/data/`. The optional five model/diagnostic scripts in `dev/` use the separately listed method inputs; the figure launcher does not run them.

## Attribution

Shared scientific calculations and model formulas derive from the original RecWaterVirome analyses. Final figure labels and supplementary table assembly are implemented in R. Historical development copies and internal review materials are kept outside this source repository.

The inherited [licence text](dev/LICENSE-upstream.md) is retained for attribution. The original project has not selected a licence for all imported material; no new licence is assigned here.
