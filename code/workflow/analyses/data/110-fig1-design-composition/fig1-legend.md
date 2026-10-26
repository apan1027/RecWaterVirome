# Figure 1. Study design and composition of the three assays

## Legend (English)

Figure 1 | Study design and composition of the three assays. (a) Seven water samples from three sites (Beijing: bc1, bd1, bc2; Garching: gc1, gd1; Oberschleissheim: oc1, od1), each profiled once by viral metagenomics and by 16S and 18S rRNA gene amplicon sequencing (21 assay records, not 21 independent samples). Map points are regional anchors (Beijing; the mean of the Garching and Oberschleissheim municipality coordinates), not sampling points. In the available sample descriptions, d denotes treatment-process water and c nearby water after facility outflow; these process positions are not verified hydraulic pairs, and bc2 has no designated d counterpart. (b–d) Relative composition within each assay; bars sum to 100% and are not comparable as absolute biomass across assays. The strip under each bar marks the site. (b) Viral classes (all 8 source labels) as shares of vOTU trimmed TPM after breadth masking at 75%; the expanded view replots the same values, without renormalization, for the classes other than Caudoviricetes on a 0–15% axis. (c) GTDB phyla as shares of retained 16S reads (archaeal phyla fall in Other). (d) Microeukaryotic divisions as shares of the 18S reads retained after removal of Metazoa, so Opisthokonta is non-metazoan. In c and d the eight taxa with the highest seven-sample mean are named, other named taxa are merged into Other and Unclassified is kept separate; colours do not link taxa across panels. (e) CheckV completeness classes of all 3,060 representative vOTU sequences (Low-quality: estimated completeness below 50%); they estimate genome recovery, not sequencing-read quality. Details: Supplementary figure notes, Figure 1; the full composition is in Data 1. Abbreviations: vOTU, viral operational taxonomic unit; TPM, abundance normalized to one million per sample; GTDB, Genome Taxonomy Database.

## Interpretation guide

- What the figure shows: Seven samples (Beijing 3, Garching 2, Oberschleissheim 2) each have three sequencing assays. Panels show within-assay composition and sample differences, and all five CheckV categories; 73.7% of 3,060 vOTUs are Low-quality.
- Interpretation limits: Do not compare absolute biomass across assays, interpret c/d as before/after treatment, treat regional markers as sampling locations, equate Low-quality with poor sequencing-read quality, or count 21 assay records as independent samples. Viral composition uses breadth >= 75% masked trimmed-mean coverage normalized to one million per sample; viral alpha uses masked read counts with repeated rarefaction. Both are masked but use different quantities and normalizations.

## Sources

- analyses/data/020-community-analysis/composition_display.tsv, taxon_display_map.tsv (computed in 012/020 from the migrated primary tables; 014 checks them against production-inputs/composition_full.tsv: numerically consistent under the registered comparison tolerance in step 014)
- analyses/data/020-community-analysis/checkv_catalogue.tsv (CheckV quality_summary.tsv joined through the read-only vOTU map)
- analyses/data/020-community-analysis/samples.tsv (S1_sample_metadata.tsv)
- config/site-locations.tsv (city representative coordinates and their public sources); rnaturalearthdata::countries50 (Natural Earth 1:50m admin-0, public domain)

## Figure notes (detail; not part of the submission caption)

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
