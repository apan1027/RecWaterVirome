# RecWaterVirome code candidate for the BMC clean submission

Authors (code-document order): **Jinlong Ru; Cunli Pan**. Maintainer: Cunli Pan.

**Current authority: BMC_Microbiology_submission_clean_2026-10-26.** This independent personal-repository snapshot follows the author-selected package. Its files were copied from the checked `publication-v58.2` candidate into this repository root. v58.2 remains the historical computational/publication source, not the current editorial authority. No release, DOI or data accession is created by this snapshot.

## Read and inspect

- [Analysis notebooks and rendered reports](code/workflow/analyses/README.md): all 21 steps, dependencies and the actual S1–S4 assignments.
- [Current figure/table-to-code mapping](FIGURE_CODE_MAP.tsv).
- [Nine figure previews verified against the clean package](PREVIEWS.md).
- [Final figure/data reference assets](reference/bmc-clean-2026-10-26/README.md).
- [Clean baseline receipt](provenance/bmc-clean-baseline.json): final-package hashes, embedded-figure identification and attachment scope.
- [Review before upload](REVIEW_BEFORE_UPLOAD.md) and [environment requirements](ENVIRONMENT.md).

The QMD reports preserve historical run records. Final figures and attachments are produced by the publication entry below. `reference/03_Figures`, `reference/04_Supplementary_Information`, `reference/05_Supplementary_Data` and `reference/08_Manuscript_Source` are historical reconstruction inputs; the clean reference directory is the final comparison target.

## Verify without scientific execution

Use existing environments with the declared dependencies; the commands install or download nothing.

```sh
python3 check_candidate.py
python3 code/test_publication_sync.py
python3 code/test_bmc_clean_release.py
python3 code/verify_publication.py --check
```

The last command checks 21 saved workflow records, reconstructs the original registered publication transforms and the clean attachment consolidation, and compares nine figure pixel sets, all ZIP parts of three workbooks, and the structure archive with the clean references. It also checks every added table cell against the preserved TSV/JSON inputs and the S62 field clarification. Omit `--check` only to create a new `code/publication/current-bmc-clean-2026-10-26/` output directory.

Main-figure TIFFs are compared directly with the clean Figures directory. Four supplementary figure references were extracted from the author's clean SI and matched by image content, not assumed file order. Word documents are not distributed; their image checks are recorded as a dated receipt, not claimed to be rerun by the public entry. Current Word text and pending author records are outside this code candidate's scope.

The RStudio wrapper is `source("../synchronize.R")` from `code/workflow`. Add `--render` only when intentionally rerunning the established workflow in a separate copy. This recalculates the existing community analyses from staged SQLite/ASV inputs, but does not fit new VF/global models or run a raw-read pipeline.

## Inputs and preserved scientific results

All 124 registered processed inputs remain in `code/workflow/analyses/data/00-raw/`. Original model scripts, inputs and saved results remain in [model_archive](code/model_archive/README.md); later adopted diagnostics remain in `code/post_release_qc/` with their declared prerequisites. Original sequencing reads are not included.

The clean packaging layer preserves all 91 inherited scientific worksheet XML files, adds S65–S68 and G28 from existing source files, and preserves the author's S62 FIELDS clarification. Supplementary Data 3 contains the archived 66-row construct register; Supplementary Data 4 is the unchanged structure ZIP. See [registered source copies](provenance/copied-sources.tsv), [packaging changes](provenance/entry-changes.json) and [file manifest](FILE_MANIFEST.tsv).

## Personal GitHub upload

The author authorised uploading this checked code snapshot to their own GitHub. Run `bash UPLOAD_TO_GITHUB.sh` from this directory. The script verifies the GitHub CLI login, uses that user's private `p0061-RecWaterVirome-code` repository (creating it if needed), pushes `dev_pan` without force and checks the remote commit. An optional first argument selects another repository name. See [upload details](REVIEW_BEFORE_UPLOAD.md).

GitHub API access was blocked by the preparation environment's domain allowlist. This local snapshot therefore does not assert a successful remote upload. The script reports success only after verifying the remote revision. It does not touch the senior colleague's repository.

The upstream GPL text is preserved verbatim in [provenance/upstream-LICENSE.md](provenance/upstream-LICENSE.md). The separate imported-workflow licence scope remains unresolved; no new licence is assigned. See [snapshot provenance](provenance/personal-snapshot.json).
