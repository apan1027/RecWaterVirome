# Supplementary Note 3. VF localization and controlled-construct checks

## Natural-catalogue scope

| Localization | Matches |
| --- | --- |
| Predicted host |  18 |
| Boundary-crossing |   1 |
| Predicted viral |   1 |
| No region prediction | 123 |

The complete catalogue contains 143 filtered VFDB-A matches on 3,060 representatives. Region exclusion retains 124 matches, including the 123 with no region prediction; retention does not establish viral localization.

All eight VF-bearing CheckV-flagged sequences, all 17 region segments and all 20 localized hit intervals are displayed in Supplementary Figure 4b (the localization scope of all 143 matches in 4a; the vOTU1009 boundary zoom in 4c). Their unchanged coordinates are in Data 1 S29–S31; complete match-level scope is in S48. Homology and predicted boundaries do not validate toxicity, infection, host transfer or biological activity.

## Controlled-construct endpoints

| Endpoint | Count | Denominator |
| --- | --- | --- |
| Constructs without an added flank that were flagged |   0 | 512 |
| Primary flanked constructs without a provirus flag | 315 | 720 |
| Primary flanked constructs retaining < 95% of viral bases |  33 | 720 |

The 512 unflanked controls pool series B (270) and C (242) descriptively. The other two endpoints use only the 720 primary flanked constructs in series C. The 315 unflagged constructs were retained whole, including the added host flank. They are distinct from the 33 constructs retaining less than 95% of viral bases; the endpoints must not be added into a total error rate. Repeated constructs derived from the same mother genome are not independent biological samples. Exploratory series B flanked constructs and longer non-primary series C constructs are outside this primary denominator.

### Primary window-length and flank groups

| viral_window_bp | flank_percent | flagged | constructs | flagged_fraction |
| --- | --- | --- | --- | --- |
| 12500 | 10 | 17 | 120 | 0.141667 |
| 12500 | 20 | 68 | 120 | 0.566667 |
| 17500 | 10 | 39 | 120 | 0.325 |
| 17500 | 20 | 93 | 120 | 0.775 |
| 30000 | 10 | 77 | 120 | 0.641667 |
| 30000 | 20 | 111 | 120 | 0.925 |

Lengths can be compared only while holding flank proportion fixed. Detailed strata are retained in Data 1 S35 and S41.

### Individual retention below 95%

The saved table contains 33 selected sub-threshold constructs, not all 720 constructs. Minimum viral retention is 64.0%. High average retention does not guarantee retention for an individual construct. The full 33-record table is Data 1 S36.

| id | requested_viral_length_bp | host_percent_requested | viral_retention | host_removed |
| --- | --- | --- | --- | --- |
| NC_028969.1_window_L17500_r2_h20_old | 17500 | 20 | 0.6401714 | 0.4998857 |
| NC_041976.1_window_L12500_r1_h20_old | 12500 | 20 | 0.6936800 | 1.0000000 |
| NC_028969.1_window_L12500_r1_h20_old | 12500 | 20 | 0.8093600 | 0.9846400 |
| NC_041976.1_window_L30000_r2_h20_old | 30000 | 20 | 0.8413000 | 1.0000000 |
| NC_048109.1_window_L30000_r2_h10_old | 30000 | 10 | 0.8633000 | 1.0000000 |
| NC_028969.1_window_L17500_r1_h20_new | 17500 | 20 | 0.8784000 | 1.0000000 |
| NC_041976.1_window_L30000_r2_h10_old | 30000 | 10 | 0.8998333 | 0.5001500 |
| NC_049944.1_window_L17500_r2_h20_new | 17500 | 20 | 0.9053143 | 1.0000000 |
| NC_048109.1_window_L17500_r2_h20_new | 17500 | 20 | 0.9085714 | 1.0000000 |
| NC_070844.1_window_L17500_r1_h20_old | 17500 | 20 | 0.9100571 | 0.4998857 |
| NC_048194.1_window_L17500_r2_h20_old | 17500 | 20 | 0.9135429 | 1.0000000 |
| NC_074749.1_window_L12500_r2_h20_old | 12500 | 20 | 0.9152800 | 0.5001600 |
| NC_048109.1_window_L30000_r2_h10_new | 30000 | 10 | 0.9204333 | 0.4998500 |
| NC_031014.1_window_L12500_r2_h20_old | 12500 | 20 | 0.9247200 | 0.5001600 |
| NC_047890.1_window_L17500_r1_h10_new | 17500 | 10 | 0.9260000 | 0.5000000 |
| NC_047890.1_window_L17500_r1_h20_new | 17500 | 20 | 0.9260000 | 0.5001143 |
| NC_047829.1_window_L30000_r1_h20_old | 30000 | 20 | 0.9306000 | 0.5000000 |
| NC_003278.1_window_L12500_r1_h20_old | 12500 | 20 | 0.9354400 | 0.5001600 |
| NC_048109.1_window_L30000_r2_h20_old | 30000 | 20 | 0.9428667 | 0.9977333 |
| NC_013638.1_window_L17500_r2_h20_new | 17500 | 20 | 0.9441143 | 1.0000000 |
| NC_052657.1_window_L17500_r2_h20_new | 17500 | 20 | 0.9443429 | 0.9938286 |
| NC_052657.1_window_L17500_r2_h20_old | 17500 | 20 | 0.9443429 | 0.9954286 |
| NC_052657.1_window_L17500_r2_h10_new | 17500 | 10 | 0.9443429 | 0.5000000 |
| NC_052657.1_window_L17500_r2_h10_old | 17500 | 10 | 0.9443429 | 0.9897119 |
| NC_013638.1_window_L17500_r2_h20_old | 17500 | 20 | 0.9458857 | 0.5001143 |
| NC_052663.1_window_L12500_r2_h20_new | 12500 | 20 | 0.9469600 | 1.0000000 |
| NC_047890.1_window_L30000_r2_h20_new | 30000 | 20 | 0.9473000 | 0.9952000 |
| NC_047890.1_window_L30000_r2_h20_old | 30000 | 20 | 0.9473000 | 0.9996000 |
| NC_019520.1_window_L30000_r2_h10_new | 30000 | 10 | 0.9478667 | 0.5001500 |
| NC_028969.1_window_L17500_r2_h10_new | 17500 | 10 | 0.9478857 | 0.5000000 |
| NC_047918.1_window_L17500_r1_h20_old | 17500 | 20 | 0.9485714 | 0.5001143 |
| NC_031056.1_window_L17500_r1_h10_old | 17500 | 10 | 0.9499429 | 1.0000000 |
| NC_031056.1_window_L17500_r1_h20_old | 17500 | 20 | 0.9499429 | 1.0000000 |

