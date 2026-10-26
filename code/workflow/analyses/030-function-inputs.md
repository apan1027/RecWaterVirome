# 030-function-inputs
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:22:20 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 23 output files.
</p>

<p>

Saved assertions: 101 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/030-function-inputs/amg_ko_matrix.tsv">amg_ko_matrix.tsv</a>
·
<a href="data/030-function-inputs/amg_pathway_matrix.tsv">amg_pathway_matrix.tsv</a>
·
<a href="data/030-function-inputs/amg_ko_carriers.tsv">amg_ko_carriers.tsv</a>
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

Read, validate and prepare archived KO/pathway matrices, carrier
contributions, the fixed Figure 3 feature list, defense/anti-defense
sets and NARP locus evidence for Figure 3, Supplementary Figure 3 and
Data 1. No annotation, structure prediction, coverage estimation or
database search is rerun.

### Task 1: Inputs

### Task 2: KO and pathway matrices

Matrix values are summed TPM of vOTUs carrying a KO or pathway, not
expression or metabolic flux.

### Task 3: KO-level carrier contributions

### Task 4: Verify the fixed 11-row Figure 3 list

The fixed display rule is the ten KOs with highest archived total_TPM,
ties ordered by KO identifier, plus the prespecified NARP example
K13522. This task verifies the list and source hashes without selecting
a new list.

| KO | gene | selection | total_TPM | rank_total_TPM | n_carriers |
|:---|:---|:---|---:|---:|---:|
| K00558 | DNMT1, dcm | top 10 by total carrier TPM | 431615 | 1 | 146 |
| K13381 | chiA | top 10 by total carrier TPM | 117561 | 2 | 1 |
| K00820 | glmS, GFPT | top 10 by total carrier TPM | 93675 | 3 | 33 |
| K01939 | adenylosuccinate synthase | top 10 by total carrier TPM | 88352 | 4 | 10 |
| K00560 | thymidylate synthase | top 10 by total carrier TPM | 83452 | 5 | 13 |
| K01858 | INO1, ISYNA1 | top 10 by total carrier TPM | 82607 | 6 | 3 |
| K00390 | cysH | top 10 by total carrier TPM | 73263 | 7 | 33 |
| K13010 | per, rfbE | top 10 by total carrier TPM | 72552 | 8 | 16 |
| K06217 | phoH | top 10 by total carrier TPM | 59488 | 9 | 3 |
| K03462 | NAMPT | top 10 by total carrier TPM | 59207 | 10 | 11 |
| K13522 | nadM | prespecified NARP case (not top 10) | 45005 | 13 | 7 |

### Task 5: Display-KO carriers and verified host records

Host links use only the 200 verified iPHoP score \>= 90 records from
020; historical host fields in the driver table are not used.

|  | genus_unresolved | named_genus_detected_in_16s | named_genus_not_detected_in_16s | no iPHoP \>= 90 record |
|:---|---:|---:|---:|---:|
| K00558 | 0 | 11 | 3 | 132 |
| K13381 | 0 | 0 | 0 | 1 |
| K00820 | 0 | 0 | 0 | 33 |
| K01939 | 0 | 0 | 0 | 10 |
| K00560 | 0 | 1 | 0 | 12 |
| K01858 | 0 | 0 | 0 | 3 |
| K00390 | 1 | 3 | 1 | 28 |
| K13010 | 0 | 0 | 0 | 16 |
| K06217 | 0 | 0 | 0 | 3 |
| K03462 | 0 | 1 | 1 | 9 |
| K13522 | 0 | 1 | 0 | 6 |

### Task 5b: Complete KO-carrier host evidence and selected co-detected pathways

Descriptive joins use current 020 host records and co-detection details.
The full table retains all KO carriers, including missing predictions,
unresolved genera and absence of co-detection. The pathway table is the
same-sample co-detected subset; it is not evidence of infection or host
metabolic function.

| AMG_carriers | highscore_host_records | host_genus_visible | primary_host_codetected |
|---:|---:|---:|---:|
| 544 | 36 | 24 | 16 |

### Task 6: Tool-specific defense and anti-defense sets

