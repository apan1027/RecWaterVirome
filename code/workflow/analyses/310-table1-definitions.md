# 310-table1-definitions
Jinlong Ru, Cunli Pan
2026-10-20

**Updated: 2026-10-20 00:24:23 CEST +0200.**

<!-- RWV_REPORT_SUMMARY_START -->

<section class="rwv-report-summary" aria-label="Run summary">

<h2>

Run summary
</h2>

<p>

<strong>Step completed</strong> · 5 output files.
</p>

<p>

Saved assertions: 6 passed, 0 failed, 0 unclassified.
</p>

<p>

Key files:
<a href="data/310-table1-definitions/table1.tsv">table1.tsv</a>
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

Table 1 draws a reader-facing 12-row summary from
config/definitions.tsv: analysis level, units/rules,
counts/denominators, figure locations and interpretation limits. The
complete 49-row register is delivered as table1-full-definitions.tsv.
Configuration is the single numerical source; no new quantities or
backward figure dependencies are introduced.

### Task 1: Inputs

### Task 2: Assemble Table 1

| Level | Object and rule | n (denominator) | Figures | Key limit |
|:---|:---|:---|:---|:---|
| Samples | Seven water samples from three sites, each profiled once by viral metagenomics and 16S and 18S rRNA gene amplicons | 7 samples; 21 assay profiles | Figs. 1, 2; Supplementary Figs. 1, 2 | Profiles are not independent samples; d, treatment-process water and c, nearby water after facility outflow (from the sample descriptions), not verified hydraulic pairs; bc2 has no designated d counterpart |
| Viral catalogue | Representative vOTU sequences with CheckV quality classes (Complete / High / Medium / Low / Undetermined: 167 / 142 / 450 / 2,254 / 47) | 3,060 vOTUs | Figs. 1, 5a; Supplementary Figs. 1a, 2a | Not complete genomes; quality classes estimate genome recovery, not sequencing-read quality |
| Amplicon alpha diversity | 16S table rarefied to 63,564 reads; full 18S table rarefied to 53,257 reads before Metazoa were removed | per sample | Fig. 2a; Supplementary Fig. 1 | Retained microeukaryote totals need not be equal among samples |
| Candidate hosts (iPHoP) | High-confidence iPHoP records (score \>= 90), classified by whether the named genus is detected in the 16S dataset | 200 records: 127 detected (83 co-detected in a sample), 70 not detected, 3 unresolved | Fig. 2d; Supplementary Fig. 2c; Supplementary Note 1, Table C | Dataset-level genus detection alone does not imply same-sample co-detection; neither establishes infection |
| Strict CRISPR edges | Reference-database CRISPR evidence within high-confidence iPHoP predictions: overall and CRISPR scores \>= 90 and an exact same-genus raw spacer hit | 29 (vOTU, genus) edges; 13 co-detected in a sample | Fig. 2d | Part of the iPHoP evidence, not an independent validation; the genus match is exact, not zero-mismatch |
| AMG candidates | Auxiliary metabolic gene candidates; heatmap values are summed TPM of the carrier vOTUs | 138 KOs; 560 carrier vOTUs (all database IDs), 544 with \>= 1 KO | Fig. 3; Supplementary Note 1, Table C | Two carrier definitions; values are not expression or metabolic flux |
| Anti-defense candidates | DefenseFinder anti-defense systems and filtered dbAPIS hits | 106 and 715 vOTUs; 99 in both; 722 in either | Figs. 3, 5a | The tool sets are not additive; the union is at least one candidate, not concordant detection |
| NARP definitions | DefenseFinder NARP1 and NARP2 calls; KO co-occurrence of K03462 and K13522; dbAPIS NARP-targeting hits | 3 / 5 / 6 / 19 vOTUs | Fig. 3; Supplementary Fig. 3a | Operational definitions that are not interchangeable |
| VF hits on flagged records | Virulence-factor hits on CheckV provirus-flagged records, by localization (host region / crossing / viral region) | 20 hits on 8 of 19 flagged vOTUs (18 / 1 / 1) | Supplementary Fig. 4a, b | Not 18 contigs; a crossing hit is counted once |
| Lifestyle-VF models | Four negative-binomial models: all hits with contig-length offset, or hits retained after regional exclusion with retained-length offset; lifestyle labels with or without the CheckV branch (temperate 260 / 244) | 3,013 vOTUs; 142 or 123 hits | Fig. 4c; Supplementary Note 3 | Regional exclusion changes both the counted hits and the offset; four dependent estimates; labels are annotation-based |
| Controlled constructs | Viral windows with defined host flanks, used to calibrate CheckV flagging and trimming | 0/512 unflanked flagged; 315/720 flanked unflagged; 33/720 retaining \< 95% | Supplementary Note 3 | Distinct endpoints whose percentages must not be combined; constructs are not natural sequences |
| Global reference | Source-labelled Complete Caudoviricetes genomes in 30,079 gene-sharing clusters; 285 metabolic Pfam domains and 38 non-NARP anti-defense profiles, each modelled against log10(CDS) | 77,951 genomes | Fig. 5b, c; Supplementary Note 4 | Separate from the local catalogue; carriage associations, not functional demand or causation; clusters are not a phylogeny |

### Task 3: Record checks and the run

| check | expected | observed | pass |
|:---|:---|:---|:---|
| every definition row has a study unit and a definition | TRUE, TRUE | TRUE, TRUE | TRUE |
| figure column filled for every row | TRUE | TRUE | TRUE |
| full ledger rows equal definition rows | 66 | 66 | TRUE |
| Table 1 figure pointers use the manuscript form and no former S2A pointer remains | TRUE, FALSE | TRUE, FALSE | TRUE |
| the flanked-construct denominators quoted in Table 1 | 512, 720, 720 | 512, 720, 720 | TRUE |
| main Table 1 is compact (rows, columns) | 12, 5 | 12, 5 | TRUE |

