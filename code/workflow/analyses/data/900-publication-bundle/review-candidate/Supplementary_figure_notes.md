# Supplementary figure notes

Detailed notes for each figure, in figure order. Each submission caption points to its section here; the notes carry definitions, normalisation details and limits that are not repeated in the caption.

## Figure 1

*Study design and composition of the three assays*

- Map (a): Natural Earth 1:50m admin-0 country boundaries (public domain; read with the rnaturalearthdata R package), Lambert azimuthal equal-area projection centred on 45°N 65°E; China and Germany are shaded. The map locates the study regions only and is not used for any distance analysis.
- Map anchors (a): public city or municipality representative coordinates (sources below); exact sampling coordinates have not been recovered. Garching and Oberschleissheim are about 6 km apart, so Germany carries one anchor at the mean of the two coordinates, joined to both site groups; there is no display offset of either point. Bottles and assay icons are schematic.
- Coordinate source (a), Beijing: 39.90667 N, 116.3975 E, city representative coordinate; https://en.wikipedia.org/wiki/Beijing (infobox, GeoHack), accessed 7 October 2026.
- Coordinate source (a), Garching: 48.25 N, 11.65 E, municipality representative coordinate; https://en.wikipedia.org/wiki/Garching_bei_M%C3%BCnchen (infobox), accessed 7 October 2026.
- Coordinate source (a), Oberschleissheim: 48.25 N, 11.567 E, municipality representative coordinate; https://en.wikipedia.org/wiki/Oberschlei%C3%9Fheim (infobox), accessed 7 October 2026.
- Viral composition (b): trimmed-mean coverage set to zero where less than 75% of a vOTU is covered, normalized to one million within each sample (trimmed TPM). The alpha diversity in Fig. 2a instead uses breadth-masked read counts with repeated rarefaction; the two differ in the quantity and its normalization, not in masking.
- Virome source labels (b): 6 assigned classes, one Bamfordvirae label without an assigned class, and Unclassified.
- Amplicon normalization (c, d): shares are computed within each sample from the filtered counts, not from the rarefied tables used for alpha diversity in Fig. 2. 16S taxonomy is GTDB at phylum level (bacteria and archaea); 18S Metazoa are removed at the subdivision level before the shares are computed.
- Taxon display (b-d): the full 59-taxon composition and the taxon-to-category mapping are in Data 1.
- Catalogue (e): representative sequence lengths 10,005–158,264 bp; Complete 167, High-quality 142, Medium-quality 450, Low-quality 2,254, Undetermined 47 (CheckV label Not-determined).

## Figure 2

*Sample differences, cross-assay covariation and candidate host evidence*

- Alpha diversity (a): virome reads are zeroed where less than 75% of the vOTU is covered and averaged over 100 rarefactions to 1,648,195 reads; the 16S table is rarefied to 63,564 reads per sample; the full 18S table was rarefied to 53,257 reads before Metazoa were removed, so retained microeukaryote totals need not be equal among samples. Features differ (vOTUs versus amplicon sequence variants).
- No error bars (a): the spread over rarefactions is technical, not a biological interval.
- Ordination (b): CLR of virome trimmed TPM, 16S counts and Metazoa-removed 18S counts, pseudocount 1.
- Mantel test (c): permutation seed 42. Procrustes and RV results for the same pairs are in Data 1 S09. The test compares whole distance matrices, so it is distinct from the Shannon values in a and from the two-axis projection in b.
- Host genera (d): 197 of the 200 records have a resolved genus, in 129 distinct genera; GTDB genus suffixes are kept. Genera are ranked by their number of catalogue vOTU records and the ten highest are drawn with every tie at the tenth rank (cut = 3 records), giving 13 genera. The co-detected links of all genera are shown in Supplementary Fig. 2c, which uses the same evidence with a different selection.
- iPHoP endpoint (d): of 200 vOTU records, 127 had a resolved predicted host genus detected in the 16S dataset; of these, 83 were co-detected with the vOTU in at least one sample on the breadth-masked vOTU table (80 in one sample, 3 in two or more) and 44 never occurred in the same sample as the vOTU. 70 had a resolved genus not detected in 16S and 3 no resolved genus, which differs from a named genus that was not detected.
- CRISPR endpoint (d): strict edges require overall iPHoP confidence ≥ 90, CRISPR component score ≥ 90 and a raw spacer hit to the same genus; the genus match is exact, but only 10 of the edges have zero spacer mismatches.
- CRISPR endpoint (d): of 29 vOTU–host genus edges (25 vOTUs, 22 genera), 13 had the host genus co-detected with the vOTU in at least one sample on the breadth-masked vOTU table (13 of them in a single sample; 15 with unmasked counts), 3 more had the genus present in 16S without co-detection and 13 had no 16S match; no edge lacks a resolved genus.
- The two rows overlap and are not additive: all 25 CRISPR vOTUs are among the 200 iPHoP records, and 23 of the 29 edges are the same vOTU–genus link as that vOTU's iPHoP record (the others are further genus predictions for the same vOTUs).
- 16S detection (d) is a genus-level match over the whole 16S dataset (filtered counts before rarefaction; each row keeps the genus table of its original analysis); co-detection additionally requires the vOTU (breadth-masked count > 0) and the genus (16S count > 0) in the same sample. Depth diagnostics are in Supplementary Fig. 1b; PERMANOVA and dispersion tests are in Data 1 S10 and S11.