The prespecified OR-rule union is 722 = 106 DefenseFinder anti-defense +
715 filtered dbAPIS - 99 overlapping members. Counts from different
tools are not added without accounting for overlap.

| set | tool | unit | n | denominator |
|:---|:---|:---|---:|---:|
| DefenseFinder anti-defense | DefenseFinder | vOTUs with \>= 1 call/hit | 106 | 3060 |
| filtered dbAPIS | dbAPIS (filtered) | vOTUs with \>= 1 call/hit | 715 | 3060 |
| DefenseFinder anti-defense AND dbAPIS | both | vOTUs with \>= 1 call/hit | 99 | 3060 |
| Anti-defense union (OR) | DefenseFinder OR dbAPIS | vOTUs with \>= 1 call/hit | 722 | 3060 |
| DefenseFinder defense | DefenseFinder | vOTUs with \>= 1 call/hit | 5 | 3060 |
| PADLOC defense | PADLOC | vOTUs with \>= 1 call/hit | 31 | 3060 |

### Task 7: NARP definitions and the vOTU0052 locus

### Task 7b: NARP2-case abundance and DefenseFinder/PADLOC types

Extract the existing masked trimmed TPM and covered fraction from the
012 TSE for seven verified vOTUs across seven samples. Percentages use
the entire sample-specific masked catalogue (1e6 TPM), without
renormalizing the seven members, row scaling or new rarefaction.
DefenseFinder/PADLOC type fields retain their source values with
explanatory notes.

|  | label | start_position | end_position | strandedness | defensefinder |
|:---|:---|---:|---:|:---|:---|
| 6 | ORF101 nadM/NMNAT (K13522) | 42702 | 43781 | 1 | narp2_nmnat (NARP2 system) |
| 7 | ORF102 GIY-YIG/NUMOD-like candidate | 43790 | 44425 | 1 | no DefenseFinder hit |
| 8 | ORF103 NAMPT (K03462) | 44422 | 45891 | 1 | narp2_nampt (NARP2 system) |

### Task 8: Document-reported case values with source line numbers

Coverage, HE-targeting and ORF102 domain values are available as tables
or text in archived source documents rather than separate result files.
Values are located and checked against those staged documents and
exported with source line numbers. No analysis is repeated.
Source-language search patterns are represented by equivalent Unicode
escapes in the code.