## Catalogue-to-model scope

| step | n | note |
| --- | --- | --- |
| catalogue | 3060 | Figure 1 and Figure 5 denominator |
| completeness not estimated (CheckV Not-determined) | 47 | excluded only from models needing the completeness covariate; kept in the catalogue |
| model set | 3013 | four saved models |

The 47 representatives without a CheckV completeness estimate remain in the catalogue but are excluded from the four saved models (Data 1 S33, S40). The single GroEL match on vOTU2169 accounts for the 143-to-142 match difference. The models contain 142 total and 123 region-retained matches; 122 of those retained matches have no region prediction. The full catalogue instead has 143 total and 124 retained matches, including 123 without a region prediction. The two occurrences of 123 denote different sets.

## Sequence-level lifestyle model specifications

| Model | Lifestyle rule | Counted hits | Length offset | vOTUs | Temperate vOTUs | Hits |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | temperate if VIBRANT lysogenic OR geNomad Provirus OR CheckV provirus OR Replidec temperate | all filtered VF hits | log(contig length / 1000) | 3013 | 260 | 142 |
| 2 | temperate if VIBRANT lysogenic OR geNomad Provirus OR CheckV provirus OR Replidec temperate | filtered hits minus predicted-host and boundary-crossing hits | log(retained viral length / 1000); full contig length where CheckV predicted no region | 3013 | 260 | 123 |
| 3 | the same disjunction without the CheckV branch | all filtered VF hits | log(contig length / 1000) | 3013 | 244 | 142 |
| 4 | the same disjunction without the CheckV branch | filtered hits minus predicted-host and boundary-crossing hits | log(retained viral length / 1000); full contig length where CheckV predicted no region | 3013 | 244 | 123 |

All four are negative-binomial models of filtered VF hit counts per vOTU, comparing predicted-temperate with predicted-virulent vOTUs, with the CheckV completeness estimate as a covariate and log length in kilobases as an offset; they use the same 3,013 vOTUs, are dependent sensitivity analyses and were not combined. Regional exclusion removes predicted-host and boundary-crossing hits and replaces the full contig length by the retained viral length in the same model, so the two changes are not separated. The lifestyle change drops only the CheckV provirus branch. Estimates and Wald intervals are shown in Figure 4c and listed in Data 1 S32. These four sequence-level specifications are distinct from the four sample-level annotation definitions of Figure 4a (filtered or strict matching, each with or without region exclusion; Supplementary Methods, Sample-level abundance of candidate virulence-factor carriers).

## Interpretation and sources

Artificial constructs characterize CheckV detection and trimming on near-reference sequence. They do not estimate error rates for the natural water-sample catalogue. Region and lifestyle definitions share CheckV information; in the two Figure 4c settings with regional exclusion, hit inclusion and the length offset change together and their individual effects are not isolated. Candidate carrier abundance is not VF expression, concentration or water-health risk. The c/d labels follow the sample descriptions (d, treatment-process water; c, nearby water after facility outflow) and are not verified treatment stages.

Sources: saved outputs of step 040: construct_endpoints.tsv, construct_detection.tsv, construct_below95.tsv, vf_model_bridge.tsv, vf_models.tsv, vf_hits.tsv, checkv_regions.tsv, checkv_flagged_records.tsv and vf_hit_catalogue.tsv. Data 1 S29–S36, S40–S41 and S48 preserve the scientific records. No annotation, model fit, threshold or statistical test was recomputed for this rearrangement.

## Descriptive carrier proportions by lifestyle label

Data 1 S61 retains unadjusted carrier proportions for AMG-export, anti-defense and all four VF definitions under both lifestyle rules, using the entire catalogue. Each vOTU is counted once per candidate set; sets can overlap. These binary proportions have a different endpoint and population from the completeness-adjusted hit-rate models above.

Under the original rule, median recovered sequence lengths were 27,458 and 15,642.5 bp in the temperate and virulent groups, respectively, with median available CheckV completeness 46.45% and 29.62%. Recovery and classification opportunity may differ between these groups; the descriptive proportions do not establish functional enrichment.
