# Workflow guide

Authors (code-document order): [Jinlong Ru](https://orcid.org/0000-0002-6757-6018), [Cunli Pan](https://orcid.org/0000-0002-2595-7533).

This is the revised code inside submission package v50.1. The R-project version is 0.1.1; the manuscript and analysis version remain unchanged. See ../CODE-CHANGELOG.md for change scope and validation.

## Running

From 07_Code, run `python3 check_inputs.py --require-raw`. From workflow, run `LANG=en_US.UTF-8 Rscript scripts/check-environment.R`. With dependencies available, run `LANG=en_US.UTF-8 Rscript scripts/render.R` for the default 19-step workflow. Add `--with-checks` to include optional 014 (archived-result comparison) and 090 (non-scientific style proof). Scripts do not install dependencies automatically.

The order is 010 input verification, 012 TSE construction, 020 community analysis, 030 functional evidence, 040 VF evidence, 050 global reference, 110-150 main figures, 210-240 supplementary figures/notes, 310 Table 1, 320/330 workbooks and 900 packaging. Stable step IDs retain historical filenames; config/figures.yml defines current figure roles: 210 produces S1/S2, 220 produces S3/Note 1, 230 produces S4, and 240 produces Note 4.

## Scientific boundary

All 124 registered staged inputs are supplied and hash-checked. They include the SQLite snapshot and amplicon counts/taxonomy/trees used to construct TSEs and recalculate the established community analysis. The active version is analysis-v2026.09.28.1; the archived alternative is historical. Seeds, detection thresholds, denominators and scientific tests are unchanged.

Functional, VF-model and global-model evidence is read from archived results. The workflow does not perform raw-read mapping/assembly, DADA2, CheckV, database searches, host prediction, structure prediction or global/VF model fitting. Final Supplementary Figure 3 is drawn in R/grid from registered tables, neighbourhood coordinates and two saved structure renders. Optional Python scripts rebuild older v35 materials.

## Provenance

New runs record a begin-time source snapshot (rwv-source-v1): the step QMD, all shared R files, DESCRIPTION, NAMESPACE, shared Quarto settings and rendering/post-render scripts. Changed bytes or added/deleted helpers invalidate reuse. Source changes during a run stop publication. Downstream reads reject missing/changed source evidence. Historical records are never filled with current hashes to make them appear current; they require rerendering before reuse under this contract.

Outputs are staged and checked before publication, preserving previous successful results on failure. Each step sets `path_target <- step$path_target` after opening its handle. HTML and Markdown reports derive from one R execution; cache/freeze remain disabled.

Frozen/raw registers are trust anchors. Deliberate edits update the current register and change record. Archived design/review originals and content-addressed history retain their bytes under archive/. Current pointers use English paths; archive/source-path-map.json preserves original locators. Source-language archived/raw evidence remains unchanged where exact text/hashes support provenance.

## Interpretation and release

Generated interpretation guides are English and retain scientific limits. Site colours identify sites; c/d labels do not establish treatment stages; co-detection does not establish infection; global results remain separate from local observations.

This revision does not change historical review verdicts or certify the whole manuscript. Raw-read accessions, permanent repository identifiers, public licence and experimental records require factual author decisions; none are invented. GitHub and Nextcloud uploads await the author's final confirmation.

## Reading concise reports

Run summary and primary previews appear first. Expand Analysis steps, methods and full verification for the complete method/check tables, All output files for linked filenames/sizes, and Full runtime diagnostics for original warning/message text. Source is available through Quarto's code tools. Repeated warnings are counted, not discarded; errors still stop execution. The post-render hook relocates the finished summary in both reports without a second R execution.

Arial layout capture uses rwv_capture_grob and the existing font-verified export backend, avoiding the default offscreen PostScript device. No font replacement is used. The saved CheckV NA token is normalized explicitly without changing missingness. The virome rarefaction advisory remains visible once with its repetition count; its scientific method is unchanged.

The readability revision changes shared source files. A new source-matched workflow execution must start at 010; do not reuse old source records by editing their hashes. The saved reports supplied here have display-only cleanup and retain their earlier execution evidence.

## Verified reports supplied on 2026-10-20

The current package already includes the complete accepted 21-step run 20261020T001926-86706. Open index.html from 07_Code; no initial rerender is needed. The earlier advice to start from 010 applied before this execution was delivered. Future source changes still require matching provenance. Independent acceptance and the accurate self-test counts (167 passed, three optional skips) are in ../../review-2026-10-20/Codex-acceptance.md.
