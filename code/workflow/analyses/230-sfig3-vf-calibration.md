# 230-sfig3-vf-calibration
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:24:07 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 11 output files.
</p>

<p>

Saved assertions: 19 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/230-sfig3-vf-calibration/sfig4.pdf">sfig4.pdf</a> ·
<a href="data/230-sfig3-vf-calibration/sfig4.png">sfig4.png</a> ·
<a href="data/230-sfig3-vf-calibration/supplementary-note-3-vf-context.md">supplementary-note-3-vf-context.md</a>
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

Natural position evidence first; controlled endpoints second. Displaced
evidence is retained in Supplementary Note 3 and unchanged Data 1
tables.

| format | check | observed | pass |
|:---|:---|:---|:---|
| pdf | pages | 1 | TRUE |
| pdf | page size (mm) | 180.00 x 182.00 | TRUE |
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
| svg | page size (mm) | 180.00 x 182.00 | TRUE |
| svg | font families are the resolved fonts | Arial | TRUE |
| svg | smallest text (pt) | 9.2 | TRUE |
| svg | no embedded raster images | 0 | TRUE |
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
| png | pixels (w x h) | 2125 x 2149 | TRUE |
| png | resolution (dpi) | 300.00 | TRUE |
| png | opaque (no transparency) | TRUE | TRUE |
| png | white corners | 1 | TRUE |
| tiff | pixels (w x h) | 4251 x 4299 | TRUE |
| tiff | resolution (dpi) | 600.00 x 600.00 | TRUE |
| tiff | LZW compression (code 5) | 5 | TRUE |
| tiff | RGB without alpha (3 samples per pixel) | 3 | TRUE |
| pdf | text \>= 2.5 mm from every page edge (mm) | 2.82 | TRUE |
| pdf | no forbidden strings on the page | none | TRUE |

| check | expected | observed | tolerance | pass | source |
|:---|:---|:---|---:|:---|:---|
| endpoint counts and denominators | 0, 315, 33, 512, 720, 720 | 0, 315, 33, 512, 720, 720 | 0 | TRUE |  |
| complete natural coordinate scope | 8, 17, 20 | 8, 17, 20 | 0 | TRUE |  |
| full catalogue classification | 18, 1, 1, 123 | 18, 1, 1, 123 | 0 | TRUE |  |
| model scope counts | 142, 123, 142, 123 | 142, 123, 142, 123 | 0 | TRUE |  |
| below-95 tail retained in note/data | 33 | 33 | 0 | TRUE |  |
| minimum retention | 0.6402 | 0.6402 | 0 | TRUE |  |
| all hit intervals inside their own contig | TRUE | TRUE | 0 | TRUE |  |
| track hit counts match flagged records | 1, 5, 1, 3, 5, 2, 1, 2 | 1, 5, 1, 3, 5, 2, 1, 2 | 0 | TRUE |  |
| track lengths match flagged records | 72425, 50407, 44087, 38183, 23142, 18658, 12075, 10245 | 72425, 50407, 44087, 38183, 23142, 18658, 12075, 10245 | 0 | TRUE |  |
| S4b track order (longest first) | vOTU0073, vOTU0016, vOTU0273, vOTU0446, vOTU1009, vOTU1381, vOTU2681, vOTU3434 | vOTU0073, vOTU0016, vOTU0273, vOTU0446, vOTU1009, vOTU1381, vOTU2681, vOTU3434 | 0 | TRUE |  |
| S4b shared absolute scale covers the longest carrier (75 kb) | TRUE | TRUE | 0 | TRUE |  |
| S4a scope bar = full catalogue classification (sum 143) | 18, 1, 1, 123, 143 | 18, 1, 1, 123, 143 | 0 | TRUE |  |
| S4c vOTU1009 CheckV boundary (last viral / first host bp) | 12974, 12975 | 12974, 12975 | 0 | TRUE |  |
| S4c zoom ORFs and HSP viral/host nt (ORF23 762/0, ORF28 10/560) | 23, 28, 762, 0, 10, 560 | 23, 28, 762, 0, 10, 560 | 0 | TRUE |  |
| S4c zoom window holds both ORFs and HSPs (9.0-14.2 kb) | TRUE | TRUE | 0 | TRUE |  |
| page size of the adopted layout H (mm) | 180, 182 | 180, 182 | 0 | TRUE | config/figures.yml |
| active plot values: 4 scope classes, 17 regions, 20 hits, 8 hit counts, 2 ORFs, 2 HSPs, 2 HSP splits, 1 boundary | 56 | 56 | 0 | TRUE |  |
| Note 3 model table: four saved specifications on 3,013 vOTUs with 142 or 123 filtered hits | TRUE | TRUE | 0 | TRUE |  |
| descriptive lifestyle context has both full-catalogue groups | 3060 | 3060 | 0 | TRUE | 040/lifestyle_function_carriage.tsv |

| file                               |  bytes | sha256           |
|:-----------------------------------|-------:|:-----------------|
| sfig4.pdf                          |  40003 | ceab384905aab9aa |
| sfig4.svg                          |  18716 | 201356d0a7b9e9c5 |
| sfig4.png                          | 123516 | 9fce8415f43cc499 |
| sfig4.tiff                         | 381112 | 78ee39ab8e5257e9 |
| sfig4-export.json                  |  12083 | 85ee4561c534d741 |
| sfig4-plot-values.tsv              |   4280 | 030ae6c11130cfa9 |
| sfig4-legend.md                    |   4048 | 513e76e0f48ea82d |
| sfig4-checks.tsv                   |   1854 | 4dc7edb3b5b96126 |
| supplementary-note-3-vf-context.md |   9781 | faf6766be8c92ee6 |
| supplementary-note-3-values.tsv    |   2793 | 63be0872618ff342 |
| session-info.txt                   |  13703 | 80093e16fa21222a |

Outputs recorded in step-record.json

</details>

## Published figure preview

<img src="data/230-sfig3-vf-calibration/sfig4.png"
style="width:100.0%" />

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/230-sfig3-vf-calibration/sfig4.pdf">sfig4.pdf</a> (39.1 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/sfig4.svg">sfig4.svg</a> (18.3 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/sfig4.png">sfig4.png</a> (120.6 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/sfig4.tiff">sfig4.tiff</a> (372.2 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/sfig4-export.json">sfig4-export.json</a> (11.8 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/sfig4-plot-values.tsv">sfig4-plot-values.tsv</a> (4.2 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/sfig4-legend.md">sfig4-legend.md</a> (4 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/sfig4-checks.tsv">sfig4-checks.tsv</a> (1.8 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/supplementary-note-3-vf-context.md">supplementary-note-3-vf-context.md</a> (9.6 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/supplementary-note-3-values.tsv">supplementary-note-3-values.tsv</a> (2.7 KB)</li>
<li><a href="data/230-sfig3-vf-calibration/session-info.txt">session-info.txt</a> (13.4 KB)</li>
</ul>

</details>
