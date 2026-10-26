# Original model and supplementary-source archive — v54.1

This archive preserves existing material byte-for-byte. It was copied and its hashes and declared file dependencies were checked; no models, searches or supplementary analyses were rerun. It is not a certification of clean-machine execution.

## Coverage

- Frozen figure/result redraw: `../workflow/` retains its existing sources, saved results and run records. No analysis step was rerun here.
- Community reconstruction: existing saved-object workflow remains in `../workflow/`; it is distinct from the original sequence-processing pipeline.
- Original local VF fits: `original-layout/dev/310-publication-stage-c/local_factorial.R`, the saved per-vOTU input and saved outputs.
- Original global models: `global_primary.R` and `firth_sensitivity.R` under `original-layout/dev/280-publication-stage-a/`, with declared per-genome, sparse feature-carriage, cluster, covariate and fixed-universe inputs and saved outputs. These scripts have not been refitted in this release. Historical scripts retain their own terminology and original dependencies.
- Supplementary checks: retained NARP depth, HE targeting/power, ORF102 domain tables and available source scripts/search output. This is not a complete portable BAM, reference-sequence or HMM-search pipeline.
- Raw reads, assembly, viral discovery and all upstream database searches: not established as fully reproducible by this archive. Missing database releases and laboratory records remain open.

## Critical historical exclusions

The current reference analysis uses the fixed 285 metabolic-related domains and 38 anti-defense profiles. `global_primary.R` ALSO contains a WITHDRAWN category-aggregation branch (its `aggregation_*` outputs and aggregation fields of `summary.json`). Preserve these as history only: do not restore their aggregation claims or treat them as current manuscript evidence. Older named-category summaries do not replace the 38-profile universe. A hash check does not validate the scientific use of every historical branch.

## Inspection and possible later execution

Run `python validate_archive.py` from any directory for hash/file-presence checks only. No fitting code is imported or invoked. Source provenance and hashes are in `source-manifest.json`; direct model input paths are in `declared-file-dependencies.json`. The preserved scripts use the `original-layout` project tree as their root (global scripts accept that root as their first argument; local_factorial.R uses it as the working directory). They require their original R/Python dependencies and may overwrite saved outputs if executed. Do not run in this archival copy; a separate execution copy and environment validation are needed for any later refitting. Seed 20260917 and the 50 representative/200 bootstrap settings are retained in global_primary.R. Supplementary historical scripts also require additional upstream material, which is not claimed to be complete here.
