# 900-publication-bundle
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:24:47 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 6 output files.
</p>

<p>

Saved assertions: 28 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/900-publication-bundle/bundle-manifest.tsv">bundle-manifest.tsv</a>
·
<a href="data/900-publication-bundle/figure-status.tsv">figure-status.tsv</a>
·
<a href="data/900-publication-bundle/review-status.tsv">review-status.tsv</a>
</p>

<p>

No runtime warnings were captured after report initialization.
</p>

</section>

<!-- RWV_REPORT_SUMMARY_END -->

<details class="rwv-analysis-details">

<summary>

Analysis steps, methods and full verification
</summary>

## Tasks

Copy the generated, self-checked figures and tables into
review-candidate/, compare every source/copy SHA256 and build a local
overview HTML. Copying does not refit, rescale or relabel figures.

Review status is read from metadata/review-log.tsv, including the scope
and exclusions of each historical review. Current author acceptance and
engineering checks are recorded separately in CODE-CHANGELOG.md;
historical implementer/reviewer verdicts are not retroactively
rewritten. A successful packaging step does not establish complete
scientific/manuscript final review or submission readiness.

### Task 1: Inputs

### Task 2: Copy figures/tables and verify hashes

| target                  | kind           |  bytes | identical |
|:------------------------|:---------------|-------:|:----------|
| Figure1.pdf             | figure         | 826492 | TRUE      |
| Figure1.svg             | figure         | 831277 | TRUE      |
| Figure1.png             | figure         | 320335 | TRUE      |
| Figure1.tiff            | figure         | 991058 | TRUE      |
| Figure1-legend.md       | legend         |   5686 | TRUE      |
| Figure1-plot-values.tsv | plot values    |  15069 | TRUE      |
| Figure1-checks.tsv      | numeric checks |   1868 | TRUE      |
| Figure1-export.json     | export record  |  16331 | TRUE      |
| Figure2.pdf             | figure         |  82530 | TRUE      |
| Figure2.svg             | figure         |  64899 | TRUE      |
| Figure2.png             | figure         | 339645 | TRUE      |
| Figure2.tiff            | figure         | 789636 | TRUE      |

### Task 3: Collect checks and historically scoped reviews

| scope | reviewer | date | verdict |
|:---|:---|:---|:---|
| workflow-revision | Codex | 2026-09-28 | passed |
| community-migration-evidence | Codex | 2026-09-28 | passed |
| figure-final-review | Codex | 2026-10-14 | passed |
| s4-note-adoption | Codex (implementer) | 2026-10-15 | independent-review-pending |
| figure2-supplement-adoption | Claude (implementer) | 2026-10-17 | independent-review-pending |
| fig345-d-adoption | Claude (implementer) | 2026-10-18 | independent-review-pending |
| fig345-v39-fixes | Claude (implementer) | 2026-10-18 | independent-review-pending |
| supp34-h-fonts | Claude (implementer) | 2026-10-18 | independent-review-pending |
| figure-polish-v44 | Claude (implementer) | 2026-10-18 | independent-review-pending |
| text-s1-v45 | Claude (implementer) | 2026-10-18 | independent-review-pending |
| figure-cleanup-v50 | Codex | 2026-10-19 | passed |
| release-closeout-v50 | Claude (implementer) | 2026-10-19 | independent-review-pending |

| figure | size_mm | numeric_checks | export_checks | codex_review |
|:---|:---|:---|:---|:---|
| Figure 1 | 180 x 175 | 20 passed | 93 passed | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) |
| Figure 2 | 180 x 247 | 34 passed | 113 passed | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) |
| Figure 3 | 180 x 234 | 26 passed | 111 passed | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) |
| Figure 4 | 180 x 232 | 35 passed | 117 passed | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) |
| Figure 5 | 180 x 226 | 11 passed | 61 passed | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) |
| Supplementary Figure 1 | 180 x 175 | 12 passed | 71 passed | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) |
| Supplementary Figure 2 | 180 x 274 | 28 passed | 127 passed | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) |
| Supplementary Figure 3 | 180 x 265 | 74 passed | 125 passed | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) |
| Supplementary Figure 4 | 180 x 182 | 19 passed | 63 passed | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) |

### Task 4: Build overview HTML

### Task 5: Record checks and the run