| group | item | value | unit | source_line | independent_anchor |
|:---|:---|---:|:---|---:|:---|
| coverage | vctg2997 (vOTU0052) NARP2 locus | 1.00 | relative depth (x contig median) | 63 | document transcription; no independent source |
| coverage | vctg3454 NARP2 locus (HNH/NUMOD3 insertion) | 1.09 | relative depth (x contig median) | 64 | document transcription; no independent source |
| coverage | vctg2633 NARP2 locus (non-HE insertion) | 1.28 | relative depth (x contig median) | 65 | document transcription; no independent source |
| coverage | vctg2728 NARP2 locus (no insertion) | 0.91 | relative depth (x contig median) | 66 | document transcription; no independent source |
| coverage | vctg2892 NARP2 locus (no insertion) | 1.19 | relative depth (x contig median) | 67 | document transcription; no independent source |
| he_targeting | strict site (between the two genes): assessable genomes | 56.00 | genomes | 66 | document transcription; no independent source |
| he_targeting | strict site (between the two genes): observed | 0.00 | genomes | 66 | document transcription; no independent source |
| he_targeting | strict site: expected | 0.45 | genomes | 66 | document transcription; no independent source |
| he_targeting | +-10 ORF window: assessable genomes | 104.00 | genomes | 69 | document transcription; no independent source |
| he_targeting | +-10 ORF window: observed | 7.00 | genomes | 69 | document transcription; no independent source |
| he_targeting | +-10 ORF window: expected | 9.00 | genomes | 69 | document transcription; no independent source |
| he_targeting | strict site: reported one-sided Poisson enrichment p | 1.00 | p | 66 | document transcription; no independent source |
| he_targeting | +-10 ORF window: reported one-sided Poisson enrichment p | 0.79 | p | 69 | document transcription; no independent source |
| he_targeting | reference cohort: NAMPT-positive INPHARED genomes | 1369.00 | genomes | 25 | document transcription; no independent source |
| he_targeting | reference cohort: genomes with NMNAT near NAMPT (NARP2 module) | 104.00 | genomes | 27 | document transcription; no independent source |
| he_targeting | NARP2 modules with no ORF between the two genes | 48.00 | genomes | 75 | document transcription; no independent source |
| he_targeting | NARP2 modules with 1 ORF between the two genes | 42.00 | genomes | 75 | document transcription; no independent source |
| he_targeting | NARP2 modules with 2-4 ORFs between the two genes | 5.00 | genomes | 76 | document transcription; no independent source |
| he_targeting | NARP2 modules with 6-9 ORFs between the two genes | 9.00 | genomes | 76 | document transcription; no independent source |
| he_targeting | strict window: reported power to detect an odds ratio of 3 with 56 assessable genomes | 16.00 | percent | 62 | document transcription; no independent source |
| orf102_domains | ORF102 length | 211.00 | aa | 138 | equals the length derived from the locus coordinates (211 aa) |
| orf102_domains | GIY-YIG catalytic domain start | 3.00 | aa | 138 | document transcription; no independent source |
| orf102_domains | GIY-YIG catalytic domain end | 87.00 | aa | 138 | document transcription; no independent source |
| orf102_domains | I-HmuI NUMOD-like domain start | 153.00 | aa | 138 | document transcription; no independent source |
| orf102_domains | I-HmuI NUMOD-like domain end | 184.00 | aa | 138 | document transcription; no independent source |
| orf102_domains | NUMOD-like envelope start | 143.00 | aa | 138 | document transcription; no independent source |
| orf102_domains | NUMOD-like envelope end | 188.00 | aa | 138 | document transcription; no independent source |
| global_narp | global NARP1 module calls | 566.00 | genomes (of 77,951) | 271 | equals the framework definition table (config/definitions.tsv: global_narp) |
| global_narp | global NARP2 module calls | 166.00 | genomes (of 77,951) | 271 | equals the framework definition table (config/definitions.tsv: global_narp) |

### Task 9: Record checks and the run

