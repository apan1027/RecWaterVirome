# Code revision for submission package v50.1

Authors (code-document order): [Jinlong Ru](https://orcid.org/0000-0002-6757-6018), [Cunli Pan](https://orcid.org/0000-0002-2595-7533).

Date: 2026-10-19. Target: RecWaterVirome_v50.1_2026-10-19/07_Code, primarily workflow/. R-project code version: 0.1.1. The manuscript version and scientific-analysis version are unchanged. This document is prepared locally for eventual GitHub publication. **No commit, push, GitHub upload or Nextcloud upload was made; publication remains on hold for the author's final confirmation.**

## Implemented changes

| Item | Result |
|---|---|
| Executable-source tracking | Fixed: each new run captures the QMD, all shared R helpers, DESCRIPTION/NAMESPACE, shared Quarto settings and render/post-render scripts at step start. Sync/downstream checks detect changes, missing/added helpers and invalid records. Mid-run source edits stop publication. Legacy records without source hashes are explicitly unverified, not silently accepted or rewritten. |
| Current English code | All 21 QMD subtitles, task headings, prose and generated interpretation guides are English. Scientific reading limits are retained. Legacy-document search keys use equivalent R Unicode escapes to preserve their exact matching behavior. |
| Original evidence | Eleven source-language design/review documents and original metadata are preserved byte-for-byte in archive/, with English paths and an exact original-path map. Content-addressed history retains original bytes and filenames. Raw source evidence remains unchanged. These are archival/input materials, not untranslated current code prose. |
| Generated guide integration | Figure writer and 900 reader both use the English interpretation-guide contract; the reader handles missing optional notes and rejects missing/duplicated required sections. |
| Stale explanations | Corrected current S1/S2/S3/S4/Note 4 roles, the active community version and the SQLite/count reconstruction boundary. Step 220 now correctly describes the final R/grid assembly and saved structural layers, rather than the historical byte-copied v35 figure. Stable dependency step IDs are retained. |
| QMD template | Added the missing staging-path binding after rwv_step_begin; corrected its obsolete deletion comment; safely quotes subtitles containing quotation marks/colons. |
| Author metadata | Jinlong Ru remains first, with ORCID 0000-0002-6757-6018 verified against his official TUM profile. Cunli Pan's author-supplied 0000-0002-2595-7533 is included in every QMD, shared author settings, template and DESCRIPTION. Roles are unchanged. |
| Input readiness | Supplied and hash-verified all 124 registered staged inputs, plus the SQLite dependency for the optional historical S3 builder. The checker distinguishes integrity from input readiness, detects changed supplied raw files and supports --require-raw. No data were downloaded or fabricated. |
| Environment | Added tested direct/transitive versions, source-revision metadata, system record, installation instructions and a read-only environment/font check. DESCRIPTION pins the tested qproj revision. No dependencies were installed and no untested lockfile is claimed. |
| Timezone and navigation | Updated report timestamps to include the actual Europe/Berlin zone/offset. Current README entries identify this code revision; the old fixed CET suffix and stale navigation are removed from current explanations. |
| Package publication | Updated current registry hashes with documented reasons, input-check reports and the outer package manifest/ZIP. Historical scientific deliveries, manuscript/figure files and run records were not rewritten. IDE/OS metadata is excluded from the distributable manifest/ZIP. |

## Verification

138 isolated regression checks passed:

| Suite | Passed |
|---|---:|
| Actual 012/020 source-provenance shape and downstream/finish guards | 24 |
| Consumer-scoped metadata reuse and rejection boundaries | 36 |
| Community configuration, dispersion status and name-set checks | 16 |
| Default/strict workflow synchronization using seeded fixtures | 9 |
| Failure/interruption-safe staged publication | 10 |
| Historical release-switch tool | 21 |
| Input readiness, tampering and QMD-generation template | 8 |
| English guide writer/reader | 4 |
| Report/bundle/dictionary contracts (--checks-only) | 6 |
| Published preview path lifetime using real knitr execution | 4 |

Two optional production-S1 checks and one production-sync check were explicitly skipped because generated production outputs are not part of this source package; they are not counted as passes. The report test's seven full-render/inspection probes could not run: Quarto's macOS launcher attempts a sysctl architecture query that this host denies. Both an approved retry and a direct approved Quarto invocation reproduced the OS restriction. The six non-rendering contracts passed. This is a recorded verification limit, not a claimed successful full Quarto render. Quarto reporting code and the one-execution mechanism were retained; a clean-machine restoration/full scientific rerun was not performed.

All R/Python sources and 21 QMD R-code bodies parse. For the 19 scientific/input/table steps, parsed R expressions match the pre-edit package after excluding the output-only rwv_write_legend and knitr::include_graphics calls. The non-scientific style proof and 900 packaging changes were checked separately. Six shared scientific/style/export/font R sources are byte-identical, including R/community.R. All 124 staged input hashes, current frozen-file hashes, archived report bytes and content-addressed history hashes match their expected values. Current code/documentation contains no Chinese characters outside explicitly preserved archival/raw/input evidence and unshipped IDE state.

Input readiness is READY for the supplied staged-input pipeline. That does not mean raw-sequence reproducibility or compatible software on every machine. The local environment/font preflight passed; destination-machine graphics and dependency restoration still require their own checks.

## Scientific and historical boundaries

No scientific step, sequence-analysis job, model fit, new test or structure prediction was run for this revision. No random seeds, scientific algorithms, feature definitions, sample assignments, thresholds, statistical settings or abundance denominators were changed. Manuscript Word files, nine submitted figure files and supplementary results retain their bytes. The previous release attestation describes the previous package fingerprint; it is historical evidence and does not automatically attest these new code bytes.

The comparison reference was the local committed GitHub repository apan1027/SwDGVirome at 2c81951e56943b49060d6dcd8326b236e2d82108 (dev_pan). Remote access returned 403, so current remote HEAD was not certified. Its project organization informed this review; its sample definitions, scientific thresholds and limitations were not transferred to this study.

The identified code/documentation repairs are implemented. Public licence, permanent repository/accession identifiers and missing experimental facts require author-supplied decisions; these are not outstanding code fixes and have not been invented. Rerendering on a host where Quarto is allowed to start is the remaining execution check. The source-provenance guard will require fresh source-matched run records if historical generated outputs are later reused.

## Follow-up: missing images in author-rendered reports

The author successfully rendered the initial workflow steps and reported that their HTML previews lacked the figures. Inspection confirmed that 090, 110 and 120 had valid published PNGs but HTML/Markdown still referenced .rwv-staging paths removed at publication. The earlier regression scope did not cover this image-path lifetime defect.

Moved all existing figure-preview chunks after rwv_step_finish, where path_target resolves to the published directory. Added the missing S4 preview in 230: ten previews across nine QMDs, including the optional style proof. No shared R/launcher source was changed for this correction, preserving valid upstream scientific source records. A real knitr/staged-publication regression reproduces the old broken path, verifies the corrected path survives with identical PNG bytes, and checks all nine QMDs. Four additional checks pass (138 total).

Existing 090/110/120 HTML reports were repaired by embedding their hash-verified PNG bytes; Markdown now uses the published relative path. Twenty generated reports and 26 image references were checked with zero broken/staging references. This is a report-reference repair, not another R/scientific execution; existing step records/source hashes were not rewritten. Before downstream packaging, rerender already executed 110/120 to obtain new records for their edited QMDs; 090 is optional. 012/020 do not need rerendering for this fix. Subsequent figure steps use the corrected preview order. Run python3 scripts/check-report-images.py to verify generated image references.

## Follow-up: concise reports and font-aware capture (latest revision)

All 21 QMDs now display a run summary and primary figure/table previews without echoed source. Native expandable sections retain the methods, full assertions, file listing and provenance tables. Warning hooks collect conditions rather than suppress them: distinct messages and occurrence counts remain visible, with every original warning/message in the full runtime diagnostics. Errors still stop execution. The summary is evaluated last and moved to the front of HTML and Markdown by the post-render hook, without executing R again. New QMDs from the generator use the same contract.

Arial is installed on the reference machine. The repeated PostScript warnings came from grid.grabExpr's default temporary pdf(NULL) capture device. The five affected QMDs now use the new rwv_capture_grob helper, which selects the same actual font-verified PDF backend as the final export. No fonts are substituted or aliased and no font warning is muted. All pre-existing export functions are unchanged. A separate expected conversion warning in 040 is fixed by normalizing the saved CheckV literal NA token before numeric conversion: all 3,060 values/missingness match the old conversion, retaining 47 missing estimates. Other unexpected tokens still warn. The scientific rrarefy observed-count advisory is retained and summarized; its 100 repeated calls/calculation are unchanged.

160 isolated regression checks passed, including 18 report/font checks and four actual post-render conversion checks using native Pandoc with an isolated Markdown-only launcher. This does not certify a full Quarto render; the recorded native-launcher sysctl restriction remains. Drawing-only replays of 130/140/150/220/230 from saved registered materials produced zero warnings and passed 477 export checks. All five PNGs are byte-identical to their saved accepted references. No model, statistical analysis, community recomputation or production scientific publication was performed by these replays.

All R/Python sources and all 21 QMD R bodies parse. The 19 scientific/input/table steps match the original expression trees under the explicitly documented presentation/capture/NA-token normalization. Five existing scientific/style/font helpers are byte-identical; R/export.R only adds the capture helper. Thirteen saved HTML/Markdown pairs were reorganized without recomputation; complete diagnostics and original report backups remain available. All 26 reports and 50 image references pass the image-reference check. Original run records and submitted manuscript/figure files were not rewritten.

This revision changes shared source files, so it supersedes the earlier preview-only instruction to rerender just 110/120. For a fresh validated execution, run the ordered workflow from 010 (scripts/render.R); the source guard deliberately rejects stale shared-source records. Existing report-display cleanup is not a new execution or retrospective source attestation. No new dependencies, installation or external upload were introduced.

## 2026-10-20: completed Quarto execution and accepted follow-up

The seven-file Claude patch corrects three English interpretation-guide sentences, diagnoses ended processes without changing downstream gating, adds a completeness parser assertion, handles literal NA tokens in supplementary rarefaction display with a failure check, and makes the 240 report's bundle-relative filenames readable. Full patch and independent Codex review: ../review-2026-10-20/.

Run 20261020T001926-86706 completed all 21 entries with real Quarto, consistent executable-source hashes, verified outputs and strict synchronization. 167 isolated checks passed, zero failed, with three optional production tests skipped separately. Nine publication PNGs and scientific table/plot values match sealed references; expected reading-guide, timestamp, run-record and added-check differences were reviewed. Both candidate ZIP manifests were independently verified. This supersedes the earlier blocked-full-render and rerun-required status: the author can read the supplied reports without rendering again. No manuscript/figure artifacts outside 07_Code were changed and no upload occurred.