| check | expected | observed | pass |
|:---|:---|:---|:---|
| every copy is byte-identical to its source | TRUE | TRUE | TRUE |
| nine logical figures on nine pages, four formats each (PDF, SVG, PNG, TIFF) | 36 | 36 | TRUE |
| Supplementary Note 1 is packaged once, byte-identical to its 220 source | 1 | 1 | TRUE |
| Data1_local.xlsx sheets = INDEX, FIELDS + one packaged TSV each | INDEX, FIELDS, S01_samples, S02_composition_full, S03_composition_display, … (63 values) | INDEX, FIELDS, S01_samples, S02_composition_full, S03_composition_display, … (63 values) | TRUE |
| Data1_tables TSVs match their workbook sheets (rows, columns, names) | TRUE | TRUE | TRUE |
| Data2_global.xlsx sheets = INDEX, FIELDS + one packaged TSV each | INDEX, FIELDS, G01_feature_fits, G02_group_medians, G03_profile_support, … (27 values) | INDEX, FIELDS, G01_feature_fits, G02_group_medians, G03_profile_support, … (27 values) | TRUE |
| Data2_tables TSVs match their workbook sheets (rows, columns, names) | TRUE | TRUE | TRUE |
| supplementary figure notes have one section per figure, in figure order | Figure 1, Figure 2, Figure 3, Figure 4, Figure 5, Supplementary Figure 1, Supplementary Figure 2, Supplementary Figure 3, Supplementary Figure 4 | Figure 1, Figure 2, Figure 3, Figure 4, Figure 5, Supplementary Figure 1, Supplementary Figure 2, Supplementary Figure 3, Supplementary Figure 4 | TRUE |
| every caption points to its section of the supplementary figure notes | TRUE | TRUE | TRUE |
| Supplementary Figure 4 is the VF calibration figure of 230, not the retired global S4 | TRUE | TRUE | TRUE |
| all six Note 4 deliverables packaged | 6 | 6 | TRUE |
| Note 4 data links resolve in bundle | TRUE | TRUE | TRUE |
| Note5 and complete symmetric ecology evidence packaged | TRUE | TRUE | TRUE |
| review report unchanged: workflow-revision | 15c44465dd5fd0353361fcb6c0bf3b36ffa61719990e139bf1d4692769932a73 | 15c44465dd5fd0353361fcb6c0bf3b36ffa61719990e139bf1d4692769932a73 | TRUE |
| review report unchanged: community-migration-evidence | 15c44465dd5fd0353361fcb6c0bf3b36ffa61719990e139bf1d4692769932a73 | 15c44465dd5fd0353361fcb6c0bf3b36ffa61719990e139bf1d4692769932a73 | TRUE |
| review report unchanged: figure-final-review | 8d568ede20e70f147932a16d1b2efbfb04b8cc84048926d203e022881c362159 | 8d568ede20e70f147932a16d1b2efbfb04b8cc84048926d203e022881c362159 | TRUE |
| review report unchanged: s4-note-adoption | 2e6bd60a0e4f5f690b6e6a991dfd51b1e798d9af42e71636da0fdcb07e268f32 | 2e6bd60a0e4f5f690b6e6a991dfd51b1e798d9af42e71636da0fdcb07e268f32 | TRUE |
| review report unchanged: figure-cleanup-v50 | c5e4fdab1e951ad181b1fb2b2f69fc9d8b04db42c12de46282f3aba5a12d1aa6 | c5e4fdab1e951ad181b1fb2b2f69fc9d8b04db42c12de46282f3aba5a12d1aa6 | TRUE |
| review log has the twelve registered scopes | community-migration-evidence, fig345-d-adoption, fig345-v39-fixes, figure-cleanup-v50, figure-final-review, figure-polish-v44, figure2-supplement-adoption, release-closeout-v50, s4-note-adoption, supp34-h-fonts, text-s1-v45, workflow-revision | community-migration-evidence, fig345-d-adoption, fig345-v39-fixes, figure-cleanup-v50, figure-final-review, figure-polish-v44, figure2-supplement-adoption, release-closeout-v50, s4-note-adoption, supp34-h-fonts, text-s1-v45, workflow-revision | TRUE |
| every figure has a current registered visual review | 9 | 9 | TRUE |
| every step has a rendered HTML page | 9 | 9 | TRUE |
| every continuation page has a current registered visual review | TRUE | TRUE | TRUE |
| status covers nine figures | 9 | 9 | TRUE |
| figure review status follows the review log | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) | figure final review passed (Codex, 2026-10-14); workflow revision passed (Codex, 2026-09-28); S4-to-Note adoption: independent-review-pending (Codex (implementer); current adoption not independently certified); Figure 2 / Supplementary Figures 1-4 adoption 2026-10-17: independent-review-pending (Claude (implementer)); Figures 3-5 version-D adoption 2026-10-18: independent-review-pending (Claude (implementer)); Figures 3-5 v39 fixes 2026-10-18: independent-review-pending (Claude (implementer)); Supplementary Figures 3-4 layout H and six-figure type size 2026-10-18: independent-review-pending (Claude (implementer)); four figure fixes (Figures 1, 3, Supplementary Figure 1) 2026-10-18: independent-review-pending (Claude (implementer)); text fixes and Supplementary Figure 1 trimming 2026-10-18: independent-review-pending (Claude (implementer)); nine-figure cleanup content review 2026-10-19: passed (Codex); release engineering 2026-10-19: independent-review-pending (Claude (implementer)) | TRUE |
| community results come from one active version | 1 | 1 | TRUE |
| overview links one section per figure | 9 | 9 | TRUE |
| every overview link resolves to a file that exists |  |  | TRUE |
| overview links the figures, their files, the tables and the manifests | 91 | 91 | TRUE |

| file                | bytes | sha256           |
|:--------------------|------:|:-----------------|
| bundle-manifest.tsv | 40012 | 5f20f334b22e07a3 |
| figure-status.tsv   | 12084 | 2026124f9abe79fa |
| review-status.tsv   |  7516 | 4397b593c5cbadfb |
| overview.html       | 68412 | f3a2d12801c75918 |
| bundle-checks.tsv   |  5981 | 5fbbbc480875646c |
| session-info.txt    | 13701 | 4b5299e19ef9b761 |

Outputs recorded in step-record.json

</details>

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/900-publication-bundle/bundle-manifest.tsv">bundle-manifest.tsv</a> (39.1 KB)</li>
<li><a href="data/900-publication-bundle/figure-status.tsv">figure-status.tsv</a> (11.8 KB)</li>
<li><a href="data/900-publication-bundle/review-status.tsv">review-status.tsv</a> (7.3 KB)</li>
<li><a href="data/900-publication-bundle/overview.html">overview.html</a> (66.8 KB)</li>
<li><a href="data/900-publication-bundle/bundle-checks.tsv">bundle-checks.tsv</a> (5.8 KB)</li>
<li><a href="data/900-publication-bundle/session-info.txt">session-info.txt</a> (13.4 KB)</li>
</ul>

</details>