| check | expected | observed | pass |
|:---|:---|:---|:---|
| definitions.tsv:amg_ko | 138 | 138 | TRUE |
| KO total_TPM equals the row sum | 431615.0014416, 117560.7597346, 93675.1934569, 88352.2677979, 83452.2004330, … (138 values) | 431615.0014416, 117560.7597346, 93675.1934569, 88352.2677979, 83452.2004330, … (138 values) | TRUE |
| samples_detected equals positive cells | 7, 1, 5, 6, 7, … (138 values) | 7, 1, 5, 6, 7, … (138 values) | TRUE |
| curated pathway rows | 68 | 68 | TRUE |
| pathway total_TPM equals row sum | 489923.9945006, 333329.9258145, 330894.9286101, 199575.2671402, 185785.1510084, … (68 values) | 489923.9945006, 333329.9258145, 330894.9286101, 199575.2671402, 185785.1510084, … (68 values) | TRUE |
| definitions.tsv:amg_carriers_dbid | 560 | 560 | TRUE |
| definitions.tsv:amg_carriers_ko | 544 | 544 | TRUE |
| KO-level contribution rows | 731 | 731 | TRUE |
| every KO row has carriers | K00010, K00012, K00059, K00067, K00287, … (138 values) | K00010, K00012, K00059, K00067, K00287, … (138 values) | TRUE |
| carrier TPM sums reproduce the KO matrix totals | 431615.0014416, 117560.7597346, 93675.1934569, 88352.2677979, 83452.2004330, … (138 values) | 431615.0014416, 117560.7597346, 93675.1934569, 88352.2677979, 83452.2004330, … (138 values) | TRUE |
| carrier TPM sums reproduce KO matrix column bc1 | 74028.3381136, 0.0000000, 14374.0362227, 199.4639142, 6144.2734712, … (138 values) | 74028.3381136, 0.0000000, 14374.0362227, 199.4639142, 6144.2734712, … (138 values) | TRUE |
| carrier TPM sums reproduce KO matrix column bd1 | 33682.71197687, 117560.75973458, 27511.30896859, 1244.08922749, 3069.78322702, … (138 values) | 33682.71197687, 117560.75973458, 27511.30896859, 1244.08922749, 3069.78322702, … (138 values) | TRUE |
| carrier TPM sums reproduce KO matrix column bc2 | 80979.7774833, 0.0000000, 47966.2857402, 1053.5728398, 978.4758349, … (138 values) | 80979.7774833, 0.0000000, 47966.2857402, 1053.5728398, 978.4758349, … (138 values) | TRUE |
| carrier TPM sums reproduce KO matrix column gc1 | 61297.357099, 0.000000, 0.000000, 76393.537523, 56071.021956, … (138 values) | 61297.357099, 0.000000, 0.000000, 76393.537523, 56071.021956, … (138 values) | TRUE |
| carrier TPM sums reproduce KO matrix column gd1 | 43984.1196280, 0.0000000, 2366.1503676, 2616.8790130, 1552.2112202, … (138 values) | 43984.1196280, 0.0000000, 2366.1503676, 2616.8790130, 1552.2112202, … (138 values) | TRUE |
| carrier TPM sums reproduce KO matrix column oc1 | 74716.3897780, 0.0000000, 0.0000000, 6844.7252808, 713.9526358, … (138 values) | 74716.3897780, 0.0000000, 0.0000000, 6844.7252808, 713.9526358, … (138 values) | TRUE |
| carrier TPM sums reproduce KO matrix column od1 | 62926.3073631, 0.0000000, 1457.4121578, 0.0000000, 14922.4820875, … (138 values) | 62926.3073631, 0.0000000, 1457.4121578, 0.0000000, 14922.4820875, … (138 values) | TRUE |
| contribution fractions sum to 1 per KO | 1, 1, 1, 1, 1, … (138 values) | 1, 1, 1, 1, 1, … (138 values) | TRUE |
| carriers per KO equal saved n_contributing_vOTU | 146, 1, 33, 10, 13, … (138 values) | 146, 1, 33, 10, 13, … (138 values) | TRUE |
| definitions.tsv:k00558_carriers | 146 | 146 | TRUE |
| curated_pathway-level contribution rows | 934 | 934 | TRUE |
| curated_pathway-level contribution fractions sum to 1 per feature | 1, 1, 1, 1, 1, … (68 values) | 1, 1, 1, 1, 1, … (68 values) | TRUE |
| dbID-level contribution rows | 772 | 772 | TRUE |
| dbID-level contribution fractions sum to 1 per feature | 1, 1, 1, 1, 1, … (145 values) | 1, 1, 1, 1, 1, … (145 values) | TRUE |
| pathway carriers cover exactly the pathways of the pathway matrix | map00010, map00020, map00030, map00040, map00051, … (68 values) | map00010, map00020, map00030, map00040, map00051, … (68 values) | TRUE |
| carrier TPM sums reproduce the pathway matrix totals | 489923.9945006, 333329.9258145, 330894.9286101, 199575.2671402, 185785.1510084, … (68 values) | 489923.9945006, 333329.9258145, 330894.9286101, 199575.2671402, 185785.1510084, … (68 values) | TRUE |
| carrier TPM sums reproduce pathway matrix column bc1 | 76126.3586381, 50383.4636085, 153690.1939260, 21114.3906737, 12263.8254245, … (68 values) | 76126.3586381, 50383.4636085, 153690.1939260, 21114.3906737, 12263.8254245, … (68 values) | TRUE |
| carrier TPM sums reproduce pathway matrix column bd1 | 36520.4113829, 148647.5102498, 19853.3481640, 39762.3135447, 7860.2498842, … (68 values) | 36520.4113829, 148647.5102498, 19853.3481640, 39762.3135447, 7860.2498842, … (68 values) | TRUE |
| carrier TPM sums reproduce pathway matrix column bc2 | 80979.7774833, 60443.5285780, 54645.9292278, 49019.8585800, 8161.6644106, … (68 values) | 80979.7774833, 60443.5285780, 54645.9292278, 49019.8585800, 8161.6644106, … (68 values) | TRUE |
| carrier TPM sums reproduce pathway matrix column gc1 | 61297.357099, 32621.627175, 32621.627175, 76393.537523, 89462.403112, … (68 values) | 61297.357099, 32621.627175, 32621.627175, 76393.537523, 89462.403112, … (68 values) | TRUE |
| carrier TPM sums reproduce pathway matrix column gd1 | 46719.0637982, 11163.6841856, 10805.9766405, 4983.0293806, 29118.9805693, … (68 values) | 46719.0637982, 11163.6841856, 10805.9766405, 4983.0293806, 29118.9805693, … (68 values) | TRUE |
| carrier TPM sums reproduce pathway matrix column oc1 | 108189.3760923, 5656.8785541, 42104.5133548, 6844.7252808, 10565.2267774, … (68 values) | 108189.3760923, 5656.8785541, 42104.5133548, 6844.7252808, 10565.2267774, … (68 values) | TRUE |
| carrier TPM sums reproduce pathway matrix column od1 | 80091.650007, 24413.233464, 17173.340122, 1457.412158, 28352.800831, … (68 values) | 80091.650007, 24413.233464, 17173.340122, 1457.412158, 28352.800831, … (68 values) | TRUE |
| definitions.tsv:amg_carriers_dbid | 560 | 560 | TRUE |
| definitions.tsv:amg_carriers_ko | 544 | 544 | TRUE |
| every KO-level carrier is also a dbID-level carrier | TRUE | TRUE | TRUE |
| dbID carriers minus KO carriers | 16 | 16 | TRUE |
| selection provenance hash of the KO matrix equals the staged source | b19100e40f49818f6278fdd73c7837de554f9bf7819a1da3e8e63db0d1dc67c9 | b19100e40f49818f6278fdd73c7837de554f9bf7819a1da3e8e63db0d1dc67c9 | TRUE |
| selection provenance hash of the driver summary equals the staged source | 23bc0d7d1620f5ba2f59562511a1e27662f8b6155816b43be2e886f2359e859a | 23bc0d7d1620f5ba2f59562511a1e27662f8b6155816b43be2e886f2359e859a | TRUE |
| top 10 by total_TPM (ties by KO) + K13522 equals the frozen list | K00558, K13381, K00820, K01939, K00560, K01858, K00390, K13010, K06217, K03462, K13522 | K00558, K13381, K00820, K01939, K00560, K01858, K00390, K13010, K06217, K03462, K13522 | TRUE |
| selection file order equals the frozen list | K00558, K13381, K00820, K01939, K00560, K01858, K00390, K13010, K06217, K03462, K13522 | K00558, K13381, K00820, K01939, K00560, K01858, K00390, K13010, K06217, K03462, K13522 | TRUE |
| saved selection totals equal the KO matrix | 431615.00144, 117560.75973, 93675.19346, 88352.26780, 83452.20043, 82606.51154, 73263.48947, 72552.20253, 59487.56104, 59206.79621, 45005.47854 | 431615.00144, 117560.75973, 93675.19346, 88352.26780, 83452.20043, 82606.51154, 73263.48947, 72552.20253, 59487.56104, 59206.79621, 45005.47854 | TRUE |
| K13522 is not in the top 10 | TRUE | TRUE | TRUE |
| rank fractions sum to 1 per displayed KO | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 | 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 | TRUE |
| top-1 fraction equals the saved selection value | 0.1408863246, 1.0000000000, 0.3115063924, 0.5000692766, 0.6783835028, 0.5348519605, 0.2061770594, 0.3534367282, 0.9411623031, 0.5706248794, 0.7506835177 | 0.1408863246, 1.0000000000, 0.3115063924, 0.5000692766, 0.6783835028, 0.5348519605, 0.2061770594, 0.3534367282, 0.9411623031, 0.5706248794, 0.7506835177 | TRUE |
| top-1 vOTU equals the saved dominant vOTU | vOTU2575, vOTU1191, vOTU0008, vOTU0004, vOTU0035, vOTU0004, vOTU0399, vOTU0016, vOTU0011, vOTU0113, vOTU0113 | vOTU2575, vOTU1191, vOTU0008, vOTU0004, vOTU0035, vOTU0004, vOTU0399, vOTU0016, vOTU0011, vOTU0113, vOTU0113 | TRUE |
| AMG-host register covers every KO carrier exactly once | vOTU0003, vOTU0004, vOTU0008, vOTU0010, vOTU0011, … (544 values) | vOTU0003, vOTU0004, vOTU0008, vOTU0010, vOTU0011, … (544 values) | TRUE |
| AMG-host evidence coverage: all / primary prediction / visible genus / co-detected | 544, 36, 24, 16 | 544, 36, 24, 16 | TRUE |
| selected KO-host paths: associations / KOs / vOTUs / genera | 22, 14, 16, 14 | 22, 14, 16, 14 | TRUE |
| every selected AMG-host association occurs in one actual sample | TRUE | TRUE | TRUE |
| NARP case: retained host genus / sample / confidence / strict CRISPR | g\_\_Novosphingobium, gd1, 90.8, FALSE | g\_\_Novosphingobium, gd1, 90.8, FALSE | TRUE |
| local vOTU table covers the catalogue | vOTU0001, vOTU0002, vOTU0003, vOTU0004, vOTU0005, … (3060 values) | vOTU0001, vOTU0002, vOTU0003, vOTU0004, vOTU0005, … (3060 values) | TRUE |
| definitions.tsv:df_antidefense | 106 | 106 | TRUE |
| definitions.tsv:dbapis_filtered | 715 | 715 | TRUE |
| definitions.tsv:antidefense_overlap | 99 | 99 | TRUE |
| definitions.tsv:antidefense_union | 722 | 722 | TRUE |
| definitions.tsv:df_defense | 5 | 5 | TRUE |
| definitions.tsv:padloc | 31 | 31 | TRUE |
| tool counts equal cargo_library_tiers.tsv (dbAPIS, DF anti-defense, DF defense, PADLOC) | 715, 106, 5, 31 | 715, 106, 5, 31 | TRUE |
| definitions.tsv:narp1_df | 3 | 3 | TRUE |
| definitions.tsv:narp2_df | 5 | 5 | TRUE |
| definitions.tsv:narp_ko_cooccurrence | 6 | 6 | TRUE |
| saved dbAPIS NARP-targeting count equals its ID list | 19 | 19 | TRUE |
| definitions.tsv:dbapis_narp_targeting | 19 | 19 | TRUE |
| vOTUs under any of the four NARP definitions | 19 | 19 | TRUE |
| KO co-occurrence set minus DF NARP2 set | vOTU0863 | vOTU0863 | TRUE |
| DF NARP2 set is inside the KO co-occurrence set | TRUE | TRUE | TRUE |
| every DefenseFinder NARP2 vOTU carries K13522 | TRUE | TRUE | TRUE |
| nadM (K13522) carriers without a DefenseFinder NARP2 call | vOTU0863, vOTU1898 | vOTU0863, vOTU1898 | TRUE |
| TSE samples cover the configured samples | TRUE | TRUE | TRUE |
| masked trimmed TPM sums to one million per sample (whole-catalogue denominator) | 1e+06, 1e+06, 1e+06, 1e+06, 1e+06, 1e+06, 1e+06 | 1e+06, 1e+06, 1e+06, 1e+06, 1e+06, 1e+06, 1e+06 | TRUE |
| sample abundance table: 7 vOTUs x 7 samples, unique keys | 49, 49 | 49, 49 | TRUE |
| non-zero abundance exactly where covered fraction \>= 0.75 | TRUE | TRUE | TRUE |
| non-zero vOTU-sample cells in the case set | 8 | 8 | TRUE |
| type table: 18 DefenseFinder anti-defense, 4 DefenseFinder defense and 4 PADLOC types | 18, 4, 4 | 18, 4, 4 | TRUE |
| CheckV class counts add up to n_votu in every type | TRUE | TRUE | TRUE |
| DefenseFinder defense types add up to the Figure 3c set | 5 | 5 | TRUE |
| PADLOC types add up to the Figure 3c set | 31 | 31 | TRUE |
| DefenseFinder anti-defense type counts (112) exceed distinct carriers (106): not additive | 112, 106 | 112, 106 | TRUE |
| NARP1 and NARP2 type counts equal the NARP definitions | 3, 5 | 3, 5 | TRUE |
| ORF101-103 coordinates | 42702, 43781, 43790, 44425, 44422, 45891 | 42702, 43781, 43790, 44425, 44422, 45891 | TRUE |
| ORF101-103 all on + strand | 1, 1, 1 | 1, 1, 1 | TRUE |
| ORF101/103 KOs | K13522, , K03462 | K13522, , K03462 | TRUE |
| ORF102 length (aa, excluding stop) | 211 | 211 | TRUE |
| DF hits on vOTU0052 (ORF101, 103, 166) | vctg2997-cat_1_101, vctg2997-cat_1_103, vctg2997-cat_1_166 | vctg2997-cat_1_101, vctg2997-cat_1_103, vctg2997-cat_1_166 | TRUE |
| ORF101 and ORF103 in the same NARP2 system | 1 | 1 | TRUE |
| ORF166 coordinates (not part of the ORF101-103 neighbourhood) | 91206, 91499 | 91206, 91499 | TRUE |
| vOTU0052 length and CheckV | 132528, Medium-quality, 88.84 | 132528, Medium-quality, 88.84 | TRUE |
| vOTU0052 NMNAT/NAMPT rows match the locus coordinates | 42702, 44422 | 42702, 44422 | TRUE |
| gene-pair table covers exactly the KO co-occurrence vOTUs | vOTU0052, vOTU0113, vOTU0131, vOTU0544, vOTU0863, vOTU1643 | vOTU0052, vOTU0113, vOTU0131, vOTU0544, vOTU0863, vOTU1643 | TRUE |
| HE: the +-10 ORF window covers the whole NARP2 reference cohort | 104 | 104 | TRUE |
| HE: strict-window assessable = cohort minus modules with adjacent genes | 56 | 56 | TRUE |
| HE: the between-gene ORF distribution sums to the NARP2 reference cohort | 104 | 104 | TRUE |
| HE: genomes with \>= 1 ORF between the genes equal the strict-window assessable genomes | 56 | 56 | TRUE |
| supplementary information states the 16S and full-18S rarefaction depths | TRUE | TRUE | TRUE |
| supplementary information states that microeukaryote totals need not stay equal | TRUE | TRUE | TRUE |
| registered amplicon depths match that statement | 63564/53257 | 63564/53257 | TRUE |
| every document value parsed to a number | FALSE | FALSE | TRUE |
| ORF102 length in the document equals the coordinate-derived length | 211 | 211 | TRUE |
| global NARP1/NARP2 in the SI equal the registered value | 566/166 | 566/166 | TRUE |
| GIY-YIG domain lies inside ORF102, before the NUMOD-like module | TRUE | TRUE | TRUE |