## Figure 3

*Candidate auxiliary metabolic functions, their carriers, defense-related calls and one candidate locus*

- Candidate AMG KOs (a): the 138 AMG candidate KOs are carried by 544 vOTUs (560 when all database identifiers are counted). Selecting by abundance shows the largest contributions, not all functions or their biological importance; K13522 (nadM, †) is a prespecified NARP case at abundance rank 13, not part of the top ten.
- K00558 (a): DNA cytosine-5-methyltransferase, carried by 146 vOTUs in this AMG table; its pathway label alone does not indicate enhanced sulfur metabolism.
- Data 1 (a, b): the full 138-KO and 68-pathway matrices and the per-carrier contributions.
- Tool-specific sets (c): DefenseFinder anti-defense 106, filtered dbAPIS 715, both 99, union 722 (106 + 715 − 99); DefenseFinder defense 5 and PADLOC 31; DefenseFinder NARP1 3 and NARP2 5 module calls. A separate KO co-occurrence rule (K03462 + K13522) gives six vOTUs (Supplementary Fig. 3).
- vOTU0052 (d): 132,528 bp; CheckV Medium-quality, 88.84% estimated completeness. ORF coordinates 42,702–43,781, 43,790–44,425 and 44,422–45,891 bp, all on the plus strand. The separate atd1 call on ORF166, about 45 kb away, is not part of this neighbourhood.

## Figure 4

*Candidate VF-carrier shares, carrier composition and lifestyle-definition sensitivity*

- Panel b mark details: Strict match requires at least one qualifying strict hit, not every hit. All hits excluded removes the candidate-carrier designation under regional definitions, not the sequence from the catalogue. If both marks apply, this does not imply retention under strict matching with region exclusion. Blank marks do not establish biological absence, lack of uncertainty or viral localization. Reference-function labels and +n do not validate whole systems.
- Panel a: fixed full-catalogue denominator; eligibility changes only, with no trimming or re-alignment. These are carrier-sequence shares, not VF gene abundance, expression, virulence or water concentration.
- Panel a: region exclusion alone takes gc1 from 9.95% to 6.69%, while strict annotation gives 0.54%. Four zero bars are the two strict definitions in oc1 and od1.
- Panel b: source values and all 114 carriers remain in Data 1 S47, annotation evidence in S48, and sample totals in S46. The displayed 18 rows are selected by maximum individual share, not per-sample top lists. Their column sums are not panel a's totals.
- Panel b: whether any filtered hit of a carrier has a CheckV region prediction is not drawn as a separate column. Among the 18 displayed carriers it applies exactly to the three rows marked All hits excluded (vOTU0073, vOTU0016, vOTU2681); this holds for this selection only, and the field remains in Data 1 S48 and Supplementary Note 3. Grey tiles mark carriers that do not meet whole-contig detection in that sample; zero bars in (a) mean no qualifying carrier. Neither denotes biological absence.
- Panel b: Strict match and All hits excluded are independent marks; vOTU0016 carries both. Contig-level detection (whole-contig breadth ≥ 75%) does not prove read coverage of each annotated VF locus, and function labels are sequence-level annotations rather than per-sample gene detection. Tile colour is carrier-sequence abundance, not VF locus coverage, expression, virulence or water concentration.
- Model set (c): 3,013 vOTUs have an estimated CheckV completeness; the 47 without it remain in the full catalogue and are excluded from these models only. All four models use filtered matching criteria, not the strict 40/80 threshold.
- Full-catalogue and model scopes: 143 hits = 18 predicted host + 1 boundary + 1 predicted viral + 123 without a region prediction; 142 model hits = the same 20 localized hits + 122 without prediction. Regional retention leaves 124 catalogue hits and 123 model hits; the two occurrences of 123 are different sets.
- Offsets (c): all-hits rows use log(contig length / 1000), regional rows use log(retained viral length / 1000), differing only for the 19 flagged records. Both hit counts and length denominators change; their contributions are not separated.
- Lifestyle (c): temperate if VIBRANT lysogenic OR geNomad provirus OR CheckV provirus OR Replidec temperate. Excluding only the CheckV branch changes 16 labels (260 to 244 temperate), while leaving all counted hits and the full-length offset unchanged. Neither label is an experimentally established lifestyle.
- IRRs (c): 2.52, 1.05, 0.95 and 1.00 under the four dependent definitions. They are catalogue-level per-kilobase hit-rate comparisons, not sample-level abundance or treatment effects.

