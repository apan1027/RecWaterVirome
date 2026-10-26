# 012-tse-construction
Jinlong Ru, Cunli Pan
2026-10-23

**Updated: 2026-10-23 13:58:28 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 12 output files.
</p>

<p>

Saved assertions: 25 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/012-tse-construction/tse_virome.rds">tse_virome.rds</a> ·
<a href="data/012-tse-construction/tse_16s.rds">tse_16s.rds</a> ·
<a href="data/012-tse-construction/tse_16s_filtered.rds">tse_16s_filtered.rds</a>
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

This step builds viral, 16S and 18S community objects for
analysis-v2026.09.28.1 from the staged SQLite snapshot and ampliseq
counts, taxonomy, sample metadata and trees. Prebuilt source-project
TSEs are used only in optional comparison step 014. Parameters are read
from config/community.yml; the computational specification is
implemented in R/community.R and documented in docs/WORKFLOW-GUIDE.md.
Reads are not remapped, DADA2/CheckV are not rerun and new trees are not
inferred.

### Task 1: Inputs and parameters

### Task 2: Validate structure, keys, aliases, ASVs, taxonomy and trees

| table                            |  rows | columns |
|:---------------------------------|------:|--------:|
| sample_metadata                  |     7 |      10 |
| virus_abundance_count            |  3060 |       8 |
| virus_abundance_covered_fraction |  3060 |       8 |
| virus_abundance_reads_per_base   |  3060 |       8 |
| virus_abundance_rpkm             |  3060 |       8 |
| virus_abundance_tpm              |  3060 |       8 |
| virus_abundance_trimmed_mean     |  3060 |       8 |
| virus_amg_dramv                  |   236 |      17 |
| virus_amg_vibrant                |   784 |       7 |
| virus_cargo_summary              |  3060 |      14 |
| virus_contig_annotation          |  3060 |      61 |
| virus_dbapis_filtered            |   950 |      13 |
| virus_dbapis_raw                 |  2073 |      13 |
| virus_defense_finder_genes       |   129 |      28 |
| virus_defense_finder_hmmer       |  2480 |      14 |
| virus_defense_finder_systems     |   117 |      12 |
| virus_gene_annotation_dramv      | 96423 |      40 |
| virus_host_genome                |  2743 |       8 |
| virus_host_genus                 |   579 |       7 |
| virus_padloc_systems             |    60 |      22 |
| virus_taxonomy                   |  3533 |      10 |
| virus_taxonomy_formatted         |  3533 |      10 |
| virus_vfdbA_filtered             |   143 |      27 |
| virus_vfdbA_raw                  |   510 |      27 |
| virus_vfdbA_strict               |    37 |      27 |
| virus_vfdbB_filtered             |   178 |      27 |
| virus_vfdbB_raw                  |   707 |      27 |
| virus_vfdbB_strict               |    53 |      27 |

### Task 3: Construct the viral TSE: detection mask, normalization and CLR

### Task 4: Construct 16S and 18S TSEs: filtering, rarefaction and transformations

### Task 5: Save objects and provenance

| omic | input_rows | row_order | kept_after_filter | rarefy_depth | rows_after_rarefy | rarefy_seed | replace | tree_tips | rng_kind | mia |
|:---|---:|:---|---:|---:|---:|---:|:---|---:|:---|:---|
| 16s | 3903 | legacy | 3093 | 63564 | 3092 | 20260502 | FALSE | 3092 | Mersenne-Twister/Inversion/Rejection | 1.16.0 |
| 18s | 1049 | legacy | 892 | 53257 | 892 | 20260502 | FALSE | 892 | Mersenne-Twister/Inversion/Rejection | 1.16.0 |