| file                              |  bytes | sha256           |
|:----------------------------------|-------:|:-----------------|
| amg_ko_matrix.tsv                 |  19856 | 83d97dbd7b903413 |
| amg_pathway_matrix.tsv            |   9909 | 1c1e869bb6e1d083 |
| amg_ko_carriers.tsv               | 124967 | 4317bff7810bc60d |
| f3_display.tsv                    |   2599 | bedac122ef8f4b3a |
| f3_carrier_ranks.tsv              |   1831 | a101e5a145f9c9d2 |
| f3_carrier_hosts.tsv              |  18380 | d97750bd61bfbe56 |
| defense_membership.tsv            |  67373 | 6a01ecc31017f1d2 |
| defense_sets.tsv                  |    452 | 3c6ccbedc53e8ddb |
| narp_definitions.tsv              |    875 | 39842e01520a9d5a |
| votu0052_locus.tsv                |    713 | 3ecf8e13ba78aca7 |
| votu0052_defensefinder.tsv        |    635 | 1e91dcf88761b22c |
| narp_case_evidence.tsv            |  12445 | bfefff2de548ae5e |
| function-gaps.tsv                 |    827 | 8518c1d918a07627 |
| input-checks.tsv                  |  14204 | f55ba0acb7ed5d15 |
| session-info.txt                  |  13698 | b9cde83c079fcfd0 |
| narp_gene_pairs.tsv               |   3960 | df8096ee257db215 |
| amg_pathway_carriers.tsv          | 137022 | 5c22dc079d3ac3d4 |
| amg_dbid_carriers.tsv             | 144887 | d81982a163c7c515 |
| amg_dbid_only_carriers.tsv        |   1709 | a818d2ccf6f8e274 |
| narp_carrier_sample_abundance.tsv |  11162 | 4fb53d37e8a05406 |
| defense_type_inventory.tsv        |   5698 | cd2194909b2b937a |
| amg_host_register.tsv             | 107669 | 58e3eb4b4abf9e9d |
| ko_carrier_host_paths.tsv         |   3011 | 51becb24c2deb28a |

