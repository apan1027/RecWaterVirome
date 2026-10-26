# Supplementary Data 1 companion tables

These two TSV files are byte-identical copies of the existing workflow outputs, not new analyses. See Supplementary Note 5. They accompany, rather than replace, worksheets S54–S55 and S58.

- Supplementary_Data_1_input_diagnostics.tsv: seven sample-level input/detection diagnostics.
- Supplementary_Data_1_comparison_members.tsv: all 3,060 representatives for each of the three designated comparisons (9,180 rows), including members qualifying on neither side.

Stable internal field names are preserved. `process_sample` and suffix `_D` refer to wastewater (d); `nearby_sample` and suffix `_C` refer to reclaimed water (c). `member_set` codes process_only_qualified/nearby_only_qualified retain these same labels. They are computational keys, not additional water categories. `detected_D/C` denote qualification using positive breadth-masked depth under the stated threshold. `percent_D/C` use the whole sample-specific breadth-masked catalogue denominator. `count_D/C`, `trimmed_depth_D/C` and `breadth_D/C` preserve the saved unmasked count, trimmed-depth and breadth fields. `eligible_F0/F1/S0/S1` indicate membership of the corresponding candidate-carrier set, separate from sample-specific qualification.

Input diagnostics distinguish positive unmasked counts, the subset with zero trimmed depth, positive trimmed depth and qualification; the zero-depth subset is not the total mapped-member count. The breadth threshold and both depth sums are recorded explicitly. These are descriptive technical diagnostics, not environmental completeness, absolute load, removal or transmission estimates.