| check | expected | observed | pass |
|:---|:---|:---|:---|
| calculation sample order has the seven samples | 7 | 7 | TRUE |
| SQLite integrity check | ok | ok | TRUE |
| SQLite has no 16S/18S ASV or tree table (amplicons come from the ampliseq files) | FALSE | FALSE | TRUE |
| sample aliases are one-to-one for all seven samples | TRUE | TRUE | TRUE |
| virome abundance tables: 3,060 rows each, identical row and column order | TRUE | TRUE | TRUE |
| virome abundance: no missing value, no negative value | FALSE, FALSE | FALSE, FALSE | TRUE |
| catalogue tables keyed on vOTU_id without duplicates (3,060) | 3060, 3060, 0, 0 | 3060, 3060, 0, 0 | TRUE |
| abundance vOTU set equals the catalogue | TRUE | TRUE | TRUE |
| taxonomy join key is unique (no row duplicated by the join) | FALSE | FALSE | TRUE |
| cargo join: every catalogue vOTU matched | 0 | 0 | TRUE |
| nreads aliases map one-to-one onto the seven samples | TRUE | TRUE | TRUE |
| 16s ASV IDs unique; taxonomy, tree tips and registered order cover exactly the same ASVs | TRUE, TRUE, TRUE, TRUE | TRUE, TRUE, TRUE, TRUE | TRUE |
| 16s tree: one tip per ASV, branch lengths present | TRUE, TRUE | TRUE, TRUE | TRUE |
| 16s sample columns and metadata IDs are the seven aliased samples | TRUE, TRUE | TRUE, TRUE | TRUE |
| 18s ASV IDs unique; taxonomy, tree tips and registered order cover exactly the same ASVs | TRUE, TRUE, TRUE, TRUE | TRUE, TRUE, TRUE, TRUE | TRUE |
| 18s tree: one tip per ASV, branch lengths present | TRUE, TRUE | TRUE, TRUE | TRUE |
| 18s sample columns and metadata IDs are the seven aliased samples | TRUE, TRUE | TRUE, TRUE | TRUE |
| 18S taxonomy keeps the PR2 Subdivision needed to remove Metazoa | TRUE | TRUE | TRUE |
| trimmed_tpm sums to one million per sample | TRUE | TRUE | TRUE |
| virome TSE: 3,060 x 7 in calculation order | 3060, 7, 1 | 3060, 7, 1 | TRUE |
| breadth mask removes positive counts (cells with reads but covered_fraction \< 0.75) | TRUE | TRUE | TRUE |
| 16S/18S trees pruned to the surviving rows | TRUE, TRUE | TRUE, TRUE | TRUE |
| 16S rarefied totals equal the depth | TRUE | TRUE | TRUE |
| 18S rarefied totals equal the depth | TRUE | TRUE | TRUE |
| microeukaryote rarefied totals are not equal among samples (Metazoa removed after rarefaction) | TRUE | TRUE | TRUE |

| file                 |  bytes | sha256           |
|:---------------------|-------:|:-----------------|
| tse_virome.rds       | 758940 | 51dfe0fbc7a40a60 |
| tse_16s.rds          | 898701 | 9be63dfaecb9305f |
| tse_16s_filtered.rds | 675919 | 9ab2c148041998bf |
| tse_18s_all.rds      | 244052 | a8b712365b5fdd7d |
| tse_18s_microeuk.rds | 231096 | f36f9322c67712b9 |
| tse-objects.tsv      |    804 | 2a880213a56a023d |
| rarefy-record.tsv    |    307 | c5a723f6522b4635 |
| sqlite-schema.tsv    |   6143 | 2b7bf5454c5a2177 |
| join-report.tsv      |    343 | 5caf079124deab0f |
| sample-aliases.tsv   |    150 | f1b46eda86509828 |
| tse-checks.tsv       |   2131 | 9de095da17456e66 |
| session-info.txt     |  13712 | 85adadf1583a6d15 |

Outputs recorded in step-record.json

</details>

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/012-tse-construction/tse_virome.rds">tse_virome.rds</a> (741.2 KB)</li>
<li><a href="data/012-tse-construction/tse_16s.rds">tse_16s.rds</a> (877.6 KB)</li>
<li><a href="data/012-tse-construction/tse_16s_filtered.rds">tse_16s_filtered.rds</a> (660.1 KB)</li>
<li><a href="data/012-tse-construction/tse_18s_all.rds">tse_18s_all.rds</a> (238.3 KB)</li>
<li><a href="data/012-tse-construction/tse_18s_microeuk.rds">tse_18s_microeuk.rds</a> (225.7 KB)</li>
<li><a href="data/012-tse-construction/tse-objects.tsv">tse-objects.tsv</a> (0.8 KB)</li>
<li><a href="data/012-tse-construction/rarefy-record.tsv">rarefy-record.tsv</a> (0.3 KB)</li>
<li><a href="data/012-tse-construction/sqlite-schema.tsv">sqlite-schema.tsv</a> (6 KB)</li>
<li><a href="data/012-tse-construction/join-report.tsv">join-report.tsv</a> (0.3 KB)</li>
<li><a href="data/012-tse-construction/sample-aliases.tsv">sample-aliases.tsv</a> (0.1 KB)</li>
<li><a href="data/012-tse-construction/tse-checks.tsv">tse-checks.tsv</a> (2.1 KB)</li>
<li><a href="data/012-tse-construction/session-info.txt">session-info.txt</a> (13.4 KB)</li>
</ul>

</details>
