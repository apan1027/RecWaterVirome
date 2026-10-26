# 220-sfig2-function-context
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:23:55 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 12 output files.
</p>

<p>

Saved assertions: 74 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/220-sfig2-function-context/sfig3.pdf">sfig3.pdf</a> ·
<a href="data/220-sfig2-function-context/sfig3.png">sfig3.png</a> ·
<a href="data/220-sfig2-function-context/supplementary-note-1-narp.md">supplementary-note-1-narp.md</a>
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

This step draws the final Supplementary Figure 3 layout in R/grid from
verified NARP tables and registered display materials: definition
membership, seven-sample carrier abundance, local gene neighbourhoods
and ORF102 domain/structural evidence. The full-model and local-overlay
PNGs are reused pixel-identically; no structure prediction or structural
alignment is rerun. Supplementary Note 1 retains depth/reference checks
and host background in Tables A-C. Tasks 2-5 validate the component
evidence; Task 6 assembles the current figure.

### Task 1: Inputs

### Task 2: Validate display-KO carriers and host evidence

Use only the 200 verified iPHoP score \>= 90 records from 020.
Historical host fields in the driver table are excluded. Dataset-level
genus visibility is distinct from same-sample co-detection and infection
evidence.

### Task 3: Validate membership under four NARP definitions

### Task 4: Validate case abundance and ORF102 domains

ORF102 domain boundaries are hmmscan predictions. Conserved residues do
not establish cleavage activity. atd1 (ORF166) is a separate call about
45 kb from ORF101-ORF103.

### Task 5: Retain depth/reference checks in Supplementary Note 1

### Task 6: Draw final Supplementary Figure 3 in R/grid

The final figure is assembled as an R/grid object below and exported
using the shared figure exporter. Registered neighbourhood coordinates,
colour ramps and two stored structure renders are read from
analyses/data/00-raw/d220-sfig2-function-context/. The renders must be
embedded pixel-identically. Historical v35 figure files remain
provenance/check inputs and are not copied as the final figure. The
optional Python/PyMuPDF/PyMOL scripts in supplementary-figure-3 rebuild
historical materials only. No structure prediction or overlay
calculation is rerun. Host background is retained in Supplementary Note
1 Table C and Data 1 S22.

| format | check | observed | pass |
|:---|:---|:---|:---|
| pdf | pages | 1 | TRUE |
| pdf | page size (mm) | 180.00 x 265.00 | TRUE |
| pdf | all fonts embedded | TRUE | TRUE |
| pdf | embedded fonts are resolved fonts (no substitution) | Arial-BoldMT, ArialMT | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| pdf | text present | found | TRUE |
| svg | page size (mm) | 180.00 x 265.00 | TRUE |
| svg | font families are the resolved fonts | Arial | TRUE |
| svg | smallest text (pt) | 9.2 | TRUE |
| svg | embedded raster images are exactly the registered renders (pixel-identical RGB) | 2 (2 matched) | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | text present | found | TRUE |
| svg | main stroke width (pt) | 0.57, 0.85, 1.70 | TRUE |
| png | pixels (w x h) | 2125 x 3129 | TRUE |
| png | resolution (dpi) | 300.00 | TRUE |
| png | opaque (no transparency) | TRUE | TRUE |
| png | white corners | 1 | TRUE |
| tiff | pixels (w x h) | 4251 x 6259 | TRUE |
| tiff | resolution (dpi) | 600.00 x 600.00 | TRUE |
| tiff | LZW compression (code 5) | 5 | TRUE |
| tiff | RGB without alpha (3 samples per pixel) | 3 | TRUE |
| pdf | text \>= 2.5 mm from every page edge (mm) | 2.82 | TRUE |
| pdf | no forbidden strings on the page | none | TRUE |

### Task 6b: Export Supplementary Note 1 and its complete value table

The formal supplementary-note-1-narp.md (copied by 900 as
Supplementary_Note_1_NARP.md) and supplementary-note-1-values.tsv retain
22 entries: five former-panel-E rows, 15 former-panel-F rows and two
envelope rows. All values come from 030 tables; prose describes
predictions and source transcriptions without a new calculation.

### Task 7: Record plot values, caption and checks