| file                        | bytes | sha256           |
|:----------------------------|------:|:-----------------|
| table1.tsv                  |  3773 | 75e5fe2c8bf80807 |
| table1.md                   |  4180 | ad1ee8f0bd34e8ea |
| table1-full-definitions.tsv | 16631 | 9876f14cab888820 |
| table1-checks.tsv           |   502 | 5d2893b00dadb6ed |
| session-info.txt            | 13701 | d93b44b0bd8165e6 |

Outputs recorded in step-record.json

</details>

## Table 1

| Level | Object and rule | n (denominator) | Figures | Key limit |
|:---|:---|:---|:---|:---|
| Samples | Seven water samples from three sites, each profiled once by viral metagenomics and 16S and 18S rRNA gene amplicons | 7 samples; 21 assay profiles | Figs. 1, 2; Supplementary Figs. 1, 2 | Profiles are not independent samples; d, treatment-process water and c, nearby water after facility outflow (from the sample descriptions), not verified hydraulic pairs; bc2 has no designated d counterpart |
| Viral catalogue | Representative vOTU sequences with CheckV quality classes (Complete / High / Medium / Low / Undetermined: 167 / 142 / 450 / 2,254 / 47) | 3,060 vOTUs | Figs. 1, 5a; Supplementary Figs. 1a, 2a | Not complete genomes; quality classes estimate genome recovery, not sequencing-read quality |
| Amplicon alpha diversity | 16S table rarefied to 63,564 reads; full 18S table rarefied to 53,257 reads before Metazoa were removed | per sample | Fig. 2a; Supplementary Fig. 1 | Retained microeukaryote totals need not be equal among samples |
| Candidate hosts (iPHoP) | High-confidence iPHoP records (score \>= 90), classified by whether the named genus is detected in the 16S dataset | 200 records: 127 detected (83 co-detected in a sample), 70 not detected, 3 unresolved | Fig. 2d; Supplementary Fig. 2c; Supplementary Note 1, Table C | Dataset-level genus detection alone does not imply same-sample co-detection; neither establishes infection |
| Strict CRISPR edges | Reference-database CRISPR evidence within high-confidence iPHoP predictions: overall and CRISPR scores \>= 90 and an exact same-genus raw spacer hit | 29 (vOTU, genus) edges; 13 co-detected in a sample | Fig. 2d | Part of the iPHoP evidence, not an independent validation; the genus match is exact, not zero-mismatch |
| AMG candidates | Auxiliary metabolic gene candidates; heatmap values are summed TPM of the carrier vOTUs | 138 KOs; 560 carrier vOTUs (all database IDs), 544 with \>= 1 KO | Fig. 3; Supplementary Note 1, Table C | Two carrier definitions; values are not expression or metabolic flux |
| Anti-defense candidates | DefenseFinder anti-defense systems and filtered dbAPIS hits | 106 and 715 vOTUs; 99 in both; 722 in either | Figs. 3, 5a | The tool sets are not additive; the union is at least one candidate, not concordant detection |
| NARP definitions | DefenseFinder NARP1 and NARP2 calls; KO co-occurrence of K03462 and K13522; dbAPIS NARP-targeting hits | 3 / 5 / 6 / 19 vOTUs | Fig. 3; Supplementary Fig. 3a | Operational definitions that are not interchangeable |
| VF hits on flagged records | Virulence-factor hits on CheckV provirus-flagged records, by localization (host region / crossing / viral region) | 20 hits on 8 of 19 flagged vOTUs (18 / 1 / 1) | Supplementary Fig. 4a, b | Not 18 contigs; a crossing hit is counted once |
| Lifestyle-VF models | Four negative-binomial models: all hits with contig-length offset, or hits retained after regional exclusion with retained-length offset; lifestyle labels with or without the CheckV branch (temperate 260 / 244) | 3,013 vOTUs; 142 or 123 hits | Fig. 4c; Supplementary Note 3 | Regional exclusion changes both the counted hits and the offset; four dependent estimates; labels are annotation-based |
| Controlled constructs | Viral windows with defined host flanks, used to calibrate CheckV flagging and trimming | 0/512 unflanked flagged; 315/720 flanked unflagged; 33/720 retaining \< 95% | Supplementary Note 3 | Distinct endpoints whose percentages must not be combined; constructs are not natural sequences |
| Global reference | Source-labelled Complete Caudoviricetes genomes in 30,079 gene-sharing clusters; 285 metabolic Pfam domains and 38 non-NARP anti-defense profiles, each modelled against log10(CDS) | 77,951 genomes | Fig. 5b, c; Supplementary Note 4 | Separate from the local catalogue; carriage associations, not functional demand or causation; clusters are not a phylogeny |

<details class="rwv-file-details">

<summary>

All output files
</summary>

<ul>
<li><a href="data/310-table1-definitions/table1.tsv">table1.tsv</a> (3.7 KB)</li>
<li><a href="data/310-table1-definitions/table1.md">table1.md</a> (4.1 KB)</li>
<li><a href="data/310-table1-definitions/table1-full-definitions.tsv">table1-full-definitions.tsv</a> (16.2 KB)</li>
<li><a href="data/310-table1-definitions/table1-checks.tsv">table1-checks.tsv</a> (0.5 KB)</li>
<li><a href="data/310-table1-definitions/session-info.txt">session-info.txt</a> (13.4 KB)</li>
</ul>

</details>
