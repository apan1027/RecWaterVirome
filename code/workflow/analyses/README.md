# Analysis workflow and current publication mapping

Authors: Jinlong Ru; Cunli Pan.

The final author baseline is **BMC_Microbiology_submission_clean_2026-10-26**. See the [current candidate README](../../../README.md), [exact figure/code mapping](../../../FIGURE_CODE_MAP.tsv), and [current previews](../../../PREVIEWS.md).

The 21 QMD files and their reports below preserve the scientific workflow and historical run records. Historical notebook filenames, labels and workbook layouts can differ from the final publication. **Notebook numbers do not determine supplementary figure numbers.** In particular, step 210 creates both S1 and S2, step 220 creates S3, step 230 creates S4, and step 240 prepares Supplementary Note 4.

## Notebook and report navigation

| Notebook | Readable report | Actual role |
|---|---|---|
| [010-input-manifest.qmd](010-input-manifest.qmd) | [Markdown](010-input-manifest.md) · [HTML](010-input-manifest.html) | Register and verify staged inputs |
| [012-tse-construction.qmd](012-tse-construction.qmd) | [Markdown](012-tse-construction.md) · [HTML](012-tse-construction.html) | Construct the community TSE objects |
| [014-legacy-comparison.qmd](014-legacy-comparison.qmd) | [Markdown](014-legacy-comparison.md) · [HTML](014-legacy-comparison.html) | Optional comparison with historical community results |
| [020-community-analysis.qmd](020-community-analysis.qmd) | [Markdown](020-community-analysis.md) · [HTML](020-community-analysis.html) | Community composition, diversity and cross-assay summaries |
| [030-function-inputs.qmd](030-function-inputs.qmd) | [Markdown](030-function-inputs.md) · [HTML](030-function-inputs.html) | Read and check saved functional annotations |
| [040-vf-inputs.qmd](040-vf-inputs.qmd) | [Markdown](040-vf-inputs.md) · [HTML](040-vf-inputs.html) | Read and check saved VF models and diagnostic results |
| [050-global-inputs.qmd](050-global-inputs.qmd) | [Markdown](050-global-inputs.md) · [HTML](050-global-inputs.html) | Read and check saved global feature models |
| [090-style-proof.qmd](090-style-proof.qmd) | [Markdown](090-style-proof.md) · [HTML](090-style-proof.html) | Optional shared-style proof |
| [110-fig1-design-composition.qmd](110-fig1-design-composition.qmd) | [Markdown](110-fig1-design-composition.md) · [HTML](110-fig1-design-composition.html) | Figure 1 |
| [120-fig2-community-links.qmd](120-fig2-community-links.qmd) | [Markdown](120-fig2-community-links.md) · [HTML](120-fig2-community-links.html) | Figure 2 |
| [130-fig3-functions.qmd](130-fig3-functions.qmd) | [Markdown](130-fig3-functions.md) · [HTML](130-fig3-functions.html) | Figure 3 |
| [140-fig4-vf-context.qmd](140-fig4-vf-context.qmd) | [Markdown](140-fig4-vf-context.md) · [HTML](140-fig4-vf-context.html) | Figure 4 |
| [150-fig5-global-reference.qmd](150-fig5-global-reference.qmd) | [Markdown](150-fig5-global-reference.md) · [HTML](150-fig5-global-reference.html) | Figure 5 |
| [210-sfig1-qc-community.qmd](210-sfig1-qc-community.qmd) | [Markdown](210-sfig1-qc-community.md) · [HTML](210-sfig1-qc-community.html) | Supplementary Figures S1 AND S2 |
| [220-sfig2-function-context.qmd](220-sfig2-function-context.qmd) | [Markdown](220-sfig2-function-context.md) · [HTML](220-sfig2-function-context.html) | Supplementary Figure S3 and NARP context |
| [230-sfig3-vf-calibration.qmd](230-sfig3-vf-calibration.qmd) | [Markdown](230-sfig3-vf-calibration.md) · [HTML](230-sfig3-vf-calibration.html) | Supplementary Figure S4 and VF context |
| [240-sfig4-global-sensitivity.qmd](240-sfig4-global-sensitivity.qmd) | [Markdown](240-sfig4-global-sensitivity.md) · [HTML](240-sfig4-global-sensitivity.html) | Supplementary Note 4; does NOT generate Figure S4 |
| [310-table1-definitions.qmd](310-table1-definitions.qmd) | [Markdown](310-table1-definitions.md) · [HTML](310-table1-definitions.html) | Study-unit and definition table |
| [320-data1-local.qmd](320-data1-local.qmd) | [Markdown](320-data1-local.md) · [HTML](320-data1-local.html) | Frozen local-analysis workbook before publication layers |
| [330-data2-global.qmd](330-data2-global.qmd) | [Markdown](330-data2-global.md) · [HTML](330-data2-global.html) | Frozen global-analysis workbook before publication layers |
| [900-publication-bundle.qmd](900-publication-bundle.qmd) | [Markdown](900-publication-bundle.md) · [HTML](900-publication-bundle.html) | Assemble the frozen workflow bundle before publication layers |

## Inspect the final figures and attachments

From the candidate root, use an existing declared environment:

```sh
python3 check_candidate.py
python3 code/test_publication_sync.py
python3 code/test_bmc_clean_release.py
python3 code/verify_publication.py --check
```

The last command validates the saved workflow, reconstructs the registered publication layers and the clean attachment consolidation, and compares nine figures, three Excel workbooks and the structure ZIP against the final references. It does not run scientific analyses. The RStudio wrapper may be sourced from `code/workflow` with `source("../synchronize.R")`; its default is verification only.

All 124 registered processed inputs remain in `data/00-raw/`; original sequencing reads are not included. Required packages and qproj version are recorded in the [workflow environment](../environment/README.md) and [DESCRIPTION](../DESCRIPTION).

## Intentional scientific workflow execution

Use a separate execution copy. The workflow dependency and output contracts are in [workflow.yml](../config/workflow.yml); final figure assignments are in [figures.yml](../config/figures.yml). Ordinary runs omit the two optional check/proof steps; `--with-checks` includes them.

```sh
# From code/workflow in the separate execution copy:
Rscript scripts/render.R --with-checks
# Then, from the candidate root:
python3 code/verify_publication.py --check
```

Rendering the established workflow recalculates community analyses from the staged SQLite/ASV inputs. The VF/global/function sections otherwise read saved results; this is not a raw-read pipeline or new VF/global model fitting. Do not call a successful historical QMD render reproduction of the final clean attachments until the registered publication entry also passes.

The clean release preserves the 64 original local and 27 original reference scientific worksheet XML files, adds four local tables and one keyword-classifier table, and incorporates the existing S62 field clarification. The third workbook archives the supplied 66-row construct genome register. Added data are checked against the preserved TSV/JSON inputs; no new scientific values are calculated.
