# Supplementary Note 5. Process-water and nearby-water contributions

## Scope and definitions

The three comparisons use the designated same-location records in Data 1 S07: bd1/bc1, gd1/gc1 and od1/oc1. They contrast treatment-process water with nearby water after facility outflow; they do not establish hydraulic tracking of the same water. bc2 has no designated d counterpart and remains in the seven-sample analyses without being pooled into a pair.

A vOTU qualifies in a sample when its saved trimmed mean depth is positive after the whole-contig coverage-breadth threshold of 75% is applied. That mask was decided at full depth, not recalculated after rarefaction. Shared means qualified at both positions; position-only means qualified at one position and not at the other, not biological absence. The reference catalogue is fixed, but the qualifying set is sample-specific.

For each sample, the contribution is 100 times the sum of masked trimmed mean depth of the specified members divided by the masked depth sum over the entire catalogue in that sample. No renormalization within shared members or candidate carriers is applied. A VF conditional share uses that sample's VF-carrier total instead; it is NA when the total is zero. Region exclusion changes eligibility, not the retained contig abundance. All four existing annotation definitions are reported in Data 1 S55; they form overlapping subsets of F0 and are sensitivity settings, not replicates.

## Whole-catalogue contributions (Data 1 S54)

| Location | Sample | Position | Qualified vOTUs | Shared vOTUs | Shared contribution (%) | Position-only contribution (%) |
|---|---|---|---:|---:|---:|---:|
| Beijing | bd1 | Process water | 793 | 70 | 1.31 | 98.69 |
| Beijing | bc1 | Nearby water | 991 | 70 | 44.78 | 55.22 |
| Garching | gd1 | Process water | 533 | 59 | 12.90 | 87.10 |
| Garching | gc1 | Nearby water | 60 | 59 | 99.59 | 0.41 |
| Oberschleissheim | od1 | Process water | 274 | 60 | 38.79 | 61.21 |
| Oberschleissheim | oc1 | Nearby water | 124 | 60 | 70.70 | 29.30 |

The fixed shared set contributes different fractions at the two positions. Numbers of shared members are not retention probabilities and must not be ranked across locations without their qualifying catalogue context. These are relative carrier-sequence contributions, not absolute viral concentrations, transport, persistence or removal efficiencies.

## VF-carrier contributions and mapping diagnostics

Data 1 S55 gives the complete symmetric decomposition for both positions under F0 (filtered), F1 (filtered with region exclusion), S0 (strict), and S1 (strict with region exclusion). Figure 4b displays only the selected carriers and is not a complete contribution ledger. The machine-readable comparison register accompanies this Note and retains every catalogue vOTU, including members qualifying at neither position.

For position-only members, the tables separately count opposite-side mapping with subthreshold breadth, no saved mapping signal (count, depth and breadth all zero), and breadth passing with zero trimmed depth. Positive count with zero trimmed depth is not the total mapped-member count. Weak mapping is diagnostic only: conserved-sequence cross-mapping and true low abundance have not been distinguished. It neither proves absence nor establishes that observed differences are solely technical. The counts and independent depth denominators are in Process_input_diagnostics.tsv.

No treatment-effect model, new significance test, alternative breadth threshold, read alignment, concentration estimate or source-tracking model was fitted for this descriptive summary.

Sources: saved 012 TSE assays, 020 designated comparisons, and 040 carrier definitions and abundance; derivations recorded in the formal workflow and Data 1 field dictionary.
