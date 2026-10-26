# v54 publication metadata overlay

Only Data1_local.xlsx!S37_gaps B2/C2 were corrected to distinguish the historical unexported curves from the current retained-table S50 rarefaction display. Detection masks remain fixed; this is not raw-read re-rarefaction or a new saturation claim. No scientific value or formula was changed. The frozen workflow, its workbook and step-record hashes remain byte-identical to v53.1.

`apply_metadata_patch.py` reads the frozen workbook and recreates the current publication workbook and Data1_S37_gaps.tsv by patching one worksheet XML part only. It never invokes the scientific workflow. `metadata-patch.json` records the exact text changes and both workbook hashes. A direct frozen-workflow export alone retains the historical text; apply this publication overlay to reproduce the current documentation.