## Figure 5

*A local observation and a separate global reference*

- Bins (a): 3–19, 20–39, 40–59, 60–79, 80–119, ≥120 genes; every vOTU falls in one bin, so the last bin is open-ended; 17 of 18 vOTUs in the highest bin carry a candidate. The gene count is the number of genes predicted on the recovered sequence. No fitted line, confidence interval or trend test is drawn.
- Reference models (b): each feature is fitted as binary presence against log10(CDS count) with a logit link; points are jittered vertically only. The two sets come from the same reference catalogue and are not two independent cohorts; the median describes the fixed set rather than testing one set against the other.
- Support check (c): profiles are ordered by coefficient and split into two columns of 19 rows, the right column continuing the order of the left; each column has its own axis on the same coefficient scale; exact coefficients are in Data 2. This is a support check on the same reference set, not a further replication. Supplementary Note 4 summarizes the global sensitivity analyses and limits, with direct navigation to the complete Data 2 tables.

## Supplementary Figure 1

*Catalogue quality and detection diagnostics*

- Panel a: no length threshold beyond the catalogue's own is applied; Undetermined is the CheckV label Not-determined.
- Panel c: expected features use the analytical rarefaction expectation (Hurlbert), so no random draws or seed are involved. Virome counts are rounded as in the alpha analysis. The 16S curves use the 3,093 filtered ASVs before rarefaction (one more than the 3,092 retained after the rarefaction draw). The earlier panel of observed richness as a percentage of Chao1 was withdrawn: its viral values used unmasked counts, and Chao1 is not interpretable for denoised and filtered ASV tables (Deng, Umbach and Neufeld 2024).
- Panel c: common depths, virome 1,648,195 breadth-masked reads; 16S 63,564 reads; 18S 53,257 reads of the full 18S table, drawn before Metazoa are removed. The unmasked virome counts have no common depth in this study.
- Data 1 S10/S11: PERMANOVA used 999 unrestricted permutations; betadisper requested 9,999 and, with seven samples, enumerated all 5,039 non-identity orderings (5,040 with the observed one), so 0.0002 (1/5,040) is its smallest attainable p. Data 1 S09: Mantel r uses Spearman correlation and 999 permutations; the Procrustes correlation is full-rank (six axes for seven samples), so only its permutation p is informative; the RV coefficient is descriptive, with no permutation test in this study.

## Supplementary Figure 2

*Seven-sample membership sharing, abundance contributions and candidate hosts*

- Panels a/b: bit order follows the configured sample order bc1, bd1, bc2, gc1, gd1, oc1, od1. A member qualifies when covered_fraction is at least the registered 0.75 threshold and masked trimmed mean depth is positive. All catalogue members remain in the sharing register; only observed nonempty patterns are drawn, and no vOTU qualifies in all seven samples. Sharing with any other of the seven samples is different from the designated same-site comparisons in Supplementary Note 5. Each sample's abundance denominator is its full masked catalogue depth sum; differences in sequencing depth can affect breadth qualification, so normalized percentages do not establish equal detection opportunity or concentration.
- Panel a totals: 3,060 vOTUs in 26 observed patterns; none qualifies in all seven samples.
- Shared members (a): 296 vOTUs qualify in at least two of the seven samples; 18 of them have a retained high-score (iPHoP ≥ 90) best-host record, with predicted host phyla Bacteroidota 8, Pseudomonadota 7, Asgardarchaeota 2, Bacillota 1, and 278 have none. This is not a host census of all 296.
- Panel c totals: 83 of the 200 high-score best-host records are drawn, linked to 43 genera, giving 86 sample-specific co-detections.
- Panel c: co-detection requires the vOTU to qualify in a sample (breadth ≥ 0.75 and positive masked depth) and its predicted host genus to have a positive count in the retained 16S table of that sample; iPHoP score ≥ 90. Six of the 83 vOTUs qualify in at least two samples, but only 3 have their host genus detected in more than one of those samples, so a single-sample link does not mean a single-sample virus. Exact vOTU IDs, scores and co-detection samples are listed in the Supplementary Figure 2 link table, FigureS2-links.tsv (Data 1 S12 and S49 hold all 200 records and every sample cell).
- Panel c and Figure 2d use the same evidence with different selections: Figure 2d shows the top ten predicted genera by catalogue vOTU count (ties kept), whereas c shows every co-detected record.

