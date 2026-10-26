# Figure 5. A local observation and a separate global reference

## Legend (English)

Figure 5 | A local observation and a separate global reference. The local observation is shown first and the separate reference second; they are not the same effect measured twice. (a) Local catalogue: percentage of vOTUs with at least one candidate anti-defense annotation (DefenseFinder anti-defense call or filtered dbAPIS hit; the union of Fig. 3c) in six ordered bins of predicted genes per recovered vOTU; labels give carriers/vOTUs in the bin (all 3,060 vOTUs, 722 carriers). The gene count does not separate recovery completeness from detection opportunity; no trend is fitted and the bins do not establish a cause. (b) Separate global reference: coefficient of every feature in two fixed sets, 285 metabolic-related Pfam domains (navy) and 38 non-NARP anti-defense profiles (ochre), each from a logit model of presence against log10(CDS count) in 77,951 Caudoviricetes reference genomes labelled Complete by their source. All features are shown, including negative coefficients; the vertical bar marks each set's median, with the numbers of positive and negative coefficients. The metabolic domains are a second fixed class, not a baseline or null, and the coefficients are associations with coding capacity, not functional demand. (c) All 38 anti-defense profiles of b, sorted by coefficient with the order continuing from the left column to the right; each column has its own axis on the same coefficient scale, beside carrier genomes and gene-sharing clusters; hollow diamonds and bold names mark the four profiles whose carriers fall in one cluster, which is not one genome; support counts are not confidence intervals. Panels a and b use different units and feature definitions; the global arm does not validate the local observation. Details: Supplementary figure notes, Figure 5. Abbreviations: CDS, coding sequence; NARP, NAD+ reconstitution pathway; vOTU, viral operational taxonomic unit.

## Interpretation guide

- What the figure shows: Local candidate anti-defense carriage rises across predicted-gene-count bins, reaching 17/18 in the highest bin. The separate global catalogue supplies coefficient distributions for 285 metabolic domains and 38 non-NARP anti-defense profiles, including negative values, plus carrier-genome and gene-sharing-cluster support for the same 38 profiles.
- Interpretation limits: Local and global panels are not on a common data axis; global results do not validate the local trend. A median is not a between-set test and a cluster is not a genome. The local pattern does not separate recovery completeness from detection opportunity and does not establish causation.

## Sources

- analyses/data/050-global-inputs/local_carriage_bins.tsv (production-inputs/local_carriage_bins_display.tsv)
- analyses/data/050-global-inputs/global_feature_fits.tsv, global_group_medians.tsv (dev/280 global_primary/full_feature_fits.tsv, fixed_universe.tsv)
- analyses/data/050-global-inputs/global_profile_support.tsv (global_fixed38_display.tsv; profile_cluster_support.tsv filtered to the fixed 38)

## Figure notes (detail; not part of the submission caption)

- Bins (a): 3–19, 20–39, 40–59, 60–79, 80–119, ≥120 genes; every vOTU falls in one bin, so the last bin is open-ended; 17 of 18 vOTUs in the highest bin carry a candidate. The gene count is the number of genes predicted on the recovered sequence. No fitted line, confidence interval or trend test is drawn.
- Reference models (b): each feature is fitted as binary presence against log10(CDS count) with a logit link; points are jittered vertically only. The two sets come from the same reference catalogue and are not two independent cohorts; the median describes the fixed set rather than testing one set against the other.
- Support check (c): profiles are ordered by coefficient and split into two columns of 19 rows, the right column continuing the order of the left; each column has its own axis on the same coefficient scale; exact coefficients are in Data 2. This is a support check on the same reference set, not a further replication. Supplementary Note 4 summarizes the global sensitivity analyses and limits, with direct navigation to the complete Data 2 tables.
