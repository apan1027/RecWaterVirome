# Supplementary Note 1. NARP2 locus annotation and exploratory context checks

This note accompanies Supplementary Fig. 3a, b and d (former panels b–d of the NARP figure, then Supplementary Fig. 2) and the NARP paragraph of the Results. It gives the reason for examining the vOTU0052 locus, the sequence-domain evidence behind the annotation of ORF102, and two exploratory checks of that locus: a read-depth summary (Table A) and a reference-position comparison (Table B). Earlier versions of the NARP figure drew these two checks as panels e and f. The domain and exploratory-check quantities are transcribed from the case documentation of the original analysis, with file and line in Data 1 S28; none was recomputed for this manuscript, no protein structure was predicted and no new statistical test was run.

## Selected locus and ORF102 annotation

vOTU0052 (132,528 bp) is the only medium-quality sequence among the five local DefenseFinder NARP2 calls (CheckV estimated completeness 88.84%); the other four are low-quality sequences (6.8–31.9%). It was examined because its recovery allows the gene neighbourhood to be inspected, not because it is the most abundant carrier, is ecologically most important or is functionally confirmed.

On vOTU0052, ORF101 and ORF103 form the DefenseFinder NARP2 call (profiles narp2_nmnat and narp2_nampt; Fig. 3d). The intervening ORF102 is a separate candidate gene, not a member of that call. A further DefenseFinder hit, atd1 on ORF166 about 45 kb away, is a distinct system call (Data 1 S27).

| Match on ORF102 | Residue interval | Reported independent E-value | Other recorded interval |
|---|---:|---:|---|
| GIY-YIG | 3–87 | 2.5 × 10⁻⁵ | — |
| I-HmuI NUMOD-like | 153–184 | 2.8 × 10⁻⁵ | envelope 143–188 |

ORF102 encodes a 211-aa protein; domains were matched by hmmscan against Pfam-A. The envelope of the NUMOD-like match is the alignment-related span reported by hmmscan; it is not a third domain or a confidence interval, and the sequence track of Supplementary Fig. 3d draws only the two match intervals, with no quantitative meaning in rectangle height. These sequence-domain matches support an HE-like annotation. They do not demonstrate protein folding, DNA cleavage, homing, NAD⁺ reconstitution or anti-defense activity. No verified three-dimensional model of ORF102 was available, and none is shown.

## Table A. Locus-to-contig median depth (formerly panel e of the NARP figure)

Question: was the median read depth over the NARP2 locus higher than over the rest of its contig, in the sample examined for each contig? This was an exploratory follow-up to a locus-amplification hypothesis; it does not test enzyme or anti-defense activity.

| vOTU | Contig | Locus | Examined sample | Locus median / contig median depth |
|---|---|---|---|---:|
| vOTU0052 | vctg2997 | GIY-YIG insertion | gd1 | 1.00 |
| vOTU0131 | vctg3454 | HNH/NUMOD3 insertion | od1 | 1.09 |
| vOTU0113 | vctg2633 | non-HE insertion | gc1 | 1.28 |
| vOTU1643 | vctg2728 | no insertion | gd1 | 0.91 |
| vOTU0544 | vctg2892 | no insertion | gd1 | 1.19 |

- The five rows are contig–sample summaries from three samples (gd1, 3; gc1, 1; od1, 1); they are not five independent replicates and not a between-group statistical comparison.
- Each contig was summarized in the one sample with the most mapped reads for that contig. That is not the only sample in which it was detected: vOTU0113 also met the detection criterion in gd1 (Supplementary Fig. 3b).
- The ratio is the median per-base depth across the locus divided by the median per-base depth across its whole contig (sliding windows were used only for position diagnostics in the original analysis). It is not the abundance of the virus in the sample.
- For vOTU0052 in gd1, the two medians coincide at the reported precision (ratio 1.00). The four comparison ratios range from 0.91 to 1.28, and three of them exceed 1; none is a matched control and no significance test was made.
- vOTU0052 is a medium-quality sequence and the four comparison contigs are low-quality, so their recovery contexts differ; no repeated series per contig is available.
- A population-median snapshot cannot exclude local depth peaks, amplification in a minority of genomes or amplification under an unobserved induction condition. A ratio of 1.00 shows neither that the assembly is error-free nor that the locus is inactive.