| check | expected | observed | pass |
|:---|:---|:---|:---|
| label table covers the 11 displayed KOs, one row each | K00390, K00558, K00560, K00820, K01858, K01939, K03462, K06217, K13010, K13381, K13522 | K00390, K00558, K00560, K00820, K01858, K01939, K03462, K06217, K13010, K13381, K13522 | TRUE |
| carriers per displayed KO equal Figure 3 | 146, 1, 33, 10, 13, 3, 33, 16, 3, 11, 7 | 146, 1, 33, 10, 13, 3, 33, 16, 3, 11, 7 | TRUE |
| host statuses are the three record classes or no record | TRUE | TRUE | TRUE |
| carriers with an iPHoP \>= 90 record (all displayed KOs) | 23 | 23 | TRUE |
| largest record count fits the axis | TRUE | TRUE | TRUE |
| definitions.tsv:narp1_df | 3 | 3 | TRUE |
| definitions.tsv:narp2_df | 5 | 5 | TRUE |
| definitions.tsv:narp_ko_cooccurrence | 6 | 6 | TRUE |
| definitions.tsv:dbapis_narp_targeting | 19 | 19 | TRUE |
| every row belongs to at least one definition | TRUE | TRUE | TRUE |
| NARP definition table keeps all 19 NARP-related vOTUs (S3a) | 19 | 19 | TRUE |
| CheckV classes have a short mark | TRUE | TRUE | TRUE |
| DefenseFinder hits on vOTU0052 (Data 1 S27; legend claim) | ORF101, ORF103, ORF166 | ORF101, ORF103, ORF166 | TRUE |
| ORF101/ORF103 are the NARP2 profiles | narp2_nmnat, narp2_nampt | narp2_nmnat, narp2_nampt | TRUE |
| the five DefenseFinder NARP2 calls all carry K13522 | TRUE | TRUE | TRUE |
| nadM (K13522) carriers without a DefenseFinder NARP2 call | vOTU0863, vOTU1898 | vOTU0863, vOTU1898 | TRUE |
| sample table holds the case set in panel order | vOTU0052, vOTU0113, vOTU0131, vOTU0544, vOTU1643, vOTU0863, vOTU1898 | vOTU0052, vOTU0113, vOTU0131, vOTU0544, vOTU1643, vOTU0863, vOTU1898 | TRUE |
| sample table: every vOTU x configured sample once | 49 | 49 | TRUE |
| percent equals masked trimmed TPM / 10,000 | 0.00000000000, 0.00000000000, 0.00000000000, 0.00000000000, 0.00000000000, … (49 values) | 0.00000000000, 0.00000000000, 0.00000000000, 0.00000000000, 0.00000000000, … (49 values) | TRUE |
| non-zero cells are exactly the detected vOTU-sample pairs (covered fraction \>= 0.75; checked in 030) | TRUE | TRUE | TRUE |
| non-zero abundances fall inside the colour limits | TRUE | TRUE | TRUE |
| carrier abundance: 8 detected cells and 41 dashes (S3b) | 8, 41 | 8, 41 | TRUE |
| ORF102 length (aa) | 211 | 211 | TRUE |
| GIY-YIG and NUMOD-like boundaries | 3, 87, 153, 184, 143, 188 | 3, 87, 153, 184, 143, 188 | TRUE |
| ORF102 domain matches (envelope excluded) | 3, 87, 153, 184 | 3, 87, 153, 184 | TRUE |
| vOTU0052 locus relative depth | 1 | 1 | TRUE |
| coverage rows (vOTU0052 + 4 comparison loci) | 5 | 5 | TRUE |
| strict-site observed versus expected | 0.00, 0.45 | 0.00, 0.45 | TRUE |
| coverage samples parsed from the source rows (gd1v, od1v, gc1v, gd1v, gd1v) | gd1v, od1v, gc1v, gd1v, gd1v | gd1v, od1v, gc1v, gd1v, gd1v | TRUE |
| reported Poisson p (strict, +-10 ORF) | 1.00, 0.79 | 1.00, 0.79 | TRUE |
| HE reference cohort (NAMPT-positive, NARP2) | 1369, 104 | 1369, 104 | TRUE |
| reference ORFs between the two genes: none, 1, 2-4, 6-9 | 48, 42, 5, 9 | 48, 42, 5, 9 | TRUE |
| references with \>= 1 ORF between the genes equal the strict-window assessable genomes | 56 | 56 | TRUE |
| historical reported strict-window power (percent; source label odds ratio 3, scenario = threefold Poisson mean) | 16 | 16 | TRUE |
| each local NARP2 call has one NMNAT and one NAMPT row | 2, 2, 2, 2, 2 | 2, 2, 2, 2, 2 | TRUE |
| local ORFs between the two genes (vOTU0052, 0113, 0131, 0544, 1643) | 1, 1, 4, 0, 0 | 1, 1, 4, 0, 0 | TRUE |
| only the vOTU1643 locus lies within 100 bp of a contig end | vOTU1643 | vOTU1643 | TRUE |
| four of the five local NARP2 calls are on Low-quality sequences | 4 | 4 | TRUE |
| global NARP1 / NARP2 module calls | 566, 166 | 566, 166 | TRUE |
| every coverage contig maps to a vOTU through the gene-pair table | FALSE | FALSE | TRUE |
| coverage labels resolved | FALSE | FALSE | TRUE |
| HE windows: assessable, observed, expected | 56.00, 104.00, 0.00, 7.00, 0.45, 9.00 | 56.00, 104.00, 0.00, 7.00, 0.45, 9.00 | TRUE |
| adopted figure assembly checks all passed (build_s2.py record) | TRUE | TRUE | TRUE |
| S3a membership = narp_definitions.tsv (19 vOTUs x 4 definitions) | 1, 0, 0, 0, 1, … (76 values) | 1, 0, 0, 0, 1, … (76 values) | TRUE |
| S3b abundance cells = narp_carrier_sample_abundance.tsv (49 cells) | 0.00000000000, 0.00000000000, 0.00000000000, 0.00000000000, 0.00000000000, … (49 values) | 0.00000000000, 0.00000000000, 0.00000000000, 0.00000000000, 0.00000000000, … (49 values) | TRUE |
| S3c: every gene row of the five DefenseFinder NARP2 carriers is drawn | TRUE | TRUE | TRUE |
| S3c member-gene coordinates = narp_gene_pairs.tsv | 42702, 44422, 23869, 25552, 10691, … (20 values) | 42702, 44422, 23869, 25552, 10691, … (20 values) | TRUE |
| S3d ORF102 length and domain boundaries = narp_case_evidence.tsv | 211, 3, 87, 153, 184 | 211, 3, 87, 153, 184 | TRUE |
| S3c draws the 34 registered neighbourhood ORFs of the five NARP2 calls | 34, 5 | 34, 5 | TRUE |
| S3c neighbourhood vOTUs are the five DefenseFinder NARP2 calls | vOTU0052, vOTU0113, vOTU0131, vOTU0544, vOTU1643 | vOTU0052, vOTU0113, vOTU0131, vOTU0544, vOTU1643 | TRUE |
| S3c neighbourhood start/end = registered plot values C (68 coordinates) | 42042, 42287, 42702, 43790, 44422, … (68 values) | 42042, 42287, 42702, 43790, 44422, … (68 values) | TRUE |
| S3c anchor genes: one K13522 and one K03462 row per neighbourhood | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 | TRUE |
| S3b/S3d colour ramps have 256 steps | 256, 256 | 256, 256 | TRUE |
| S3a draws all 19 NARP-related vOTUs once, the five NARP2 calls first | 19, 19 | 19, 19 | TRUE |
| S3a column totals drawn (NARP1, NARP2, KO rule, dbAPIS) | 3, 5, 6, 19 | 3, 5, 6, 19 | TRUE |
| S3 note: NARP1 shares none with NARP2 or the KO rule and all are dbAPIS vOTUs | 0, 0, 3 | 0, 0, 3 | TRUE |
| page size of the adopted layout H (mm) | 180, 265 | 180, 265 | TRUE |
| S3b grey below-detection tiles / detected tiles (v50, no dashes) | 41, 8 | 41, 8 | TRUE |
| ORF102 domain rows share one source line | 1 | 1 | TRUE |
| reported independent E-values (GIY-YIG, NUMOD-like) in the source text | 2.5e-05, 2.8e-05 | 2.5e-05, 2.8e-05 | TRUE |
| vOTU0052 is the only Medium-quality DefenseFinder NARP2 call | vOTU0052 | vOTU0052 | TRUE |
| vOTU0113 is also detected in gd1 (its depth row uses gc1) | TRUE | TRUE | TRUE |
| Supplementary Note 1: Table A rows (vOTU, sample, ratio) | vOTU0052 gd1 1.00, vOTU0131 od1 1.09, vOTU0113 gc1 1.28, vOTU1643 gd1 0.91, vOTU0544 gd1 1.19 | vOTU0052 gd1 1.00, vOTU0131 od1 1.09, vOTU0113 gc1 1.28, vOTU1643 gd1 0.91, vOTU0544 gd1 1.19 | TRUE |
| Supplementary Note 1: Table B (assessable, observed, expected, p) per window | 56, 0, 0.45, 1.00, 104, 7, 9.00, 0.79 | 56, 0, 0.45, 1.00, 104, 7, 9.00, 0.79 | TRUE |
| Supplementary Note 1 does not call the historical power an odds-ratio calculation | TRUE | TRUE | TRUE |
| NARP case has one retained primary-host register row | 1 | 1 | TRUE |
| NARP primary host and co-detection agree with the saved endpoints | TRUE | TRUE | TRUE |
| values leaving the figure are all recorded for the note (E 5 + F 15 + envelope 2) | 22 | 22 | TRUE |
| every listed vOTU carries a dbAPIS NARP-targeting hit (legend claim) | TRUE | TRUE | TRUE |
| comparison-locus depth range quoted in Supplementary Note 1 | 0.91, 1.28 | 0.91, 1.28 | TRUE |
| plot values of the adopted figure: A 76 + B 49 + C 73 + D 9; former E/F and the envelope (22) are in the note values | 76, 49, 73, 9, 22 | 76, 49, 73, 9, 22 | TRUE |
| adopted caption title (v35) | NARP candidates, local neighbourhoods and ORF102 structural context | NARP candidates, local neighbourhoods and ORF102 structural context | TRUE |
| adopted caption has no section after the English legend | 1 | 1 | TRUE |
| layout-H caption: each v39/v50 phrase replaced exactly once (6 phrases) | 1, 1, 1, 1, 1, 1 | 1, 1, 1, 1, 1, 1 | TRUE |