## Supplementary Figure 3

*NARP candidates, local neighbourhoods and ORF102 structural context*

- Panel a: in this dataset the five DefenseFinder NARP2 vOTUs are within the six of the KO rule, which are within the 19 dbAPIS vOTUs, and the three NARP1 vOTUs share none with NARP2 or the KO rule but are among the 19 dbAPIS vOTUs; this is an observation here, not a general confidence ladder. The 19 rows are the union of the four definitions, so a vOTU positive under any one of them is listed. Column codes: N1 and N2, DefenseFinder NARP1 and NARP2; KO, the K03462 + K13522 co-occurrence rule; db, dbAPIS NARP-targeting hits. The definitions overlap and are not independent validations. Completeness is shown with one decimal; exact values are in Data 1 S25.
- Panel b: abundances are read from the virome TSE (masked trimmed TPM); the panel shows where these vOTUs pass the detection threshold, not their importance. Four of the five NARP2 vOTUs pass it in gd1, and vOTU0113 also in gc1. vOTU0863 meets the KO rule without a DefenseFinder NARP2 call, and vOTU1898 carries nadM but meets neither the KO rule nor a NARP2 call; neither is a NARP2 call. Completeness is shown once, in a. Grey tiles mark samples where the detection criterion was not met; they do not denote biological absence.
- Panel c: gene coordinates come from the DRAM-v annotation table; the member genes of the five NARP2 calls equal Data 1 S42 and the vOTU0052 locus rows are in Data 1 S26. No cross-row homology, synteny or insertion event is inferred. Rows marked † (vOTU0131, vOTU1643) are reversed for display. ORF22 and ORF27 of vOTU0131 carry DRAM-v VOGdb descriptions (Probable mobile endonuclease D; REFSEQ homing endonuclease), whereas ORF102 domains come from the separate hmmscan/Pfam-A record (Supplementary Note 1).
- DefenseFinder hits on vOTU0052 (Data 1 S27): i-E-value is the independent E-value; the atd1 hit lies at 91,206–91,499 bp and is not part of the ORF101–ORF103 neighbourhood.
- Panel d: ORF102 (211 aa), N-terminal GIY-YIG catalytic domain (residues 3–87) and C-terminal I-HmuI NUMOD-like domain (153–184; envelope 143–188, an alignment-related span rather than a third domain). The full-length ESMFold2 model has mean pLDDT 0.889; the cross-region PAE between the two domains is 24.7 Å, so their arrangement is uncertain. The local GIY-YIG comparison with I-TevI (PDB 1MK0) pairs 80 Cα atoms (RMSD 2.38 Å). These are fold-consistency observations from the stored model; no prediction or alignment was re-run.
- The locus-depth summary (five contig-sample rows) and the reference-window comparison (two windows with their denominators, observed and expected counts, reported p-values and limits), drawn as panels in earlier versions, are in Supplementary Note 1, Tables A and B; these negative checks cannot exclude amplification or association.
- The functional-carrier host background of the Figure 3a KOs, a panel of earlier versions, is Supplementary Note 1, Table C and Data 1 S22.
- Global context: under the archived module definition NARP1 and NARP2 were called in 566 and 166 of the 77,951 reference genomes of Fig. 5, with no joint call; NARP profiles are excluded from the fixed 38 non-NARP set, so this is context rather than replication.
- Transcribed values (d and Supplementary Note 1): file and line of each value are listed in Data 1 S28.

## Supplementary Figure 4

*Regional scope and genomic positions of candidate VF matches*

- Panel c (vOTU1009): the dashed line marks the CheckV boundary at 12,974/12,975 bp; the ORF23 HSP spans 762 nt in the predicted viral and 0 nt in the host region, and the ORF28 HSP 10 nt and 560 nt, respectively.
- Detailed scope, all six primary length/flank groups, individual retention and model-cohort accounting: Supplementary Note 3 and Data 1.
- Catalogue regional exclusion retains 124/143 matches; Figure 4 models retain 123/142, in a different scope. Unlocalized does not mean viral.