## Table B. HE-domain annotations near reference NARP2 modules (formerly panel f of the NARP figure)

Question: are homing-endonuclease (HE) domain annotations found more often than expected between, or near, the two member genes of reference NARP2 modules? This reference check does not involve the local samples and does not test activity.

The reference set is 104 NARP2 modules (NMNAT near NAMPT) among 1,369 NAMPT-positive INPHARED phage genomes with uniformly called ORFs. It is neither the seven local samples nor the 77,951-genome collection of Fig. 5. HE domains are Pfam GIY-YIG, HNH, LAGLIDADG and NUMOD families at their gathering thresholds.

| Window | Assessable modules / total | Observed genomes with an HE-domain annotation | Expected under the conditional null | Reported one-sided Poisson enrichment p |
|---|---:|---:|---:|---:|
| Strictly between the two member genes | 56/104 | 0 | 0.45 | 1.00 |
| Within ±10 ORFs of the module | 104/104 | 7 | 9.00 | 0.79 |

- The strict window can be assessed only when at least one ORF lies between the two member genes. In 48 of the 104 modules the two genes are adjacent and the strict window is empty; these modules are not failed or unexamined samples. Intervening ORFs: none in 48 modules, one in 42, two to four in 5 and six to nine in 9, so 56 = 42 + 5 + 9 modules are assessable.
- In the five local DefenseFinder NARP2 calls, counted from the recorded gene positions, the intervening ORFs number vOTU0052, 1; vOTU0113, 1; vOTU0131, 4; vOTU0544, 0; vOTU1643, 0. Four of the five are on low-quality sequences, and the vOTU1643 locus starts at bp 28 of its contig, so the spacing between its two genes is observed but the sequence beyond the contig end is not. One selected local case cannot estimate how often HE-like genes occupy this position.
- The expectation sums, over genomes, the probability that at least one HE-domain annotation falls in the window when each genome's own HE-domain count is placed at random among its ORFs (a null conditional on each genome's HE count and ORF count). Exchangeable positions are a modelling assumption, and shared ancestry among reference phages limits interpretation.
- The p-values are the one-sided Poisson enrichment values of the original report (1.00 and 0.79). They were not recomputed, do not test depletion, and do not establish equality or the absence of an association.
- With a strict-window expectation of 0.45, observing 0 gives little basis for excluding a modest enrichment: the strict window has limited sensitivity, although the test is not uninformative about every possible effect.
- The source document reports 16% power for the strict window and labels that scenario an odds ratio of 3. The original analysis script defines the scenario as a threefold increase in the Poisson expected count, not as an odds ratio. The 16% value is kept only as the historically reported figure; it was not recomputed or independently validated here.
- No record establishes whether the windows were specified before or after the data were examined; they are reported as defined in the original analysis.

## Sources

- Data 1 S28: every value in this note with the case document, line and verbatim source text (ORF102 domains: doc_votu0052_orf102.md line 138; Table A: doc_votu0052_coverage_spike.md lines 63, 64, 65, 66, 67; Table B: doc_votu0052_he_targeting.md lines 25, 27, 62, 66, 69, 75, 76). The S28 item text of the power row keeps the source label verbatim; its corrected meaning is given above.
- Data 1 S27: DefenseFinder gene rows of vOTU0052. Data 1 S52: per-sample abundance of the seven carriers in Supplementary Fig. 3b. Local gene spacing: gene positions of the five local NARP2 calls in the DRAM-v annotation table.
- The per-base depth vectors and the per-genome reference tables were not reanalysed for this note; Tables A and B repeat the reported summaries.

## Candidate host context

The retained iPHoP prediction for vOTU0052 was *Novosphingobium* (score 90.8); the vOTU and predicted host genus were co-detected in gd1. No strict CRISPR record was available for this vOTU and genus. This is candidate host context, not evidence of infection or of the host's metabolic functions (Data 1 S59).

The complete register retains all 544 AMG-export KO carriers, including those without a retained high-score host prediction; 36 have a retained high-score record and 16 have a co-detected primary predicted genus. The selected KO-carrier association paths are in Data 1 S60; their association counts are not carrier abundance.
