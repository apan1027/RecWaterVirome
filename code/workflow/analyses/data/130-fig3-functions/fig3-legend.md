# Figure 3. Candidate auxiliary metabolic functions, their carriers, defense-related calls and one candidate locus

## Legend (English)

Figure 3 | Candidate auxiliary metabolic functions, their carriers, defense-related calls and one candidate locus. (a) Summed TPM of the vOTUs carrying each candidate AMG KO in each sample (log10(TPM + 1); no row scaling; white, zero). Rows are the ten KOs with the largest carrier TPM summed over the seven samples, followed below the dashed line by K13522 (nadM, marked †; bifunctional NMN adenylyltransferase/Nudix hydrolase), added in advance for the NARP-related locus in d. Each row is one KO shown by a short name: gene symbols in italics, otherwise the enzyme or function (DNA m5C MTase, DNA (cytosine-5)-methyltransferase; Inositol-P synthase, myo-inositol-1-phosphate synthase); KO numbers and full annotations are in Data 1 S51. Values are abundances of carrier sequences, not expression or metabolic flux. The strip marks the site (colours as in Fig. 1). (b) For the same rows, the share of row TPM from the first, second and third carriers and all others; colours denote rank within a row, not one vOTU across rows. Columns give the number of carriers (n) and the top carrier with its share. (c) vOTUs (of 3,060) with at least one call in each tool-specific set, with the anti-defense overlap and union (722); counts from different tools are not added and do not measure sensitivity. NARP calls are DefenseFinder NARP1 and NARP2 module calls, a subset of its anti-defense calls; candidate defense-related calls are DefenseFinder defense systems and PADLOC calls. (d) ORF101–ORF103 of vOTU0052, one of the five NARP2 calls in c, at their recorded coordinates; the line above marks this window on the whole 132,528-bp sequence. DefenseFinder places ORF101 and ORF103 in one NARP2 call; ORF102 (outlined) is a GIY-YIG/NUMOD-like candidate. The locus is a candidate annotation; activity or a mechanism was not tested. Details: Supplementary figure notes, Figure 3; the full matrices are in Data 1. Abbreviations: AMG, auxiliary metabolic gene; KO, KEGG Orthology; TPM, abundance normalized to one million per sample; NARP, NAD+ reconstitution pathway; NMNAT, nicotinamide mononucleotide adenylyltransferase; NAMPT, nicotinamide phosphoribosyltransferase; dbAPIS, a database of anti-prokaryotic immune system genes; PADLOC, a defense-system annotation tool.

## Interpretation guide

- What the figure shows: Panels show the distribution of major candidate AMG KO contributions and carrier concentration, tool-specific defense/anti-defense calls (union 722), and the real ORF101-ORF103 arrangement on vOTU0052, one of five NARP2 calls. The approximately 3.2 kb locus is located within a 132.5 kb sequence.
- Interpretation limits: The heatmap is not expression or metabolic flux; K00558 does not establish enhanced sulfur metabolism. Do not add tool counts or compare their sensitivities from these counts. The candidate NARP2 locus is not a demonstrated anti-defense mechanism or experimental validation.

## Sources

- config/f3-ko-labels.tsv (short display names; written with the full KO annotations as f3_ko_labels.tsv, Data 1 S51)
- analyses/data/030-function-inputs/f3_display.tsv, f3_carrier_ranks.tsv (amg_ko_matrix_tpm.tsv; amg_driver_votu_feature_contributions.tsv; F3-display-selection.tsv)
- analyses/data/030-function-inputs/defense_sets.tsv, narp_definitions.tsv (local_votu_table.tsv; narp_votu_detail.tsv)
- analyses/data/030-function-inputs/votu0052_locus.tsv (votu0052_amg_focused_context_pm5.tsv; SQLite virus_defense_finder_genes)

## Figure notes (detail; not part of the submission caption)

- Candidate AMG KOs (a): the 138 AMG candidate KOs are carried by 544 vOTUs (560 when all database identifiers are counted). Selecting by abundance shows the largest contributions, not all functions or their biological importance; K13522 (nadM, †) is a prespecified NARP case at abundance rank 13, not part of the top ten.
- K00558 (a): DNA cytosine-5-methyltransferase, carried by 146 vOTUs in this AMG table; its pathway label alone does not indicate enhanced sulfur metabolism.
- Data 1 (a, b): the full 138-KO and 68-pathway matrices and the per-carrier contributions.
- Tool-specific sets (c): DefenseFinder anti-defense 106, filtered dbAPIS 715, both 99, union 722 (106 + 715 − 99); DefenseFinder defense 5 and PADLOC 31; DefenseFinder NARP1 3 and NARP2 5 module calls. A separate KO co-occurrence rule (K03462 + K13522) gives six vOTUs (Supplementary Fig. 3).
- vOTU0052 (d): 132,528 bp; CheckV Medium-quality, 88.84% estimated completeness. ORF coordinates 42,702–43,781, 43,790–44,425 and 44,422–45,891 bp, all on the plus strand. The separate atd1 call on ORF166, about 45 kb away, is not part of this neighbourhood.