Outputs recorded in step-record.json

</details>

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/030-function-inputs/amg_ko_matrix.tsv">amg_ko_matrix.tsv</a> (19.4 KB)</li>
<li><a href="data/030-function-inputs/amg_pathway_matrix.tsv">amg_pathway_matrix.tsv</a> (9.7 KB)</li>
<li><a href="data/030-function-inputs/amg_ko_carriers.tsv">amg_ko_carriers.tsv</a> (122 KB)</li>
<li><a href="data/030-function-inputs/f3_display.tsv">f3_display.tsv</a> (2.5 KB)</li>
<li><a href="data/030-function-inputs/f3_carrier_ranks.tsv">f3_carrier_ranks.tsv</a> (1.8 KB)</li>
<li><a href="data/030-function-inputs/f3_carrier_hosts.tsv">f3_carrier_hosts.tsv</a> (17.9 KB)</li>
<li><a href="data/030-function-inputs/defense_membership.tsv">defense_membership.tsv</a> (65.8 KB)</li>
<li><a href="data/030-function-inputs/defense_sets.tsv">defense_sets.tsv</a> (0.4 KB)</li>
<li><a href="data/030-function-inputs/narp_definitions.tsv">narp_definitions.tsv</a> (0.9 KB)</li>
<li><a href="data/030-function-inputs/votu0052_locus.tsv">votu0052_locus.tsv</a> (0.7 KB)</li>
<li><a href="data/030-function-inputs/votu0052_defensefinder.tsv">votu0052_defensefinder.tsv</a> (0.6 KB)</li>
<li><a href="data/030-function-inputs/narp_case_evidence.tsv">narp_case_evidence.tsv</a> (12.2 KB)</li>
<li><a href="data/030-function-inputs/function-gaps.tsv">function-gaps.tsv</a> (0.8 KB)</li>
<li><a href="data/030-function-inputs/input-checks.tsv">input-checks.tsv</a> (13.9 KB)</li>
<li><a href="data/030-function-inputs/session-info.txt">session-info.txt</a> (13.4 KB)</li>
<li><a href="data/030-function-inputs/narp_gene_pairs.tsv">narp_gene_pairs.tsv</a> (3.9 KB)</li>
<li><a href="data/030-function-inputs/amg_pathway_carriers.tsv">amg_pathway_carriers.tsv</a> (133.8 KB)</li>
<li><a href="data/030-function-inputs/amg_dbid_carriers.tsv">amg_dbid_carriers.tsv</a> (141.5 KB)</li>
<li><a href="data/030-function-inputs/amg_dbid_only_carriers.tsv">amg_dbid_only_carriers.tsv</a> (1.7 KB)</li>
<li><a href="data/030-function-inputs/narp_carrier_sample_abundance.tsv">narp_carrier_sample_abundance.tsv</a> (10.9 KB)</li>
<li><a href="data/030-function-inputs/defense_type_inventory.tsv">defense_type_inventory.tsv</a> (5.6 KB)</li>
<li><a href="data/030-function-inputs/amg_host_register.tsv">amg_host_register.tsv</a> (105.1 KB)</li>
<li><a href="data/030-function-inputs/ko_carrier_host_paths.tsv">ko_carrier_host_paths.tsv</a> (2.9 KB)</li>
</ul>

</details>