| file                            |   bytes | sha256           |
|:--------------------------------|--------:|:-----------------|
| sfig3.pdf                       | 1104172 | 81b609655ad7e215 |
| sfig3.svg                       | 1266140 | a5a4e0996164374e |
| sfig3.png                       |  557870 | 085d1bbe63694540 |
| sfig3.tiff                      | 2121824 | 075f57a53f5f6e23 |
| sfig3-export.json               |   21293 | c3cdf4ab88d50cbe |
| sfig3-plot-values.tsv           |   14775 | 48129cb139609db7 |
| sfig3-legend.md                 |    8321 | 1242bd2712a63b6f |
| sfig3-gaps.tsv                  |     827 | 8518c1d918a07627 |
| sfig3-checks.tsv                |    9016 | b7638c525260e86e |
| supplementary-note-1-narp.md    |    8976 | b4abe9a16bff234d |
| supplementary-note-1-values.tsv |    1828 | 026047792b78092a |
| session-info.txt                |   13705 | 4fa7d44b6130c3de |

Outputs recorded in step-record.json

</details>

## Published figure preview

<img src="data/220-sfig2-function-context/sfig3.png"
style="width:100.0%" />

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/220-sfig2-function-context/sfig3.pdf">sfig3.pdf</a> (1078.3 KB)</li>
<li><a href="data/220-sfig2-function-context/sfig3.svg">sfig3.svg</a> (1236.5 KB)</li>
<li><a href="data/220-sfig2-function-context/sfig3.png">sfig3.png</a> (544.8 KB)</li>
<li><a href="data/220-sfig2-function-context/sfig3.tiff">sfig3.tiff</a> (2072.1 KB)</li>
<li><a href="data/220-sfig2-function-context/sfig3-export.json">sfig3-export.json</a> (20.8 KB)</li>
<li><a href="data/220-sfig2-function-context/sfig3-plot-values.tsv">sfig3-plot-values.tsv</a> (14.4 KB)</li>
<li><a href="data/220-sfig2-function-context/sfig3-legend.md">sfig3-legend.md</a> (8.1 KB)</li>
<li><a href="data/220-sfig2-function-context/sfig3-gaps.tsv">sfig3-gaps.tsv</a> (0.8 KB)</li>
<li><a href="data/220-sfig2-function-context/sfig3-checks.tsv">sfig3-checks.tsv</a> (8.8 KB)</li>
<li><a href="data/220-sfig2-function-context/supplementary-note-1-narp.md">supplementary-note-1-narp.md</a> (8.8 KB)</li>
<li><a href="data/220-sfig2-function-context/supplementary-note-1-values.tsv">supplementary-note-1-values.tsv</a> (1.8 KB)</li>
<li><a href="data/220-sfig2-function-context/session-info.txt">session-info.txt</a> (13.4 KB)</li>
</ul>

</details>
